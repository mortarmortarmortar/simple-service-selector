import QtQuick
import org.kde.plasma.plasmoid
import org.kde.kirigami as Kirigami

// Shown when the widget is collapsed into a panel icon
Kirigami.Icon {
    source: Plasmoid.icon

    MouseArea {
        anchors.fill: parent
        onClicked: root.expanded = !root.expanded
    }
}
