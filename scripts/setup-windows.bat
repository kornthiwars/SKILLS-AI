@echo off
cd /d "%~dp0.."
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0setup-windows.ps1" -InstallRoot "%CD%"
if errorlevel 1 pause
