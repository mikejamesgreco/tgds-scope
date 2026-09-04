@echo off
setlocal EnableExtensions

rem ============================================================
rem TGDS Data Scope - simple 4-series live CSV feed generator
rem
rem Usage:
rem   tgds-live-feed-v0001.bat
rem   tgds-live-feed-v0001.bat my-live-data.csv
rem
rem If no filename is supplied, tgds-live-data.csv is created
rem beside this BAT file.
rem
rem The CSV contains four ordinary numeric series:
rem   signal_1, signal_2, signal_3, signal_4
rem
rem TGDS supplies system time for the X axis, so no timestamp
rem column is written to the CSV.
rem
rem Press Ctrl+C to stop the feed.
rem ============================================================

cd /d "%~dp0"

set "CSV=%~1"
if not defined CSV set "CSV=tgds-live-data.csv"

rem Start with a clean test file each time.
>"%CSV%" echo signal_1,signal_2,signal_3,signal_4

echo Created "%CD%\%CSV%"
echo.
echo Open "%CSV%" in TGDS Data Scope.
echo Start monitoring and leave it running.
echo A new four-series row will be appended once per second.
echo TGDS will use current system time for the X axis.
echo Press Ctrl+C to stop.
echo.

powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -Command ^
  "$path = [System.IO.Path]::GetFullPath('%CSV%');" ^
  "$i = 0;" ^
  "while ($true) {" ^
  "  $i++;" ^
  "  $s1 = [math]::Round(50 + 28 * [math]::Sin($i / 6.0), 2);" ^
  "  $s2 = [math]::Round(45 + 23 * [math]::Cos($i / 8.0), 2);" ^
  "  $s3 = [math]::Round(70 + 16 * [math]::Sin($i / 11.0) + 8 * [math]::Cos($i / 4.0), 2);" ^
  "  $s4 = [math]::Round(35 + 30 * [math]::Abs([math]::Sin($i / 9.0)), 2);" ^
  "  $line = '{0},{1},{2},{3}' -f $s1,$s2,$s3,$s4;" ^
  "  Add-Content -LiteralPath $path -Value $line -Encoding ASCII;" ^
  "  Write-Host $line;" ^
  "  Start-Sleep -Milliseconds 1000;" ^
  "}"

endlocal
