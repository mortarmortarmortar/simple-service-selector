# Local AI Toggle

A KDE Plasma 6 widget with configurable toggle buttons for starting and
stopping local services — built primarily for loading and unloading AI
models (e.g. LM Studio via `lms load` / `lms unload`) so you can free up
VRAM before hopping into a game.

## Features

- Grid of toggle buttons, one per configured service
- Add/remove services from the widget settings, with an icon picker
- Per-service on/off/status shell commands
- Live status indicator per service (colored dot + label, polled on an interval)
- Busy spinner while a load/unload command is running

## How it works

Each service has three shell commands (run through `/bin/sh -c` via the
Plasma `executable` data engine):

| Command | Purpose |
|---|---|
| On command | Runs when you click the button while the service is off |
| Off command | Runs when you click the button while the service is on |
| Status command | Polled on an interval; **exit code 0 = running**, anything else = stopped |

### LM Studio example

- **On command:** `lms load qwen/qwen3-14b -y`
- **Off command:** `lms unload --all`
- **Status command:** `lms ps | grep -q qwen3-14b`

> [!TIP]
> plasmashell may not have your interactive shell's `PATH` (e.g.
> `~/.lmstudio/bin`). If a command works in your terminal but not in the
> widget, use the absolute path, e.g. `$HOME/.lmstudio/bin/lms`.

Anything else with a start/stop/check shape works the same way, e.g. a
systemd unit: `systemctl --user start ollama` / `systemctl --user stop
ollama` / `systemctl --user is-active --quiet ollama`.

## Install

```sh
./install.sh
```

Then add "Local AI Toggle" to your desktop or panel via *Add Widgets…*

Uninstall:

```sh
kpackagetool6 -t Plasma/Applet -r com.github.mortarmortarmortar.localaitoggle
```

## Layout

```
package/
├── metadata.json                  # Plasmoid metadata (Plasma 6)
└── contents/
    ├── config/
    │   ├── main.xml               # Config schema (services JSON, poll interval)
    │   └── config.qml             # Config dialog page registry
    └── ui/
        ├── main.qml               # Root item: service model, command runner, status polling
        ├── FullRepresentation.qml # Toggle button grid
        ├── ServiceButton.qml      # One toggle button (icon, status dot, busy spinner)
        ├── CompactRepresentation.qml # Panel icon view
        └── configServices.qml     # Settings page: service list editor
```

## Development

Preview without touching your desktop (needs `plasma-sdk`):

```sh
plasmoidviewer -a package
```

After changing files, re-run `./install.sh` and restart plasmashell
(`systemctl --user restart plasma-plasmashell.service`) to reload.

## Requirements

- KDE Plasma 6 (developed against 6.7)
- For LM Studio toggles: the `lms` CLI

## License

GPL-3.0-or-later
