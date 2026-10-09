# Weg 04: Spec2 + GTK4 (getestet auf macOS arm64, 2026-10-09)

**Ergebnis: funktioniert.** Eigenes OS-Fenster ohne Pharo-Welt, Spec2-Presenter aus Demo 01 unveraendert, Button-Klick geht, Theming per GTK-CSS (`app addCSSProviderFromString:`) geht (Verlauf, runde gruene Buttons).

## Voraussetzungen (alles lief erst nach diesen Schritten)
1. `brew install gtk4 gtksourceview5` (gtk+3 reicht nicht; gtksourceview5 wird schon beim Start angebunden).
2. **Pharo 14** (nicht 13): Image + **passende 14er-VM**. Eine 13er-VM mit 14er-Image stuerzt ab (Segfault in `GtkCairoSurface>>fill:`).
   `p14/` anlegen: `curl https://get.pharo.org/64/140 | bash` und `curl https://get.pharo.org/64/vm140 | bash`.
3. Spec-Gtk einmal ins Image laden (`p14/load.st`), Ergebnis als `base.image`/`base.changes` ablegen. Siehe unten, warum.
4. Start mit `--worker --headless` (nicht `--worker` allein: dann zeigt Pharo zusaetzlich seine Morphic-Welt ueber GTK, mit Fehlerflut `GRunLoop defer:`). `--no-quit` kennt die 14er-VM nicht.

## Fallen
- Ein einmal gestartetes/beendetes Image war danach kaputt (`cannot register existing type 'GtkListViewAdapterItemFactory'`). `start.sh` kopiert deshalb immer frisch von `base.image`. Prozess mit `kill -9` beenden.
- Nicht mit stlive verbunden: stlive startet 13er-VM headless ohne Worker. Fuer Live-Entwicklung braucht die CLI: Pharo-14-Image + VM waehlbar, Worker-Modus-Start, Transcript-Fix.
- **Windows: laut Spec-Gtk-README derzeit nicht lauffaehig.** Nicht getestet.

## Aussehen
GTK4 auf macOS: Fenster mit normalen macOS-Fensterknoepfen, Widgets wirken mac-aehnlich (hell, abgerundet). Per CSS frei gestaltbar, aber nicht so frei wie HTML/CSS.

## Auslieferung (offen)
Brauchte mindestens: GTK4, gtksourceview5, graphene, librsvg und deren Abhaengigkeiten als dylibs im Paket, Pfade umbiegen (Spec-Gtk sucht unter /opt/homebrew, "paths are fixed for now" laut README), plus 14er-VM und Image. Nicht gebaut, erwarte deutlich mehr Aufwand als Weg 03.
