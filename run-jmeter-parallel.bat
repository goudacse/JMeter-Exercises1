@echo off
setlocal

REM ===== Configure paths =====
set JMETER_HOME=D:\JMeter\apache-jmeter-5.6.3
set TEST_DIR=jmeter-tests
set REPORT_DIR=jmeter-report

if not exist %REPORT_DIR% mkdir %REPORT_DIR%

REM ===== Run all JMX files in parallel =====
echo Starting all JMeter tests...
for %%f in (%TEST_DIR%\*.jmx) do (
    echo Running %%~nf.jmx
    start "" /B "%JMETER_HOME%\bin\jmeter.bat" -n -t "%%f" -l "%REPORT_DIR%\%%~nf.jtl"
)

REM ===== Wait until all JMeter processes finish =====
:WAIT
tasklist /FI "IMAGENAME eq jmeter.bat" 2>NUL | find /I "jmeter.bat" >NUL
if %ERRORLEVEL%==0 (
    timeout /t 5
    goto WAIT
)

REM ===== Verify that JTL files exist =====
set COUNT=0
for %%f in (%REPORT_DIR%\*.jtl) do set /a COUNT+=1

if %COUNT%==0 (
    echo ERROR: No JTL files generated!
    exit /b 1
)

REM ===== Combine all JTLs =====
copy /b %REPORT_DIR%\*.jtl %REPORT_DIR%\combined.jtl
echo Combined JTL created.

echo All JMeter tests completed successfully.
