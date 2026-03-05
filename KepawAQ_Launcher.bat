@echo off
:: ============================================
::  Kepaw AQ Launcher
::  Double-click this to run KepawAQ.ps1
:: ============================================
echo Starting Kepaw AQ...
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0KepawAQ.ps1"
pause
