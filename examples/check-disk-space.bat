@echo off
setlocal enabledelayedexpansion
REM ============================================================
REM Script:  check-disk-space.bat
REM Purpose: Reports free disk space (in GB) for a given drive
REM          letter, using PowerShell interop since batch has no
REM          native way to query volume free space.
REM Usage:   check-disk-space.bat <drive-letter>  (e.g. C)
REM ============================================================

call :ValidateInput "%~1"
if errorlevel 1 exit /b 1

call :GetFreeSpace "%~1"
if errorlevel 1 exit /b 1

exit /b 0

REM ------------------------------------------------------------
:ValidateInput
if "%~1"=="" (
  echo ERROR: drive letter required, e.g. "check-disk-space.bat C" 1>&2
  exit /b 1
)
exit /b 0

REM ------------------------------------------------------------
:GetFreeSpace
set "DRIVE_LETTER=%~1"
set "FREE_GB="

for /f "usebackq tokens=* delims=" %%V in (`
  powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "[math]::Round((Get-PSDrive -Name '%DRIVE_LETTER%' -ErrorAction SilentlyContinue).Free / 1GB, 2)"
`) do set "FREE_GB=%%V"

if not defined FREE_GB (
  echo ERROR: could not read free space for drive %DRIVE_LETTER%: 1>&2
  exit /b 1
)

echo Drive %DRIVE_LETTER%: has !FREE_GB! GB free
exit /b 0
