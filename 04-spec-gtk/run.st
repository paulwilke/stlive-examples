"Way 04: HelloPresenter (from 01) with the Gtk backend + GTK CSS theming. Start: ./start.sh"
| app presenter |
Metacello new baseline: 'HelloWindow'; repository: 'tonel://', (FileLocator workingDirectory parent parent / '01-spec-morphic' / 'src') fullName; load.
app := SpApplication new useBackend: #Gtk.
app addCSSProviderFromString: '
window { background: linear-gradient(135deg, #6366f1, #ec4899); }
label { color: white; font-size: 20px; font-weight: bold; }
button { background: #059669; color: white; border-radius: 12px; padding: 10px 24px; border: none; box-shadow: none; }
button:hover { background: #047857; }'.
presenter := (Smalltalk at: #HelloPresenter) new application: app; yourself.
presenter open.
