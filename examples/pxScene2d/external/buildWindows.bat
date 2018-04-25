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

copy /y libjpeg-turbo-1.5.1\win_temp\* libjpeg-turbo-1.5.1\
copy /y curl-7.40.0\include\curl\curlbuild-win.h curl-7.40.0\include\curl\curlbuild.h
copy /y libpng-1.6.28\scripts\pnglibconf.h.prebuilt libpng-1.6.28\pnglibconf.h
copy /y jpeg-9a\jconfig.vc jpeg-9a\jconfig.h

@echo off
setlocal enabledelayedexpansion
set buildExternal=0
set buildLibnode=0

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
  set buildLibnode=1
  echo Cache not available. Need to build external : !buildNeeded!.
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
:BREAK_LOOP2
if %buildExternal% == 1 (
  echo. Building external library  : %cd%
  cd vc.build\
  msbuild external.sln /p:Configuration=Release /p:Platform=Win32 /m
  cd ..
)
GOTO SKIP_DOWNLOAD
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

  echo. download, untar and copy completed
  time /t
)

:SKIP_DOWNLOAD
cd breakpad-chrome_55
CALL gyp\gyp.bat src\client\windows\breakpad_client.gyp --no-circular-check
cd src\client\windows
msbuild breakpad_client.sln /p:Configuration=Release /p:Platform=Win32 /m
cd ..\..\..\..\

if %buildLibnode% == 1 (
cd libnode-v6.9.0
CALL vcbuild.bat x86 nosign
cd ..
)

cd dukluv
patch -p1 < patches/dukluv.git.patch
mkdir build
cd build
cmake ..
cmake --build . --config Release -- /m
cd ..
