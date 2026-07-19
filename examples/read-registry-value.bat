@echo off
setlocal enabledelayedexpansion
REM ============================================================
REM Script:  read-registry-value.bat
REM Purpose: Reads a single string value from the registry and
REM          prints it, or reports clearly if the key/value is
REM          missing rather than failing with a raw reg.exe error.
REM Usage:   read-registry-value.bat <key-path> <value-name>
REM Example: read-registry-value.bat "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" ProductName
REM ============================================================

call :ValidateInput "%~1" "%~2"
if errorlevel 1 exit /b 1

call :ReadValue "%~1" "%~2"
if errorlevel 1 exit /b 1

exit /b 0

REM ------------------------------------------------------------
:ValidateInput
if "%~1"=="" (
  echo ERROR: registry key path required 1>&2
  exit /b 1
)
if "%~2"=="" (
  echo ERROR: value name required 1>&2
  exit /b 1
)
exit /b 0

REM ------------------------------------------------------------
:ReadValue
set "KEY_PATH=%~1"
set "VALUE_NAME=%~2"
set "RESULT="

for /f "usebackq tokens=2,*" %%A in (`
  reg query "%KEY_PATH%" /v "%VALUE_NAME%" 2^>nul ^| findstr /I "%VALUE_NAME%"
`) do set "RESULT=%%B"

if not defined RESULT (
  echo NOT FOUND: %KEY_PATH%\%VALUE_NAME% 1>&2
  exit /b 1
)

echo %VALUE_NAME% = !RESULT!
exit /b 0
