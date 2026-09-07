#!/usr/bin/env bash
# Install or upgrade the plasmoid for the current user.
set -euo pipefail
cd "$(dirname "$0")"

ID="com.github.mortarmortarmortar.localaitoggle"

if kpackagetool6 -t Plasma/Applet --list | grep -q "$ID"; then
    kpackagetool6 -t Plasma/Applet -u package
else
    kpackagetool6 -t Plasma/Applet -i package
fi

echo "Installed $ID. If the widget is already on your desktop, reload it with:"
echo "  systemctl --user restart plasma-plasmashell.service"
