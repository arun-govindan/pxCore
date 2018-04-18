@where msbuild 2> nul
@if %errorlevel% neq 0 (
 @echo.
 @echo Please execute this file from inside Visual Studio's Developer Command Prompt
 @echo.
 pause
 goto :eof
)
@echo off
setlocal enabledelayedexpansion

echo. =================================== starting of buildWindows
time /t

copy /y libjpeg-turbo-1.5.1\win_temp\* libjpeg-turbo-1.5.1\
copy /y curl-7.40.0\include\curl\curlbuild-win.h curl-7.40.0\include\curl\curlbuild.h
copy /y libpng-1.6.28\scripts\pnglibconf.h.prebuilt libpng-1.6.28\pnglibconf.h
copy /y jpeg-9a\jconfig.vc jpeg-9a\jconfig.h

echo. =================================== starting of buildWindows
time /t



set buildExternal=0
set buildLibnode=0

if NOT "%APPVEYOR_SCHEDULED_BUILD%"=="True" (
  git diff-tree --name-only --no-commit-id -r %APPVEYOR_REPO_COMMIT%	
  echo -----------------------
  FOR /F "tokens=* USEBACKQ" %%F IN (`git diff-tree --name-only --no-commit-id -r %APPVEYOR_REPO_COMMIT%`) DO (
    echo.%%F|findstr "zlib-1.2.11 WinSparkle pthread-2.9 libpng-1.6.28 libjpeg-turbo-1.5.1 glew-2.0.0 freetype-2.5.2 curl-7.40.0 jpeg-9a"
    if !errorlevel! == 0 (
      set buildExternal=1
      echo. External library files are modified. Need to build external : !buildExternal! .
      GOTO BREAK_LOOP1
    )
  )

  :BREAK_LOOP1
  cd vc.build
  if NOT EXIST builds (
    set buildExternal=1
    echo. Cache not available. Need to build external : !buildExternal!.
  )
  cd ..

  FOR /F "tokens=* USEBACKQ" %%F IN (`git diff-tree --name-only --no-commit-id -r %APPVEYOR_REPO_COMMIT%`) DO (
    echo.%%F|findstr /C:"libnode-v6.9.0"
    if !errorlevel! == 0 (
      set buildLibnode=1
      echo. libnode files are modified. Need to build libnode : !buildLibnode! .
      GOTO BREAK_LOOP2
    )
  )
)

@rem for edge builds, do full compilation, so it includes all pdb files.
if "%APPVEYOR_SCHEDULED_BUILD%"=="True" (
  set buildExternal=1
  set buildLibnode=1
)


:BREAK_LOOP2
if %buildExternal% == 1 (
  echo. Building external library  : %cd%
  cd vc.build\
  msbuild external.sln /p:Configuration=Release /p:Platform=Win32 /m
  cd ..
)
echo. =================================== end of external solutiton

set cacheDownload=0
if %buildLibnode% == 0 (
echo. Verifying the download and unzip time.
time /t
curl http://96.116.56.119/node_cache/node_cache.7z -o node_cache.7z
set cacheDownload=%errorlevel%

if NOT "!cacheDownload!" == "0" (
  echo. Downloading of cache has been failed.
  set buildLibnode=1
  )

  if !cacheDownload! == 0 (
    echo. xtract copying files from %cd%
    7z x node_cache.7z
    set cacheDownload=%errorlevel%
	if NOT "!cacheDownload!" == "0" (
	  echo. Cache archive is invalid.
	  set buildLibnode=1
	)
    
	if !cacheDownload! == 0 (
	  md c:\dw\pxCore\examples\pxScene2d\external\libnode-v6.9.0\build
      xcopy build c:\dw\pxCore\examples\pxScene2d\external\libnode-v6.9.0\build\ /S /E /Y
      echo. download build completed

      md c:\dw\pxCore\examples\pxScene2d\external\libnode-v6.9.0\tools\msvs\genfiles
      xcopy genfiles c:\dw\pxCore\examples\pxScene2d\external\libnode-v6.9.0\tools\msvs\genfiles\ /S /E /Y
      echo. download genfiles completed

      md c:\dw\pxCore\examples\pxScene2d\external\libnode-v6.9.0\Release
      xcopy Release c:\dw\pxCore\examples\pxScene2d\external\libnode-v6.9.0\Release\ /S /E /Y
      echo. download Release completed
	)
  )

  echo. download, untar and copy completed
  time /t
)


time /t
cd breakpad-chrome_55
CALL gyp\gyp.bat src\client\windows\breakpad_client.gyp --no-circular-check
cd src\client\windows
msbuild breakpad_client.sln /p:Configuration=Release /p:Platform=Win32 /m
cd ..\..\..\..\
echo. =================================== end of breakpad

time /t
if %buildLibnode% == 1 (
  cd libnode-v6.9.0
  CALL vcbuild.bat x86 nosign
  cd ..
  echo. =================================== end of libnode
  time /t
  
  @rem this is the place to tar and upload libnode cache to build server.
  @rem md Release build genfiles
  @rem xcopy libnode-v6.9.0\tools\msvs\genfiles\* genfiles\  /S /E /Y
  @rem xcopy libnode-v6.9.0\build\* build\  /S /E /Y
  @rem xcopy libnode-v6.9.0\Release\* Release\ /S /E /Y
 
  @rem  7z.exe a C:\pxCore\AR\pxCore\node_cache.7z C:\pxCore\AR\pxCore\examples\pxScene2d\external\genfiles C:\pxCore\AR\pxCore\examples\pxScene2d\external\build C:\pxCore\AR\pxCore\examples\pxScene2d\external\Release
  @rem ls -l node_cache.7z
)

cd dukluv
patch -p1 < patches/dukluv.git.patch
mkdir build
cd build
cmake ..
cmake --build . --config Release -- /m
cd ..
echo. =================================== end of dukluv
time /t