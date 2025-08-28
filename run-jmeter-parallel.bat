@echo off
setlocal

set JMETER_HOME=D:\JMeter\apache-jmeter-5.6.3
set TEST_DIR=jmeter-tests
set REPORT_DIR=jmeter-report

if not exist %REPORT_DIR% mkdir %REPORT_DIR%

REM ===== Sequentially run all JMX files =====
set COUNT=0
for %%f in (%TEST_DIR%\*.jmx) do (
    echo Running %%~nf.jmx
    "%JMETER_HOME%\bin\jmeter.bat" -n -t "%%f" -l "%REPORT_DIR%\%%~nf.jtl"
    if exist "%REPORT_DIR%\%%~nf.jtl" set /a COUNT+=1
)

if %COUNT%==0 (
    echo ERROR: No JTL files generated!
    exit /b 1
)

REM ===== Combine all JTLs =====
copy /b %REPORT_DIR%\*.jtl %REPORT_DIR%\combined.jtl
echo Combined JTL created.
