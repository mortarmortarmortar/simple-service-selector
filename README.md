# Local AI Toggle

A KDE Plasma 6 widget with configurable toggle buttons for starting and
stopping local services — built primarily for loading and unloading AI
models (e.g. LM Studio via `lms load` / `lms unload`) so you can free up
VRAM before hopping into a game.

## Features (planned)

- Panel of toggle buttons, one per configured service
- Add/remove services from the widget settings
- Per-service icon, and on/off/status commands
- Live status indicator per service (polled)

## Layout

```
package/
├── metadata.json                  # Plasmoid metadata (Plasma 6)
└── contents/
    ├── config/
    │   ├── main.xml               # Config schema (services JSON, poll interval)
    │   └── config.qml             # Config dialog page registry
    └── ui/
        ├── main.qml               # PlasmoidItem root
        ├── FullRepresentation.qml # Button grid (desktop/expanded view)
        ├── CompactRepresentation.qml # Panel icon view
        └── configServices.qml     # Service editor config page
```

## Development

Install/upgrade the widget for the current user:

```sh
./install.sh
```

Preview without touching your desktop:

```sh
plasmoidviewer -a package
```

Uninstall:

```sh
kpackagetool6 -t Plasma/Applet -r com.github.garrett.localaitoggle
```

## Requirements

- KDE Plasma 6 (developed against 6.7)
- For LM Studio toggles: the `lms` CLI on your `PATH`

## License

GPL-3.0-or-later
