@echo off
setlocal enabledelayedexpansion
REM ============================================================
REM Script:  process-multiple-args.bat
REM Purpose: Accepts a variable number of file-path arguments and
REM          reports which ones exist, using `shift` to iterate
REM          instead of assuming a fixed %1/%2/%3 count.
REM Usage:   process-multiple-args.bat <file1> [file2] [file3] ...
REM ============================================================

if "%~1"=="" (
  echo ERROR: at least one file argument required 1>&2
  exit /b 1
)

set FOUND_COUNT=0
set MISSING_COUNT=0

:ArgLoop
if "%~1"=="" goto :ArgLoopDone

if exist "%~1" (
  echo FOUND:   "%~1"
  set /a FOUND_COUNT+=1
) else (
  echo MISSING: "%~1"
  set /a MISSING_COUNT+=1
)

shift
goto :ArgLoop

:ArgLoopDone
echo.
echo Summary: !FOUND_COUNT! found, !MISSING_COUNT! missing

if !MISSING_COUNT! gtr 0 exit /b 1
exit /b 0
