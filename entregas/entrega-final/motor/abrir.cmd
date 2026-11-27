@echo off
setlocal
set "R_BIN=Rscript.exe"
where Rscript.exe >nul 2>&1
if errorlevel 1 (
  set "R_BIN="
  for /d %%V in ("%ProgramFiles%\R\R-*") do if exist "%%~fV\bin\Rscript.exe" set "R_BIN=%%~fV\bin\Rscript.exe"
  if exist "%~dp0..\..\..\..\tmp\R\bin\Rscript.exe" set "R_BIN=%~dp0..\..\..\..\tmp\R\bin\Rscript.exe"
)
if not defined R_BIN (
  echo Instale o R ou adicione Rscript.exe ao PATH.
  pause
  exit /b 1
)
"%R_BIN%" "%~dp0iniciar.R"
if errorlevel 1 pause
