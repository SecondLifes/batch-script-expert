@echo off
setlocal enabledelayedexpansion
REM ============================================================
REM Script:  backup-logs.bat
REM Purpose: Copies *.log files older than N days from a source
REM          directory to a backup directory, then reports how
REM          many files were copied.
REM Usage:   backup-logs.bat "<source-dir>" "<backup-dir>"
REM ============================================================

call :ValidateInput "%~1" "%~2"
if errorlevel 1 exit /b 1

call :CopyLogs "%~1" "%~2"
if errorlevel 1 (
  call :Cleanup
  exit /b 1
)

call :Cleanup
exit /b 0

REM ------------------------------------------------------------
:ValidateInput
if "%~1"=="" (
  echo ERROR: source directory required 1>&2
  exit /b 1
)
if "%~2"=="" (
  echo ERROR: backup directory required 1>&2
  exit /b 1
)
if not exist "%~1" (
  echo ERROR: source directory does not exist: %~1 1>&2
  exit /b 1
)
exit /b 0

REM ------------------------------------------------------------
:CopyLogs
set "SOURCE_DIR=%~1"
set "BACKUP_DIR=%~2"
set "LOG_FILE=%TEMP%\backup-logs_%RANDOM%.log"

robocopy "%SOURCE_DIR%" "%BACKUP_DIR%" *.log /R:3 /W:5 /LOG:"%LOG_FILE%" /NP
if %ERRORLEVEL% geq 8 (
  echo ERROR: robocopy failed, see %LOG_FILE% 1>&2
  exit /b 1
)

REM Count copied files via delayed expansion inside the loop —
REM %COUNT% here would stay frozen at 0 for every iteration.
set COUNT=0
for /f "usebackq delims=" %%L in ("%LOG_FILE%") do (
  echo %%L | findstr /C:"New File" >nul
  if !ERRORLEVEL! equ 0 set /a COUNT+=1
)
echo Copied !COUNT! log file(s) from "%SOURCE_DIR%" to "%BACKUP_DIR%"
exit /b 0

REM ------------------------------------------------------------
:Cleanup
if defined LOG_FILE del /q "%LOG_FILE%" 2>nul
exit /b 0
