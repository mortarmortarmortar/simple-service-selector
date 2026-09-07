import QtQuick
import QtQuick.Layouts
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.extras as PlasmaExtras
import org.kde.plasma.plasmoid
import org.kde.kirigami as Kirigami

Item {
    id: fullRep

    Layout.minimumWidth: Kirigami.Units.gridUnit * 12
    Layout.minimumHeight: Kirigami.Units.gridUnit * 7
    Layout.preferredWidth: Kirigami.Units.gridUnit * 18
    Layout.preferredHeight: Kirigami.Units.gridUnit * 10

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
