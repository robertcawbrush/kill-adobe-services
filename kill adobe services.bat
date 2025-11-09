@echo off
REM kill-adobe.bat — stop Adobe services and kill Adobe processes
REM Must be run as administrator.

REM -- admin check --
net session >nul 2>&1
if %errorlevel% neq 0 (
  echo This script must be run as Administrator.
  pause
  exit /b 1
)

echo Stopping Windows services with "Adobe" in their name/displayname...
powershell -NoProfile -Command ^
  "Get-Service | Where-Object { ($_.DisplayName -match 'Adobe') -or ($_.Name -match 'Adobe') } | ForEach-Object { Write-Host 'Stopping service:' $_.Name; Stop-Service -Name $_.Name -Force -ErrorAction SilentlyContinue }"

echo Killing processes with "Adobe" in name or executable path...
powershell -NoProfile -Command ^
  "Get-Process -ErrorAction SilentlyContinue | Where-Object { ($_.ProcessName -match 'Adobe') -or ($_.Path -and $_.Path -match 'Adobe') } | ForEach-Object { Write-Host 'Killing process:' $_.ProcessName,'(PID:'$_.Id')'; Stop-Process -Id $_.Id -Force -ErrorAction SilentlyContinue }"

echo Optionally: disable these services so they don't restart automatically.
echo If you want to disable them as well, run the following (uncomment in the .bat to enable):
echo powershell -NoProfile -Command "Get-Service | Where-Object { ($_.DisplayName -match 'Adobe') -or ($_.Name -match 'Adobe') } | ForEach-Object { Set-Service -Name $_.Name -StartupType Disabled -ErrorAction SilentlyContinue }"

echo Done.
pause
