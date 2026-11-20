# Low Budget, High Intelligence

**Wie Open Source und KI helfen, das Lebenswerk des Industriedesigners Louis Lepoix zu erschließen**

*Companion repository to the German article "Low Budget, High Intelligence" (forthcoming 2027 in the proceedings of the Gesellschaft für Designgeschichte) on using open source and AI to make the archive of industrial designer Louis Lepoix accessible. Includes a beginner-friendly Docker bundle (Paperless-ngx + MCP server).*

---

Dieses Repository begleitet den gleichnamigen Beitrag im Tagungsband **„Welche Welt woll(t)en wir? Vom Nutzen, Designwissen zu bewahren“**, herausgegeben von Theres Rohde und Thilo Schwer. Der Band erscheint voraussichtlich im Juni/Juli 2027 als Band 10 der *Schriften der Gesellschaft für Designgeschichte* bei [arthistoricum.net – ART-Books](https://books.ub.uni-heidelberg.de/arthistoricum), der Open-Access-Plattform der Universitätsbibliothek Heidelberg: online dauerhaft frei zugänglich und zusätzlich als gedrucktes Buch über Print-on-Demand.

Es enthält:

| Ordner / Datei | Inhalt |
|---|---|
| [`artikel/`](artikel/) | Der Beitrag (folgt nach Erscheinen des Tagungsbands) |
| [`installation/`](installation/) | Ein fertiges Paket mit Paperless-ngx und MCP-Server zum Selbstausprobieren, mit Docker Desktop auch ohne IT-Kenntnisse |
| [`ressourcen.md`](ressourcen.md) | Weiterführende Links zu den verwendeten Werkzeugen und zu Louis Lepoix |

## Schnellstart

1. [Docker Desktop](https://www.docker.com/products/docker-desktop/) installieren.
2. Dieses Repository als ZIP herunterladen (grüner Knopf **„Code“** → **„Download ZIP“**) und entpacken.
3. Im Ordner `installation` in der Datei `einstellungen.env` ein Passwort eintragen.
4. `Start.bat` (Windows) bzw. `Start.command` (Mac) per Doppelklick starten.

Die ausführliche Schritt-für-Schritt-Anleitung, auch zur Anbindung von Claude, steht in [`installation/ANLEITUNG.md`](installation/ANLEITUNG.md).

## Was steckt drin?

```
 Du / KI-Assistent (Claude)
          │
          ▼
   ┌──────────────┐   REST-API   ┌────────────────┐
   │  MCP-Server  │ ───────────► │  Paperless-ngx │ ◄── Dokumente (Upload / Eingangsordner)
   └──────────────┘              └────────────────┘
                                   │    │    │
                             Postgres Redis Tika/Gotenberg
```

- **[Paperless-ngx](https://docs.paperless-ngx.com/)**: Open-Source-Dokumentenverwaltung mit Texterkennung (OCR), Volltextsuche, Schlagworten und Korrespondenten.
- **[easypaperless_mcp](https://github.com/MoritzGrenke/easypaperless_mcp)**: ein MCP-Server ([Model Context Protocol](https://modelcontextprotocol.io/)), über den KI-Assistenten Dokumente suchen, lesen und verschlagworten können.

## Lizenz

- Code und Konfigurationsdateien: [MIT](LICENSE)
- Artikeltext und Bilder im Ordner `artikel/`: Die Lizenz steht noch nicht fest und richtet sich nach der Veröffentlichung im Tagungsband. Bis dahin gilt die MIT-Lizenz **nicht** für diesen Ordner; alle Rechte vorbehalten.
