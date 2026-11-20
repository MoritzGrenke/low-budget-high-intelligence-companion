#!/bin/bash
# Low Budget, High Intelligence – Paperless starten (Mac)
cd "$(dirname "$0")" || exit 1

ende() { echo; read -r -p " Zum Schließen Enter drücken ..." _; exit "${1:-0}"; }

echo
echo " Low Budget, High Intelligence – Paperless wird gestartet ..."
echo

# --- 1. Einstellungsdatei vorhanden? ---------------------------------------
if [ ! -f einstellungen.env ]; then
  if [ -f einstellungen.env.txt ] || [ -f einstellungen.env.rtf ]; then
    echo " FEHLER: Die Datei hat eine falsche Endung (.txt/.rtf)."
    echo " Bitte in \"einstellungen.env\" umbenennen und erneut starten."
  else
    echo " FEHLER: Die Datei \"einstellungen.env\" fehlt in diesem Ordner."
  fi
  ende 1
fi

# --- 2. Passwort eingetragen? ----------------------------------------------
if grep -q "^ADMIN_PASSWORT=HIER_PASSWORT_EINTRAGEN" einstellungen.env; then
  echo " Bitte zuerst in \"einstellungen.env\" ein eigenes Passwort eintragen"
  echo " (bei ADMIN_PASSWORT). Die Datei wird jetzt geöffnet."
  open -e einstellungen.env
  ende 1
fi

# --- 3. Docker Desktop läuft? ----------------------------------------------
if ! docker info >/dev/null 2>&1; then
  echo " FEHLER: Docker Desktop läuft nicht."
  echo " Bitte Docker Desktop starten, warten bis \"Engine running\" angezeigt wird,"
  echo " und dieses Programm dann erneut starten."
  ende 1
fi

# --- 4. Zufallswerte beim ersten Start erzeugen ----------------------------
zufall() { LC_ALL=C tr -dc 'A-Za-z0-9' </dev/urandom | head -c "$1"; }
if grep -q "=AUTOMATISCH" einstellungen.env; then
  sed -e "s/^DB_PASSWORT=AUTOMATISCH/DB_PASSWORT=$(zufall 32)/" \
      -e "s/^GEHEIMER_SCHLUESSEL=AUTOMATISCH/GEHEIMER_SCHLUESSEL=$(zufall 50)/" \
      einstellungen.env > einstellungen.env.tmp && mv einstellungen.env.tmp einstellungen.env
fi

# --- 5. Starten ------------------------------------------------------------
mkdir -p eingang export
echo " Lade und starte die Programme. Beim ersten Mal kann das"
echo " 10–20 Minuten dauern (ca. 3 GB Download) ..."
echo
if ! docker compose --env-file einstellungen.env up -d; then
  echo
  echo " FEHLER beim Starten. Bitte die Meldungen oben notieren."
  ende 1
fi

echo
echo " Warte, bis Paperless bereit ist ..."
until curl -s -o /dev/null http://localhost:8000; do sleep 5; done

echo
echo " Fertig! Paperless öffnet sich jetzt im Browser:  http://localhost:8000"
open http://localhost:8000
ende 0
