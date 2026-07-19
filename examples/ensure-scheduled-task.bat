@echo off
setlocal enabledelayedexpansion
REM ============================================================
REM Script:  ensure-scheduled-task.bat
REM Purpose: Idempotent setup — creates a scheduled task only if
REM          it doesn't already exist, instead of erroring (or
REM          silently duplicating) on a second run.
REM Usage:   ensure-scheduled-task.bat <task-name> <command-to-run>
REM ============================================================

call :ValidateInput "%~1" "%~2"
if errorlevel 1 exit /b 1

call :EnsureTask "%~1" "%~2"
exit /b %ERRORLEVEL%

REM ------------------------------------------------------------
:ValidateInput
if "%~1"=="" (
  echo ERROR: task name required 1>&2
  exit /b 1
)
if "%~2"=="" (
  echo ERROR: command to run required 1>&2
  exit /b 1
)
exit /b 0

REM ------------------------------------------------------------
:EnsureTask
set "TASK_NAME=%~1"
set "TASK_COMMAND=%~2"

schtasks /query /tn "%TASK_NAME%" >nul 2>&1
if %ERRORLEVEL% equ 0 (
  echo Task "%TASK_NAME%" already exists — nothing to do.
  exit /b 0
)

echo Task "%TASK_NAME%" does not exist — creating...
schtasks /create /tn "%TASK_NAME%" /tr "%TASK_COMMAND%" /sc daily /st 02:00 /f >nul
if %ERRORLEVEL% neq 0 (
  echo ERROR: failed to create scheduled task "%TASK_NAME%" 1>&2
  exit /b 1
)

echo Task "%TASK_NAME%" created.
exit /b 0
