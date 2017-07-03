@echo off
setlocal enabledelayedexpansion
rem *****************************************************************
rem *** Windows����/�����������
rem *** �����F�i�P�j1�������E2����������E�ȗ������ꍇ��2�Ɠ���
rem *****************************************************************

set LOG_DIR=%~dp0
set LOG_FILE=%LOG_DIR%\%~n0.log

set SV_NAME1=Audiosrv
set SV_NAME2=AudioEndpointBuilder

echo %DATE% %TIME% [Info ] �����J�n > %LOG_FILE%
set MODE=%1

if "%MODE%"=="1" (
    echo %DATE% %TIME% [Info ] �������[�h�Ŏ��s >> %LOG_FILE%

    net stop %SV_NAME1% >> %LOG_FILE% 2>&1
    call :CHECK_STATE %SV_NAME1%
    if ERRORLEVEL 1 goto ERROR
    echo %DATE% %TIME% [Info ] %SV_NAME1%�I������>> %LOG_FILE%

    net stop %SV_NAME2% >> %LOG_FILE% 2>&1
    call :CHECK_STATE %SV_NAME2%
    if ERRORLEVEL 1 goto ERROR
    echo %DATE% %TIME% [Info ] %SV_NAME2%�I������>> %LOG_FILE%
) else (
    echo %DATE% %TIME% [Info ] ����������[�h�Ŏ��s >> %LOG_FILE%

    net start %SV_NAME2% >> %LOG_FILE% 2>&1
    call :CHECK_STATE %SV_NAME2%
    if !ERRORLEVEL!==0 goto ERROR
    echo %DATE% %TIME% [Info ] %SV_NAME2%�J�n����>> %LOG_FILE%

    net start %SV_NAME1% >> %LOG_FILE% 2>&1
    call :CHECK_STATE %SV_NAME1%
    if !ERRORLEVEL!==0 goto ERROR
    echo %DATE% %TIME% [Info ] %SV_NAME1%�J�n����>> %LOG_FILE%
)

echo %DATE% %TIME% [Info ] �������� >> %LOG_FILE%

endlocal
exit /b 0

:CHECK_STATE
sc query %1 | findstr STOPPED
exit /b %ERRORLEVEL%

:ERROR
echo %DATE% %TIME% [Error] �G���[�����B�I���R�[�h�F%ERRORLEVEL% >> %LOG_FILE%

endlocal
exit /b %ERRORLEVEL%