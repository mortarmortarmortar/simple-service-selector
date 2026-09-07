import QtQuick
import QtQuick.Layouts
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.extras as PlasmaExtras
import org.kde.plasma.plasmoid
import org.kde.kirigami as Kirigami

Item {
    id: fullRep

    readonly property bool fitContent: Plasmoid.configuration.fitToContent
    readonly property real buttonWidth: Kirigami.Units.gridUnit * 6
    readonly property real buttonHeight: Kirigami.Units.gridUnit * 5

    // Width of all buttons in a single row; falls back to placeholder size
    readonly property real contentWidth: root.services.length > 0
        ? root.services.length * buttonWidth
          + (root.services.length - 1) * Kirigami.Units.smallSpacing
        : Kirigami.Units.gridUnit * 12
    readonly property real contentHeight: root.services.length > 0
        ? buttonHeight
        : Kirigami.Units.gridUnit * 7

    Layout.minimumWidth: fitContent ? contentWidth : Kirigami.Units.gridUnit * 12
    Layout.minimumHeight: fitContent ? contentHeight : Kirigami.Units.gridUnit * 7
    Layout.maximumWidth: fitContent ? contentWidth : Number.POSITIVE_INFINITY
    Layout.maximumHeight: fitContent ? contentHeight : Number.POSITIVE_INFINITY
    Layout.preferredWidth: fitContent ? contentWidth : Kirigami.Units.gridUnit * 18
    Layout.preferredHeight: fitContent ? contentHeight : Kirigami.Units.gridUnit * 10

    PlasmaExtras.PlaceholderMessage {
        anchors.centerIn: parent
        width: parent.width - Kirigami.Units.gridUnit * 2
        visible: root.services.length === 0
        iconName: "preferences-system-services"
        text: i18n("No services configured")
        explanation: i18n("Add toggle buttons for your AI models and services")
        helpfulAction: Kirigami.Action {
            icon.name: "configure"
            text: i18n("Configure…")
            onTriggered: Plasmoid.internalAction("configure").trigger()
        }
    }

    PlasmaComponents.ScrollView {
        id: scroll
        anchors.fill: parent
        visible: root.services.length > 0
        contentWidth: availableWidth

        // Left-to-right flow: buttons line up horizontally and only wrap
        // to a new row when they run out of width
        Flow {
            width: scroll.availableWidth
            spacing: Kirigami.Units.smallSpacing

            Repeater {
                model: root.services
                delegate: ServiceButton {}
            }
        }
    }
}
