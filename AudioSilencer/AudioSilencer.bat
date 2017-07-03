@echo off
setlocal enabledelayedexpansion
rem *****************************************************************
rem *** Windows消音/消音取消処理
rem *** 引数：（１）1＝消音・2＝消音取消・省略した場合は2と同じ
rem *****************************************************************

set LOG_DIR=%~dp0
set LOG_FILE=%LOG_DIR%\%~n0.log

set SV_NAME1=Audiosrv
set SV_NAME2=AudioEndpointBuilder

echo %DATE% %TIME% [Info ] 処理開始 > %LOG_FILE%
set MODE=%1

if "%MODE%"=="1" (
    echo %DATE% %TIME% [Info ] 消音モードで実行 >> %LOG_FILE%

    net stop %SV_NAME1% >> %LOG_FILE% 2>&1
    call :CHECK_STATE %SV_NAME1%
    if ERRORLEVEL 1 goto ERROR
    echo %DATE% %TIME% [Info ] %SV_NAME1%終了完了>> %LOG_FILE%

    net stop %SV_NAME2% >> %LOG_FILE% 2>&1
    call :CHECK_STATE %SV_NAME2%
    if ERRORLEVEL 1 goto ERROR
    echo %DATE% %TIME% [Info ] %SV_NAME2%終了完了>> %LOG_FILE%
) else (
    echo %DATE% %TIME% [Info ] 消音取消モードで実行 >> %LOG_FILE%

    net start %SV_NAME2% >> %LOG_FILE% 2>&1
    call :CHECK_STATE %SV_NAME2%
    if !ERRORLEVEL!==0 goto ERROR
    echo %DATE% %TIME% [Info ] %SV_NAME2%開始完了>> %LOG_FILE%

    net start %SV_NAME1% >> %LOG_FILE% 2>&1
    call :CHECK_STATE %SV_NAME1%
    if !ERRORLEVEL!==0 goto ERROR
    echo %DATE% %TIME% [Info ] %SV_NAME1%開始完了>> %LOG_FILE%
)

echo %DATE% %TIME% [Info ] 処理完了 >> %LOG_FILE%

endlocal
exit /b 0

:CHECK_STATE
sc query %1 | findstr STOPPED
exit /b %ERRORLEVEL%

:ERROR
echo %DATE% %TIME% [Error] エラー発生。終了コード：%ERRORLEVEL% >> %LOG_FILE%

endlocal
exit /b %ERRORLEVEL%