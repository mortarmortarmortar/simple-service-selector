import QtQuick
import QtQuick.Layouts
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.plasmoid
import org.kde.kirigami as Kirigami

ColumnLayout {
    id: fullRep

    Layout.minimumWidth: Kirigami.Units.gridUnit * 12
    Layout.minimumHeight: Kirigami.Units.gridUnit * 8

    // TODO: replace placeholder with the grid of configurable service
    // toggle buttons driven by plasmoid.configuration.services
    PlasmaComponents.Label {
        Layout.alignment: Qt.AlignCenter
        text: i18n("Local AI Toggle — no services configured yet")
        opacity: 0.6
    }
}
