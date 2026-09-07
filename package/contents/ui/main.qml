import QtQuick
import org.kde.plasma.plasmoid

PlasmoidItem {
    id: root

    preferredRepresentation: fullRepresentation

    fullRepresentation: FullRepresentation {}
    compactRepresentation: CompactRepresentation {}
}
