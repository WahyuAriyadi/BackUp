@echo off
setlocal enabledelayedexpansion

set RESTIC_EXE=E:\BackUP\bin\restic.exe
set ENV_FILE=E:\BackUP\backup.env.txt
set BACKUP_PATH=E:\BackUP\ToBackup
set LOG_FILE=E:\BackUP\backup-log.txt

for /f "usebackq tokens=1,2 delims==" %%A in ("%ENV_FILE%") do (
    set "%%A=%%B"
)

echo [%date% %time%] Backup dimulai >> "%LOG_FILE%"

"%RESTIC_EXE%" backup "%BACKUP_PATH%" >> "%LOG_FILE%" 2>&1

if %ERRORLEVEL% EQU 0 (
    echo [%date% %time%] Backup SUKSES >> "%LOG_FILE%"
    curl -s -X POST "https://api.telegram.org/bot%TG_TOKEN%/sendMessage" -d "chat_id=%TG_CHATID%" -d "text=✅ Backup laptop SUKSES - %date% %time%" >nul
) else (
    echo [%date% %time%] Backup GAGAL - kode error %ERRORLEVEL% >> "%LOG_FILE%"
    curl -s -X POST "https://api.telegram.org/bot%TG_TOKEN%/sendMessage" -d "chat_id=%TG_CHATID%" -d "text=❌ Backup laptop GAGAL kode %ERRORLEVEL% - cek E:\BackUP\backup-log.txt" >nul
)

"%RESTIC_EXE%" forget --keep-daily 7 --keep-weekly 4 --keep-monthly 6 --prune >> "%LOG_FILE%" 2>&1

echo [%date% %time%] Selesai >> "%LOG_FILE%"
echo ---------------------------------------- >> "%LOG_FILE%"

endlocal