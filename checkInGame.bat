@echo off
:loop
git pull
pwsh -File checkInGame.ps1
timeout /T 180 /NOBREAK
goto loop
