# Was stlive braucht, um mit offener GUI zu entwickeln

## Befund
`stlive start` startet Pharo immer mit `--headless`. Startet man Pharo mit Fenster und führt dasselbe `serve.st` aus, bricht der Server ab:
`StLiveTranscriptTee class>>install` ruft `instVarNamed: 'stream'` auf `StThreadSafeTranscript` auf; im GUI-Modus ist `Transcript` ein anderes Objekt ohne dieses Feld (`InstanceVariableNotFound`). Es entsteht keine `port.json`, also kein Kontakt.
Der Befehl `stlive attach` hilft nur, wenn bereits ein Server im Image läuft.

## Benötigt
1. **`stlive start --gui`** (bzw. `--no-headless`): VM ohne `--headless` starten, ansonsten identisch (Port-Datei, pid, Log, Instanz-State).
2. **Transcript-Tee robust machen**: Transcript-Typ prüfen (`StThreadSafeTranscript` vs. GUI-Transcript/`TranscriptStream`), fehlende Felder abfangen; im Zweifel Ausgabe über Hook auf `Transcript show:` statt über `instVarNamed:`. Fehler beim Tee darf den Serverstart nie verhindern.
3. **UI-Thread-Sicherheit**: Im GUI-Image läuft Morphic/Spec im UI-Prozess. `eval` und `method compile` sollten optional `--ui` anbieten (Ausführung via `UIManager default defer:` bzw. `World defer:`), sonst Rennen beim Zeichnen/Layouten. Ergebnis wie gewohnt zurückgeben.
4. **Debug-Sessions ohne Pharo-Debugger-Fenster**: Im GUI-Modus würde ein Fehler im UI-Prozess den normalen Debugger öffnen. Der Server soll Fehler weiter abfangen und als Session melden (so wie headless), den Debugger nicht öffnen (UnhandledError-Handler überschreiben, aber nur für stlive-Evals).
5. **Fenster-Befehle** (nice to have): `stlive ui windows` (offene Fenster/Presenter listen), `stlive ui screenshot [--window n]` (PNG, z.B. `World imageForm`/`Form fromDisplay:`), `stlive ui click x y` oder besser `stlive ui press <Button-Name/Ref>`, damit der Loop „ändern → ansehen → prüfen“ ohne externe Tools geht.
6. **`stlive image save` im GUI-Modus** und sauberes `stop` (Fenster schließen, Image nicht speichern lassen, kein Save-Dialog).
7. **Plattform**: heute nur macOS/Linux (`process_group`, `lsof`). Für Windows: Prozess starten via `Command` ohne Unix-Teile, `lsof` durch Port-Datei ersetzen, VM-Pfad `Pharo.exe`.
8. **Kundentaugliche UI ohne Pharo-Oberfläche**: Zwei Wege, beide mit headless stlive vereinbar:
   - **Web-UI** (Demo 02): `stlive start` wie bisher; Zinc/Teapot/Seaside-Server im Image; `stlive open-ui <url>` öffnet Chrome/Edge `--app` (macOS `open -na`, Windows `msedge --app`). Verbunden und entwickelbar ohne GUI-Modus.
   - **Native Widgets** (Spec2-GTK oder Bloc/Toplo via SDL2): braucht GUI-Modus (Punkte 1–4) und auf dem Mac GTK3 (`brew install gtk+3`, in dieser Maschine nicht vorhanden; Spec-Gtk ist im Standard-Image nicht geladen).

## Empfehlung / Reihenfolge
- Sofort nutzbar: Weg Web-UI (Punkt 8, keine CLI-Änderung nötig; nur `open-ui` als Komfort).
- Für Spec/Bloc: Punkt 2 (Transcript-Fix) und 1 (`--gui`) sind klein; 3–4 sind das eigentliche Risiko.
