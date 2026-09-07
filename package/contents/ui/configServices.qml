import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.iconthemes as KIconThemes

ColumnLayout {
    id: page

    property string cfg_services
    property alias cfg_pollInterval: pollSpin.value
    property alias cfg_extraPath: extraPathField.text
    property alias cfg_fitToContent: fitCheck.checked

    spacing: Kirigami.Units.largeSpacing

    ListModel {
        id: servicesModel
    }

    property bool loaded: false

    Component.onCompleted: {
        try {
            const arr = JSON.parse(cfg_services)
            if (Array.isArray(arr)) {
                for (const s of arr) {
                    servicesModel.append({
                        name: s.name || "",
                        icon: s.icon || "",
                        onCommand: s.onCommand || "",
                        offCommand: s.offCommand || "",
                        statusCommand: s.statusCommand || ""
                    })
                }
            }
        } catch (e) {
            console.warn("LocalAIToggle: could not parse services config:", e)
        }
        loaded = true
    }

    function save() {
        if (!loaded) {
            return
        }
        const arr = []
        for (let i = 0; i < servicesModel.count; ++i) {
            const s = servicesModel.get(i)
            arr.push({
                name: s.name,
                icon: s.icon,
                onCommand: s.onCommand,
                offCommand: s.offCommand,
                statusCommand: s.statusCommand
            })
        }
        cfg_services = JSON.stringify(arr)
    }

    KIconThemes.IconDialog {
        id: iconDialog
        property int targetIndex: -1
        onIconNameChanged: {
            if (targetIndex >= 0 && iconName !== "") {
                servicesModel.setProperty(targetIndex, "icon", iconName)
                page.save()
            }
        }
    }

    Kirigami.FormLayout {
        Layout.fillWidth: true

        RowLayout {
            Kirigami.FormData.label: i18n("Status poll interval:")
            spacing: Kirigami.Units.smallSpacing

            QQC2.SpinBox {
                id: pollSpin
                from: 0
                to: 3600
            }
            QQC2.Label {
                text: i18n("seconds (0 disables polling)")
            }
        }

        QQC2.TextField {
            id: extraPathField
            Kirigami.FormData.label: i18n("Extra PATH directories:")
            Layout.fillWidth: true
            placeholderText: i18n("colon-separated, e.g. $HOME/.lmstudio/bin")
        }

        QQC2.CheckBox {
            id: fitCheck
            Kirigami.FormData.label: i18n("Widget size:")
            text: i18n("Fit to buttons (no empty space)")
        }
    }

    Kirigami.InlineMessage {
        Layout.fillWidth: true
        visible: servicesModel.count > 0
        type: Kirigami.MessageType.Information
        text: i18n("Commands run through /bin/sh. A status command should exit with code 0 when the service is running.")
    }

    Repeater {
        model: servicesModel

        delegate: Kirigami.AbstractCard {
            Layout.fillWidth: true

            contentItem: ColumnLayout {
                spacing: Kirigami.Units.smallSpacing

                RowLayout {
                    spacing: Kirigami.Units.smallSpacing

                    QQC2.Button {
                        icon.name: model.icon || "system-run"
                        display: QQC2.AbstractButton.IconOnly
                        text: i18n("Choose icon")
                        QQC2.ToolTip.text: text
                        QQC2.ToolTip.visible: hovered
                        onClicked: {
                            iconDialog.targetIndex = index
                            iconDialog.open()
                        }
                    }

                    QQC2.TextField {
                        Layout.fillWidth: true
                        text: model.name
                        placeholderText: i18n("Service name")
                        onTextEdited: {
                            servicesModel.setProperty(index, "name", text)
                            page.save()
                        }
                    }

                    QQC2.Button {
                        icon.name: "edit-delete-remove"
                        display: QQC2.AbstractButton.IconOnly
                        text: i18n("Remove service")
                        QQC2.ToolTip.text: text
                        QQC2.ToolTip.visible: hovered
                        onClicked: {
                            servicesModel.remove(index)
                            page.save()
                        }
                    }
                }

                Kirigami.FormLayout {
                    Layout.fillWidth: true

                    QQC2.TextField {
                        Kirigami.FormData.label: i18n("On command:")
                        Layout.fillWidth: true
                        text: model.onCommand
                        placeholderText: i18n("e.g. lms load my-model -y")
                        onTextEdited: {
                            servicesModel.setProperty(index, "onCommand", text)
                            page.save()
                        }
                    }

                    QQC2.TextField {
                        Kirigami.FormData.label: i18n("Off command:")
                        Layout.fillWidth: true
                        text: model.offCommand
                        placeholderText: i18n("e.g. lms unload --all")
                        onTextEdited: {
                            servicesModel.setProperty(index, "offCommand", text)
                            page.save()
                        }
                    }

                    QQC2.TextField {
                        Kirigami.FormData.label: i18n("Status command:")
                        Layout.fillWidth: true
                        text: model.statusCommand
                        placeholderText: i18n("e.g. lms ps | grep -q my-model")
                        onTextEdited: {
                            servicesModel.setProperty(index, "statusCommand", text)
                            page.save()
                        }
                    }
                }
            }
        }
    }

    QQC2.Button {
        text: i18n("Add Service")
        icon.name: "list-add"
        onClicked: {
            servicesModel.append({
                name: "",
                icon: "system-run",
                onCommand: "",
                offCommand: "",
                statusCommand: ""
            })
            page.save()
        }
    }

    Item {
        Layout.fillHeight: true
    }
}
