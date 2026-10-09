# Third-party software

This repository contains **no** third-party binaries or source. The following is downloaded or installed by the scripts or by you. Please check each license before redistributing anything built from it (for example `HelloShell.app`, which bundles the Pharo VM and image).

| Component | Used by | License | Source |
|---|---|---|---|
| Pharo (VM and image) | all ways | MIT (see the LICENSE file of the Pharo project; some parts carry their own terms) | https://pharo.org |
| Zinc HTTP components (part of Pharo) | 02, 03 | MIT | https://pharo.org |
| Spec2 (part of Pharo) | 01, 04 | MIT | https://pharo.org |
| Spec-Gtk | 04 | no license file found in the repository at the time of writing (checked 2026-10-09); not redistributed here, please check upstream | https://github.com/pharo-spec/Spec-Gtk |
| wry, tao (Rust crates, Tauri project) | 03 | Apache-2.0 / MIT, see each crate | https://github.com/tauri-apps |
| GTK 4, gtksourceview 5, librsvg | 04 | LGPL-2.1+ | via Homebrew |
| graphene | 04 | MIT | via Homebrew |
| stlive (CLI and skill) | development workflow | MIT | https://github.com/paulwilke/smalltalk-live-cli |
| Google Chrome / Microsoft Edge | 02 | proprietary, not distributed | only launched if installed |

This list is a convenience, not legal advice; the license files of each project are authoritative. Pharo and the Pharo logo are trademarks of their respective owners; the screenshots in `docs/` show only the demo windows.
