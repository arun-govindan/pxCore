@echo on
@rem  Script to build spark (aka pxscene) on
@rem  Windows platform (locally and on AppVeyor)
@rem
@rem  Author: Damian Wrobel <dwrobel@ertelnet.rybnik.pl>
@rem
@rem
@rem  Assumes the following components are pre-installed:
@rem    - Visual Studio 2017,
@rem    - NSIS(>3.x), cmake(>2.8.x), python(2.7.x), 7z (all added to PATH).
@rem

cmake --version
python --version

set "ORIG_DIR=%CD%"

cd %~dp0
cd ..
set "BASE_DIR=%CD%"

set "VSCMD_START_DIR=%CD%"
call "C:/Program Files (x86)/Microsoft Visual Studio/2017/Community/VC/Auxiliary/Build/vcvars32.bat" x86



@rem build dependencies
cd examples/pxScene2d/external
call buildWindows.bat
if %errorlevel% neq 0 exit /b %errorlevel%

@rem Avoid using link.exe from that paths
set PATH=%PATH:C:\Program Files\Git\usr\bin;=%
set PATH=%PATH:c:\Program Files\Git\usr\bin;=%
set PATH=%PATH:C:\cygwin64\bin;=%
set PATH=%PATH:c:\cygwin64\bin;=%

cd "%BASE_DIR%"
md build-win32
cd build-win32
set addVer=false
@rem build pxScene
echo.trace0
if "%APPVEYOR_SCHEDULED_BUILD%"=="True" (
   echo "building edge"
cmake -DCMAKE_VERBOSE_MAKEFILE=ON -DPXSCENE_VERSION="edge" ..
)

for /f "tokens=1,* delims=]" %%a in ('find /n /v "" ^< "..\examples\pxScene2d\src\win\pxscene.rc" ^| findstr "FILEVERSION" ') DO ( 
			echo trace 1 %%b
			call set verInfo=%%b
	)
	call set verInfo=%verInfo:~12%
	call set verInfo=%verInfo:,=.%
	echo. %verInfo%

	if "%APPVEYOR_FORCED_BUILD%"=="True" cmake -DCMAKE_VERBOSE_MAKEFILE=ON -DPXSCENE_VERSION=%verInfo% ..
	if "%APPVEYOR_REPO_TAG%"=="True" cmake -DCMAKE_VERBOSE_MAKEFILE=ON -DPXSCENE_VERSION=%verInfo% ..
	
cmake --build . --config Release -- /m
if %errorlevel% neq 0 exit /b %errorlevel%

cpack .
if %errorlevel% neq 0 exit /b %errorlevel%

@rem create standalone archive
cd _CPack_Packages/win32/NSIS
7z a -y pxscene-setup.zip pxscene-setup

cd %ORIG_DIR%

@rem deploy artifacts
@rem based on: https://www.appveyor.com/docs/build-worker-api/#push-artifact


        @rem NSIS based installer
        appveyor PushArtifact "build-win32\\_CPack_Packages\\win32\\NSIS\\pxscene-setup.exe" -DeploymentName "installer" -Type "Auto" -Verbosity "Normal"

        @rem Standalone (requires no installation)
        appveyor PushArtifact "build-win32\\_CPack_Packages\\win32\\NSIS\\pxscene-setup.zip" -DeploymentName "portable" -Type "Zip" -Verbosity "Normal"



