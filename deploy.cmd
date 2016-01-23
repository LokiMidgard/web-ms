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

IF NOT DEFINED DEPLOYMENT_SOURCE (
  SET DEPLOYMENT_SOURCE=%~dp0%.
)

IF NOT DEFINED DEPLOYMENT_TARGET (
  SET DEPLOYMENT_TARGET=%ARTIFACTS%\wwwroot
)

IF NOT DEFINED NEXT_MANIFEST_PATH (
  SET NEXT_MANIFEST_PATH=%ARTIFACTS%\manifest

  IF NOT DEFINED PREVIOUS_MANIFEST_PATH (
    SET PREVIOUS_MANIFEST_PATH=%ARTIFACTS%\manifest
  )
)

IF NOT DEFINED KUDU_SYNC_CMD (
  :: Install kudu sync
  echo Installing Kudu Sync
  call npm install kudusync -g --silent
  IF !ERRORLEVEL! NEQ 0 goto error

  :: Locally just running "kuduSync" would also work
  SET KUDU_SYNC_CMD=%appdata%\npm\kuduSync.cmd
)

IF NOT DEFINED DEPLOYMENT_TEMP (
  SET DEPLOYMENT_TEMP=%DEPLOYMENT_SOURCE%\..\TEMP
)

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

IF NOT DEFINED WYAM_GIT (
  SET WYAM_GIT=%BIN_PATH%\WyamSource
)

IF NOT DEFINED WYAM_SOURCE (
  SET WYAM_SOURCE=%WYAM_GIT%\src
)


IF NOT DEFINED UPDATE_PATH (
  SET UPDATE_PATH=%BIN_PATH%\update
)

echo check for update
IF EXIST %UPDATE_PATH% (
  echo delete wyam for update
  call del /F /S /Q %WYAM_PATH%
  IF !ERRORLEVEL! NEQ 0 goto error

  call del /F /S /Q %UPDATE_PATH%
  IF !ERRORLEVEL! NEQ 0 goto error
)


IF EXIST %WYAM_PATH%\wyam.exe (
  SET WYAM_CMD=%WYAM_PATH%\wyam.exe
)

IF NOT DEFINED WYAM_CMD (
  :: Install wyam
  echo Installing Wyam

  IF EXIST %WYAM_SOURCE% (
    echo Deleting old Source
    call del /F /S /Q %WYAM_SOURCE%\*
    IF !ERRORLEVEL! NEQ 0 goto error
    IF EXIST %WYAM_SOURCE% (
      echo faild deliting
    )
  )

  

                                                                                 
                                                                                 
  echo 88d8b.d8b. .d8888b. dP   .dP .d8888b.    dP  dP  dP dP    dP .d8888b. 88d8b.d8b. 
  echo 88'`88'`88 88'  `88 88   d8' 88ooood8    88  88  88 88    88 88'  `88 88'`88'`88 
  echo 88  88  88 88.  .88 88 .88'  88.  ...    88.88b.88' 88.  .88 88.  .88 88  88  88 
  echo dP  dP  dP `88888P' 8888P'   `88888P'    8888P Y8P  `8888P88 `88888P8 dP  dP  dP 
  echo ooooooooooooooooooooooooooooooooooooooooooooooooooooo~~~~.88~oooooooooooooooooooo
  echo                                                      d8888P                      

  ::call move %WYAM_SOURCE%\Wyam\bin\Debug\* %WYAM_PATH%
  ::IF !ERRORLEVEL! NEQ 0 goto error

  Write-Hoste Blub


  SET WYAM_CMD=%WYAM_PATH%\wyam.exe
)

IF NOT EXIST %DEPLOYMENT_TEMP% (
  call mkdir %DEPLOYMENT_TEMP%
) 

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Deployment
:: ----------



echo                               dP   dP   dP                              
echo                               88   88   88                              
echo 88d888b. dP    dP 88d888b.    88  .8P  .8P dP    dP .d8888b. 88d8b.d8b. 
echo 88'  `88 88    88 88'  `88    88  d8'  d8' 88    88 88'  `88 88'`88'`88 
echo 88       88.  .88 88    88    88.d8P8.d8P  88.  .88 88.  .88 88  88  88 
echo dP       `88888P' dP    dP    8888' Y88'   `8888P88 `88888P8 dP  dP  dP 
echo oooooooooooooooooooooooooooooooooooooooooooo~~~~.88~oooooooooooooooooooo
echo                                             d8888P                      
                                            
call %WYAM_CMD% %DEPLOYMENT_SOURCE% --output %DEPLOYMENT_TEMP%
IF !ERRORLEVEL! NEQ 0 goto error

:: 1. KuduSync
IF /I "%IN_PLACE_DEPLOYMENT%" NEQ "1" (
  call :ExecuteCmd "%KUDU_SYNC_CMD%" -v 50 -f "%DEPLOYMENT_TEMP%" -t "%DEPLOYMENT_TARGET%" -n "%NEXT_MANIFEST_PATH%" -p "%PREVIOUS_MANIFEST_PATH%" -i ".git;.hg;.deployment;deploy.cmd"
  IF !ERRORLEVEL! NEQ 0 goto error
)

echo       dP          dP            dP                                   dP            .8888b                     dP            
echo       88          88            88                                   88            88   "                     88            
echo .d888b88 .d8888b. 88 .d8888b. d8888P .d8888b.    .d8888b. 88d888b. d8888P .d8888b. 88aaa  .d8888b. .d8888b. d8888P .d8888b. 
echo 88'  `88 88ooood8 88 88ooood8   88   88ooood8    88'  `88 88'  `88   88   88ooood8 88     88'  `88 88'  `""   88   Y8ooooo. 
echo 88.  .88 88.  ... 88 88.  ...   88   88.  ...    88.  .88 88         88   88.  ... 88     88.  .88 88.  ...   88         88 
echo `88888P8 `88888P' dP `88888P'   dP   `88888P'    `88888P8 dP         dP   `88888P' dP     `88888P8 `88888P'   dP   `88888P' 
echo oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
echo                                                                                                                             

call del /F /S /Q %DEPLOYMENT_TEMP%
IF !ERRORLEVEL! NEQ 0 goto error

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:: Post deployment stub
IF DEFINED POST_DEPLOYMENT_ACTION call "%POST_DEPLOYMENT_ACTION%"
IF !ERRORLEVEL! NEQ 0 goto error

goto end

:: Execute command routine that will echo out when error
:ExecuteCmd
setlocal
set _CMD_=%*
call %_CMD_%
if "%ERRORLEVEL%" NEQ "0" echo Failed exitCode=%ERRORLEVEL%, command=%_CMD_%
exit /b %ERRORLEVEL%

:error
endlocal
echo An error has occurred during web site deployment.
call del /F /S /Q %WYAM_SOURCE%
call :exitSetErrorLevel
call :exitFromFunction 2>nul


:exitSetErrorLevel
exit /b 1

:exitFromFunction
()

:end
endlocal
echo Finished successfully.
