# Way 04: Spec2 + GTK4 (tested on macOS arm64, 2026-10-09)

**Result: it works.** Own OS window without the Pharo world, the Spec2 presenter from demo 01 unchanged, the button click works, and theming via GTK CSS (`app addCSSProviderFromString:`) works (gradient, rounded green buttons).

## Requirements (it only ran after all of these)
1. `brew install gtk4 gtksourceview5` (GTK 3 is not enough; gtksourceview5 is bound at startup).
2. **Pharo 14** (not 13): image plus the **matching 14 VM**. A 13 VM with a 14 image crashes (segfault in `GtkCairoSurface>>fill:`). `./setup.sh` fetches both into `p14/`.
3. Load Spec-Gtk into the image once (`setup.sh` does this) and keep the result as `base.image` / `base.changes`.
4. Start with `--worker --headless`. `--worker` alone additionally shows Pharo's Morphic world through GTK and floods the log with errors (`GRunLoop defer:`). The 14 VM does not know `--no-quit`.

## Pitfalls
- An image that had been started and stopped once was broken afterwards (`cannot register existing type 'GtkListViewAdapterItemFactory'`). `start.sh` therefore always copies a fresh `base.image`. Stop the process with `kill -9`.
- Not connected to stlive: stlive starts a Pharo 13 VM headless without worker mode. Live development here would need Pharo 14 image and VM selectable, a worker-mode start, and a GTK-aware UI thread.
- **Windows: according to the Spec-Gtk README it currently does not work.** Not tested.

## Look
GTK4 on macOS: window with the normal macOS window buttons, widgets look Mac-like (light, rounded). Freely stylable via CSS, though not as freely as HTML/CSS.

## Shipping (open)
At least GTK4, gtksourceview5, graphene, librsvg and their dependencies would have to be bundled as dylibs, with paths rewritten (Spec-Gtk looks under /opt/homebrew, "paths are fixed for now" according to its README), plus the 14 VM and the image. Not built; expect much more work than way 03.
