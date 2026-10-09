# Rückmeldung an den CLI-Thread (stlive): GUI-Experimente 2026-10-09

Alles Folgende liegt in `MightySmalltalk/guis/`. Bitte lesen: `README.md` (Wege-Übersicht), `CLI-ANFORDERUNGEN.md` (ursprüngliche Anforderungen), `04-spec-gtk/NOTES.md` (Details Weg 4).

## 1. Fehler, den die CLI selbst beheben sollte (wichtigster Punkt)
**`stlive start --gui` scheitert mit dem alten Fehler, obwohl 0.4.0 ihn beheben soll.**
- Aufruf: `stlive start --gui` (Binary `smalltalk-live-cli/target/release/stlive`, Build 17:38, Source = Commit 2c34e4e / 0.4.0).
- Ergebnis: `start_failed: Image did not publish a port in time`; `~/.stlive/default.log` zeigt exakt den alten Fehler `stream not found in a StThreadSafeTranscript` in `StLiveTranscriptTee class>>install`.
- Vermutete Ursache: Der Smalltalk-Server steckt im **Template-Image** `~/.stlive/pharo/stlive.image` (Datum 17:12, gebaut mit 0.3.1). Das neue Binary kennt den Fix, nutzt aber das alte Image. Der Fix greift erst nach `stlive init --force`.
- Gewünscht: Das Binary soll beim Start erkennen, dass das Template-Image mit einer älteren Server-Version gebaut wurde, und eine klare Meldung geben (`Template ist veraltet, bitte 'stlive init --force'`) oder das Image selbst neu bauen. Eine Versionsnummer des eingebetteten Smalltalk-Codes im Image prüfen.
- Nicht getestet: ob nach `init --force` alles läuft (habe `~/.stlive` nicht angefasst, um dich nicht zu stören). Das sollte der CLI-Thread als Erstes prüfen.
- Nebenbei: `stlive --version` meldet `0.3.1`, obwohl CHANGELOG/Commit 0.4.0 sind. Version im Binary hochziehen.

## 2. Was ohne neue CLI trotzdem funktioniert hat (alles per Screenshot geprüft)
| Weg | Ergebnis |
|---|---|
| 01 Spec2 in Morphic (`01-spec-morphic/start.sh`) | Fenster in der Pharo-Welt, Button zählt. |
| 02 Zinc + HTML, Chrome `--app` (`02-web-window`) | Eigenes OS-Fenster, **mit stlive verbunden (headless)**. Live-Änderung der Button-Farbe per `method compile` und `save`: funktioniert. |
| 03 Rust-Hülle (wry/tao) (`03-webview-shell`) | `./build-app.sh` baut `HelloShell.app` (143 MB, VM + Image eingebaut, nichts zu installieren). Läuft, Button geht. Erster Start ca. 20 s. |
| 04 Spec2 + GTK4 (`04-spec-gtk`) | Eigenes GTK4-Fenster, CSS-Theming per `app addCSSProviderFromString:`, Button geht. Mac-ähnliche Optik. **Nur ohne stlive.** |

## 3. Was Weg 4 von der CLI braucht (neu gegenüber CLI-ANFORDERUNGEN.md)
Weg 4 ist der einzige Weg mit nativen Widgets und läuft nur unter diesen Bedingungen. Die CLI kann ihn bisher nicht starten:
1. **Pharo 14 statt 13**: Spec-Gtk braucht Pharo 14. Mit der 13er-VM (v10.3.x) und 14er-Image crasht es (Segfault in `GtkCairoSurface>>fill:`). Image und **passende VM** müssen zusammenpassen. Gewünscht: `stlive init --pharo 14` bzw. `start --vm/--image` pro Instanz (gibt es schon), plus Doku, dass die VM zum Image passen muss.
2. **Worker-Modus**: Start mit `--worker --headless` (kein `st ... --no-quit`; die 14er-VM kennt `--no-quit` nicht und beendet nach dem Skript nicht, wenn es im Worker läuft). `stlive start` müsste Startparameter pro Instanz erlauben (`--vm-args`) oder einen Modus `--worker` kennen.
3. **Kein Morphic-Fenster im Worker**: Nur `--worker` ohne `--headless` zeigt zusätzlich die Morphic-Welt über GTK mit Fehlerflut (`GRunLoop defer:`, `callbackEnter` nil). Deshalb ist `start --gui` (Morphic) für Weg 4 nicht geeignet; es braucht einen eigenen Modus (z.B. `start --gtk`): `--worker --headless`.
4. **Frisches Image bei jedem Start**: Ein einmal beendetes 14er-Image war danach kaputt (`cannot register existing type 'GtkListViewAdapterItemFactory'`). Vermutlich sorgt SIGTERM/Snapshot dafür. Die CLI arbeitet mit einer Image-Kopie pro Instanz (gut). Sicherstellen: `stop` nicht per SIGTERM (kein Snapshot), nie das Instanz-Image zurückschreiben, außer bei `image save`.
5. **UI-Thread in GTK**: `eval --ui` meint Morphic-UI-Prozess. Im GTK-Worker-Modus gibt es den nicht; Änderungen an Widgets müssen über `GRunLoop defer:` (oder die GTK-Hauptschleife) laufen. `ui windows/screenshot/press` müssen dafür eine Gtk-Variante haben (Screenshot eines GTK-Fensters ist im Image kaum möglich; evtl. nur über macOS `screencapture`).
6. **Windows**: Laut Spec-Gtk-README derzeit nicht lauffähig. Für „Mac und Windows“ gilt Weg 4 deshalb vorerst nicht.
7. **Auslieferung**: Für Weg 4 müssten GTK4, gtksourceview5, graphene, librsvg usw. als dylibs ins Paket (Pfad `/opt/homebrew` ist laut README fest). Nicht gebaut. Für die Empfehlung (Weg 3) irrelevant.

## 4. Was für Weg 2/3 (empfohlen) hilfreich wäre
- `stlive open-ui <url>`: laut Changelog vorhanden, ungetestet von mir (ich habe `open-window.sh` benutzt).
- Ein Befehl, der das fertige Image **für die Auslieferung** speichert (`image save` mit Startskript, das den Server automatisch startet), damit `build-app.sh` weniger Handarbeit braucht. Aktuell: Baseline per Skript laden, `Smalltalk snapshot: true andQuit: true`.
- stlive selbst sollte im ausgelieferten Paket nicht nötig sein; sinnvoll wäre aber ein „Release-Modus“, der den StLive-Server aus dem Image entfernt oder nicht startet (Sicherheit: der Server läuft sonst als offener Eval-Port).

## 5. Noch nicht verifiziert
- `start --gui`, `eval --ui`, `ui windows|screenshot|press` und `open-ui`: gestartet, aber wegen Punkt 1 nicht bis zum Ende gebracht.
- Windows insgesamt.
