# Anleitung: Paperless mit KI-Zugang auf dem eigenen Rechner

Mit dieser Anleitung richten Sie auf Ihrem Windows-PC oder Mac ein:

- **Paperless-ngx**, ein digitales Archiv für Ihre Dokumente mit Texterkennung und Volltextsuche,
- einen **MCP-Server**, über den ein KI-Assistent wie Claude in Ihren Dokumenten suchen und sie verschlagworten kann.

Sie brauchen dafür keine Programmierkenntnisse. Einplanen sollten Sie etwa 30–45 Minuten, davon ist das meiste Wartezeit für Downloads.

> **Voraussetzungen:** Windows 10/11 oder macOS, mindestens 8 GB Arbeitsspeicher und etwa 10 GB freier Festplattenplatz.

---

## Schritt 1 – Docker Desktop installieren

Docker Desktop ist das Programm, das Paperless und alle zugehörigen Bausteine ausführt.

1. Laden Sie Docker Desktop herunter: <https://www.docker.com/products/docker-desktop/>
2. Installieren Sie es mit den Standardeinstellungen.
   - **Windows:** Fragt das Installationsprogramm nach „WSL 2“, lassen Sie das Häkchen gesetzt. Danach ist evtl. ein Neustart nötig.
3. Starten Sie Docker Desktop. Die Frage nach einer Anmeldung können Sie mit „Skip“ überspringen.
4. Warten Sie, bis unten links **„Engine running“** steht.
5. Empfohlen: Unter *Settings → General* das Häkchen bei **„Start Docker Desktop when you sign in“** setzen. Dann startet Paperless automatisch mit dem Rechner.

> **Hinweis zur Lizenz:** Docker Desktop ist kostenlos für Privatpersonen, Bildung, nicht-kommerzielle Open-Source-Projekte und Unternehmen mit weniger als 250 Mitarbeitenden *und* weniger als 10 Mio. US-$ Jahresumsatz.

## Schritt 2 – Dieses Paket herunterladen

1. Klicken Sie oben auf dieser GitHub-Seite auf den grünen Knopf **„Code“** und dann auf **„Download ZIP“**.
2. Entpacken Sie die ZIP-Datei an einen festen Ort, z. B. `Dokumente\Paperless`. Diesen Ordner später nicht mehr verschieben.
3. Öffnen Sie darin den Ordner **`installation`**.

## Schritt 3 – Passwort festlegen

1. Öffnen Sie die Datei **`einstellungen.env`** mit dem Editor:
   - **Windows:** Rechtsklick → „Öffnen mit“ → „Editor“
   - **Mac:** Rechtsklick → „Öffnen mit“ → „TextEdit“
2. Ersetzen Sie in der Zeile `ADMIN_PASSWORT=HIER_PASSWORT_EINTRAGEN` den Text `HIER_PASSWORT_EINTRAGEN` durch ein eigenes Passwort. Verwenden Sie keine Leerzeichen und keine Anführungszeichen.
3. Speichern Sie die Datei und schließen Sie den Editor.

> ⚠️ Der Dateiname muss genau `einstellungen.env` bleiben. Der Editor schlägt manchmal `.txt` am Ende vor, das bitte nicht übernehmen.

## Schritt 4 – Starten

- **Windows:** Doppelklick auf **`Start.bat`**.
  Erscheint die Warnung „Der Computer wurde durch Windows geschützt“, klicken Sie auf „Weitere Informationen“ und dann auf „Trotzdem ausführen“.
- **Mac:** Rechtsklick auf **`Start.command`** → „Öffnen“ und die Rückfrage mit „Öffnen“ bestätigen.

Beim ersten Start werden etwa 3 GB heruntergeladen, das kann 10–20 Minuten dauern. Danach öffnet sich Paperless automatisch im Browser unter <http://localhost:8000>.

Melden Sie sich mit dem Benutzernamen **`admin`** und Ihrem Passwort aus Schritt 3 an.

**Später:** Läuft Docker Desktop, läuft auch Paperless. Rufen Sie einfach <http://localhost:8000> auf. Zum Stoppen und Starten können Sie in Docker Desktop unter *Containers* auf den Eintrag „low-budget-high-intelligence“ klicken.

## Schritt 5 – Dokumente hinzufügen

Sie haben zwei Möglichkeiten:

- **Hochladen:** In Paperless die Dateien per Drag & Drop auf die Startseite ziehen.
- **Eingangsordner:** Dateien in den Ordner `installation/eingang` legen. Paperless holt sie innerhalb weniger Sekunden ab, und danach verschwinden sie aus dem Ordner.

## Schritt 6 – KI-Assistent anbinden

### 6a – Zugangsschlüssel (Token) in Paperless erzeugen

1. Klicken Sie in Paperless oben rechts auf Ihren Benutzernamen und dann auf **„Mein Profil“**.
2. Erzeugen Sie beim Punkt **„API-Auth-Token“** mit dem Pfeil-Symbol einen Token und kopieren Sie ihn.

> Der Token ist wie ein Passwort: Wer ihn hat, kann auf Ihre Dokumente zugreifen. Geben Sie ihn nicht weiter.

### 6b – Claude Desktop

1. Installieren Sie Claude Desktop: <https://claude.ai/download>
2. Öffnen Sie in Claude Desktop *Einstellungen → Entwickler → Konfiguration bearbeiten*. Es öffnet sich ein Ordner mit der Datei `claude_desktop_config.json`.
3. Öffnen Sie diese Datei mit dem Editor und ersetzen Sie ihren Inhalt durch den Inhalt von `claude_desktop_config.beispiel.json` aus diesem Paket.
4. Ersetzen Sie dort `HIER_TOKEN_EINTRAGEN` durch Ihren Token aus 6a und speichern Sie die Datei.
5. Beenden Sie Claude Desktop vollständig und starten Sie es neu. Unter Windows heißt das: auch das Symbol neben der Uhr per Rechtsklick → „Beenden“.
6. Testen Sie die Verbindung, z. B. mit: *„Welche Dokumente liegen in meinem Paperless?“*

### 6c – Für Fortgeschrittene: Claude Code und andere Clients

Der MCP-Server läuft im Paket bereits mit und ist unter `http://localhost:8001/mcp` erreichbar. Den Token schickt jeder Client im Header `X-Paperless-Token` mit. Für Claude Code sieht das so aus:

```bash
claude mcp add --transport http paperless http://localhost:8001/mcp \
  --header "X-Paperless-Token: <IHR_TOKEN>"
```

## Datensicherung

Ihre Dokumente liegen in Docker Desktop und **nicht** als normale Dateien in diesem Ordner. So erstellen Sie eine Sicherung:

1. Klicken Sie in Docker Desktop unter *Containers* auf „low-budget-high-intelligence“ und dann auf den Container **paperless**.
2. Öffnen Sie den Reiter **„Exec“** und geben Sie ein: `document_exporter ../export`
3. Danach liegen alle Dokumente und Metadaten im Ordner `installation/export`. Diesen Ordner können Sie auf eine externe Festplatte kopieren.

## Häufige Probleme

| Problem | Lösung |
|---|---|
| „Docker Desktop läuft nicht“ | Docker Desktop starten und warten, bis „Engine running“ angezeigt wird. |
| Windows: Docker Desktop startet nicht, Meldung zu Virtualisierung | Die Virtualisierung muss im BIOS eingeschaltet sein. Sie heißt dort „Intel VT-x“ bzw. „AMD-V/SVM“. Hilfe: Hersteller-Support Ihres PCs. |
| Seite <http://localhost:8000> lädt nicht | Ein paar Minuten warten, beim ersten Start richtet sich die Datenbank ein. In Docker Desktop prüfen, ob alle Container grün sind. |
| Port bereits belegt („port is already allocated“) | Ein anderes Programm nutzt Port 8000. In `docker-compose.yml` in der Zeile `127.0.0.1:8000:8000` die erste 8000 z. B. durch 8010 ersetzen und dann <http://localhost:8010> aufrufen. |
| Passwort vergessen | In Docker Desktop im Container „paperless“ unter „Exec“ eingeben: `python3 manage.py changepassword admin` |
| Dateien im Eingangsordner werden nicht importiert | Prüfen, ob es PDF-, Bild- oder Office-Dateien sind. In Docker Desktop im Container „paperless“ unter „Logs“ nachsehen. |
