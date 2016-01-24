@if "%SCM_TRACE_LEVEL%" NEQ "4" @echo off

:: ----------------------
:: KUDU Deployment Script
:: Version: 1.0.2
:: ----------------------

:: Prerequisites
:: -------------

:: Verify node.js installed
where node 2>nul >nul
IF %ERRORLEVEL% NEQ 0 (
  echo Missing node.js executable, please install node.js, if already installed make sure it can be reached from current environment.
  goto error
)

:: Setup
:: -----

setlocal enabledelayedexpansion

SET ARTIFACTS=%~dp0%..\artifacts





IF NOT DEFINED BIN_PATH (
  SET BIN_PATH=%ARTIFACTS%\..\bin
)

IF NOT EXIST %BIN_PATH% (
  echo create bin dir
  call mkdir %BIN_PATH%
) 

IF NOT DEFINED WYAM_PATH (
  SET WYAM_PATH=%BIN_PATH%\Wyam
)


powershell -ExecutionPolicy RemoteSigned .\deploy.ps1