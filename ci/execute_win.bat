@echo on
@rem script to run spark with test runner
pwd

cd build-win32\_CPack_Packages\win32\NSIS\spark-setup
taskkill /f /t /im Spark.exe

start /B spark.exe https://px-apps.sys.comcast.net/pxscene-samples/examples/px-reference/gallery/answers.js > logs.txt

timeout  20
taskkill /f /t /im Spark.exe

cat logs.txt