@echo off
if not exist "%~dp0Manager\Data\settings.json" (
  echo Run Install.cmd first. Read README.md for instructions.
  pause
  exit /b 1
)
start "" /D "%~dp0Manager" "%~dp0Runtime\dotnet.exe" "%~dp0Manager\BG3ModManager.dll"
