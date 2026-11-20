@echo off
chcp 65001 >nul
setlocal
cd /d "%~dp0"

echo.
echo  Low Budget, High Intelligence - Paperless wird gestartet ...
echo.

rem --- 1. Einstellungsdatei vorhanden? ------------------------------------
if not exist "einstellungen.env" (
    if exist "einstellungen.env.txt" (
        echo  FEHLER: Die Datei heisst "einstellungen.env.txt".
        echo  Bitte in "einstellungen.env" umbenennen und erneut starten.
    ) else (
        echo  FEHLER: Die Datei "einstellungen.env" fehlt in diesem Ordner.
    )
    goto :ende
)

rem --- 2. Passwort eingetragen? -------------------------------------------
findstr /b /c:"ADMIN_PASSWORT=HIER_PASSWORT_EINTRAGEN" einstellungen.env >nul
if %errorlevel%==0 (
    echo  Bitte zuerst in "einstellungen.env" ein eigenes Passwort eintragen
    echo  ^(bei ADMIN_PASSWORT^). Die Datei wird jetzt geoeffnet.
    start notepad einstellungen.env
    goto :ende
)

rem --- 3. Docker Desktop laeuft? ------------------------------------------
docker info >nul 2>&1
if not %errorlevel%==0 (
    echo  FEHLER: Docker Desktop laeuft nicht.
    echo  Bitte Docker Desktop starten, warten bis es "Engine running" anzeigt,
    echo  und dieses Programm dann erneut starten.
    goto :ende
)

rem --- 4. Zufallswerte beim ersten Start erzeugen -------------------------
powershell -NoProfile -Command ^
  "$f='einstellungen.env'; $t=Get-Content $f -Raw -Encoding UTF8;" ^
  "function Neu-Zufall($n){ -join ((48..57)+(65..90)+(97..122) | Get-Random -Count $n | %% {[char]$_}) }" ^
  "$t=$t -replace 'DB_PASSWORT=AUTOMATISCH',('DB_PASSWORT='+(Neu-Zufall 32));" ^
  "$t=$t -replace 'GEHEIMER_SCHLUESSEL=AUTOMATISCH',('GEHEIMER_SCHLUESSEL='+(Neu-Zufall 50));" ^
  "[IO.File]::WriteAllText((Resolve-Path $f),$t)"

rem --- 5. Starten ---------------------------------------------------------
if not exist "eingang" mkdir eingang
if not exist "export" mkdir export

echo  Lade und starte die Programme. Beim ersten Mal kann das
echo  10-20 Minuten dauern ^(ca. 3 GB Download^) ...
echo.
docker compose --env-file einstellungen.env up -d
if not %errorlevel%==0 (
    echo.
    echo  FEHLER beim Starten. Bitte die Meldungen oben notieren.
    goto :ende
)

echo.
echo  Warte, bis Paperless bereit ist ...
:warten
timeout /t 5 /nobreak >nul
curl -s -o nul http://localhost:8000 || goto :warten

echo.
echo  Fertig! Paperless oeffnet sich jetzt im Browser:  http://localhost:8000
start http://localhost:8000

:ende
echo.
pause
