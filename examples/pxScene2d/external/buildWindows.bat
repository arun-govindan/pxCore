@where msbuild 2> nul
@if %errorlevel% neq 0 (
 @echo.
 @echo Please execute this file from inside Visual Studio's Developer Command Prompt
 @echo.
 pause
 goto :eof
)
echo. =================================== starting of buildWindows
time /t

copy /y libjpeg-turbo-1.5.1\win_temp\* libjpeg-turbo-1.5.1\
copy /y curl-7.40.0\include\curl\curlbuild-win.h curl-7.40.0\include\curl\curlbuild.h
copy /y libpng-1.6.28\scripts\pnglibconf.h.prebuilt libpng-1.6.28\pnglibconf.h
copy /y jpeg-9a\jconfig.vc jpeg-9a\jconfig.h

echo. =================================== starting of buildWindows
time /t




@echo off
setlocal enabledelayedexpansion
set buildNeeded=0
git diff-tree --name-only --no-commit-id -r %APPVEYOR_REPO_COMMIT%	
echo -----------------------
FOR /F "tokens=* USEBACKQ" %%F IN (`git diff-tree --name-only --no-commit-id -r %APPVEYOR_REPO_COMMIT%`) DO (
echo.%%F|findstr /C:"external"
if !errorlevel! == 0 (
set buildNeeded=1
break
)
)
cd c:/dw/pxCore/examples/pxScene2d/external/vc.build/builds/
ls -l
cd ..\..\
cd vc.build

if NOT EXIST builds (
set buildNeeded=1
)
cd ..
echo ----------------buildNeeded : %buildNeeded%
if %buildNeeded% == 1 (
cd vc.build\
msbuild external.sln /p:Configuration=Release /p:Platform=Win32 /m
cd ..
)




echo. =================================== end of external solutiton
time /t
cd breakpad-chrome_55
CALL gyp\gyp.bat src\client\windows\breakpad_client.gyp --no-circular-check
cd src\client\windows
msbuild breakpad_client.sln /p:Configuration=Release /p:Platform=Win32 /m
cd ..\..\..\..\
echo. =================================== end of breakpad
time /t
cd libnode-v6.9.0
CALL vcbuild.bat x86 nosign
cd ..
echo. =================================== end of libnode
time /t
cd dukluv
patch -p1 < patches/dukluv.git.patch
mkdir build
cd build
cmake ..
cmake --build . --config Release -- /m
cd ..
echo. =================================== end of dukluv
time /t