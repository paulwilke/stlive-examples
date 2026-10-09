# GUIs für Pharo-Apps (mit stlive entwickeln, lokal ausliefern)

Ziel: lokale App, die gut aussieht, entwickelt live mit `stlive`, ausgeliefert ohne Pharo-IDE für den Kunden.
Voraussetzung: einmal `stlive init` (Pharo 13 nach `~/.stlive`).

| # | Weg | Fenster | stlive heute nutzbar? | Optik | Auslieferung | Stand |
|---|---|---|---|---|---|---|
| 01 | Spec2 in Morphic | in der Pharo-Welt | nein (braucht `--gui`) | Pharo-Theme | Kunde sieht Pharo | getestet |
| 02 | Zinc + HTML, Chrome/Edge `--app` | eigenes OS-Fenster | **ja** | frei (CSS) | Kunde braucht Chrome/Edge | getestet (mac) |
| 03 | Zinc + HTML in eigener Rust-Hülle (wry/tao = Tauri-Kern) | eigenes OS-Fenster, System-Webview | **ja** | frei (CSS) | 1 Binary + VM + Image, nichts weiter nötig | gebaut, siehe unten |
| 04 | Spec2 mit GTK4-Backend | eigenes OS-Fenster | nein (braucht Pharo 14, Worker-Modus, `--gui`) | GTK4, per CSS themebar | VM + Image + viele GTK4-dylibs; **Windows laut README derzeit nicht lauffaehig** | **getestet auf macOS, funktioniert** (siehe 04-spec-gtk/NOTES.md) |

## Architektur Weg 02/03
Image headless (stlive verbunden) → Zinc-Server (`WebHello`, Port 8765) → HTML/CSS/JS im Fenster. Logik in Smalltalk, Oberfläche in Web-Technik. Änderungen: Code per stlive ändern, Fenster neu laden.

## Weg 03 starten
```bash
cd 03-webview-shell && cargo build --release && ./target/release/hello-shell
```
Fertige App: `./build-app.sh` erzeugt `dist/HelloShell.app` (143 MB, VM + Image eingebaut, nichts zu installieren; getestet, Button funktioniert).
Die Hülle kopiert das Pharo-Image nach `.run/`, startet Pharo headless mit `server.st` (lädt `../02-web-window/src`), wartet auf den Port, öffnet das Fenster und beendet Pharo beim Schließen.
Für die Auslieferung: Hülle + Pharo-VM + fertiges Image in ein Paket (macOS `.app`, Windows Ordner/Installer). Das haben wir noch nicht gebaut.

## Weg 04 (offen)
Offene Punkte stehen in `CLI-ANFORDERUNGEN.md` (GUI-Modus der CLI) und in `04-spec-gtk/NOTES.md`.

## Weitere Dateien
- `CLI-ANFORDERUNGEN.md`: was stlive für den GUI-Modus braucht.
- `RUECKMELDUNG-AN-CLI-THREAD.md`: Testergebnis zu stlive 0.4.0 und offene Punkte.
