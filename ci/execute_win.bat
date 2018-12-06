@echo on
@rem script to run spark with test runner
echo %CD%

rm -rf logs
mkdir logs
set CURRDIR=%CD%
set LOGSDIR=%CD%\logs
set TESTRUNNER="https://px-apps.sys.comcast.net/pxscene-samples/examples/px-reference/test-run/testRunner_v7.js"

cd build-win32\_CPack_Packages\win32\NSIS\spark-setup
@rem taskkill /f /t /im Spark.exe

start /B spark.exe %TESTRUNNER%?tests=%CURRDIR%\tests\pxScene2d\testRunner\tests.json 

set procCompleted=0
:while
   echo "----------------- %LOGSDIR%\exec_logs.txt"
   grep -nr "TEST RESULTS: "  %LOGSDIR%\exec_logs.txt
   set errVal=%errorlevel%
   echo "the errVal : %errVal%"
   if %errVal% EQU 0 goto :break
   echo the proc value %procCompleted%
   timeout /t 10
   goto :while

:break


taskkill /f /t /im Spark.exe
