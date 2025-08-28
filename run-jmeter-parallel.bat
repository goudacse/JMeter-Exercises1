@echo off
setlocal

set JMETER_HOME=D:\\JMeter\\apache-jmeter-5.6.3
set TEST_DIR=jmeter-tests
set REPORT_DIR=jmeter-report

if not exist %REPORT_DIR% mkdir %REPORT_DIR%

REM Run each JMX in parallel
for %%f in (%TEST_DIR%\*.jmx) do (
    start "" /B "%JMETER_HOME%\bin\jmeter.bat" -n -t "%%f" -l "%REPORT_DIR%\%%~nf.jtl"
)

REM Wait until all background jobs finish
:WAIT
tasklist /FI "IMAGENAME eq jmeter.bat" 2>NUL | find /I "jmeter.bat" >NUL
if %ERRORLEVEL%==0 (
    timeout /t 5
    goto WAIT
)

echo All JMeter tests completed.
