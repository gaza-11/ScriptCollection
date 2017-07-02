
setlocal enabledelayedexpansion
rem *****************************************************************
rem *** Windows����/�����������
rem *** �����F�i�P�j1�������E2����������E�ȗ������ꍇ��2�Ɠ���
rem *****************************************************************

set SV_NAME1=Audiosrv
set SV_NAME2=AudioEndpointBuilder

set MODE=%1

if "%MODE%"=="1" (
    net stop %SV_NAME1%
    call :CHECK_STATE %SV_NAME1%
    if ERRORLEVEL 1 goto ERROR

    net stop %SV_NAME2%
    call :CHECK_STATE %SV_NAME2%
    if ERRORLEVEL 1 goto ERROR
) else (
    net start %SV_NAME2%
    call :CHECK_STATE %SV_NAME2%
    if !ERRORLEVEL!==0 goto ERROR

    net start %SV_NAME1%
    call :CHECK_STATE %SV_NAME1%
    if !ERRORLEVEL!==0 goto ERROR
)

echo success
pause
exit /b 0

:CHECK_STATE
sc query %1 | findstr STOPPED
exit /b %ERRORLEVEL%

:ERROR
echo error
pause
exit /b %ERRORLEVEL%