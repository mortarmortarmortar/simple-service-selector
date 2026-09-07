import QtQuick
import QtQuick.Layouts
import org.kde.plasma.components as PlasmaComponents
import org.kde.kirigami as Kirigami

PlasmaComponents.ItemDelegate {
    id: button

    required property int index
    required property var modelData

    readonly property string status: root.statusOf(index)
    readonly property bool busy: root.isBusy(index)
    readonly property color statusColor: status === "running"
        ? Kirigami.Theme.positiveTextColor
        : status === "stopped"
            ? Kirigami.Theme.disabledTextColor
            : Kirigami.Theme.neutralTextColor

    width: Kirigami.Units.gridUnit * 6
    height: Kirigami.Units.gridUnit * 5

    enabled: !busy
    onClicked: root.toggle(index)

    PlasmaComponents.ToolTip {
        text: busy
            ? i18n("%1 — working…", modelData.name)
            : i18n("%1 — click to turn %2", modelData.name,
                   status === "running" ? i18n("off") : i18n("on"))
    }

    contentItem: ColumnLayout {
        spacing: Kirigami.Units.smallSpacing

        Item {
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: Kirigami.Units.iconSizes.medium
            Layout.preferredHeight: Kirigami.Units.iconSizes.medium

            Kirigami.Icon {
                anchors.fill: parent
                source: button.modelData.icon || "system-run"
                visible: !button.busy
            }

            PlasmaComponents.BusyIndicator {
                anchors.fill: parent
                running: button.busy
                visible: button.busy
            }

            Rectangle {
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.margins: -Kirigami.Units.smallSpacing / 2
                width: Kirigami.Units.iconSizes.small / 2
                height: width
                radius: width / 2
                color: button.statusColor
                border.width: 1
                border.color: Kirigami.Theme.backgroundColor
                visible: !button.busy && button.modelData.statusCommand
            }
        }

        PlasmaComponents.Label {
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
            text: button.modelData.name || i18n("Unnamed")
            elide: Text.ElideRight
            maximumLineCount: 1
        }

        PlasmaComponents.Label {
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
            visible: button.modelData.statusCommand !== undefined
                     && button.modelData.statusCommand !== ""
            text: button.busy
                ? i18n("Working…")
                : button.status === "running"
                    ? i18n("Running")
                    : button.status === "stopped" ? i18n("Stopped") : i18n("Unknown")
            color: button.statusColor
            font: Kirigami.Theme.smallFont
        }
    }
}
