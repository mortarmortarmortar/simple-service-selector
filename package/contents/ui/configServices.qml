import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

// Config page: add/remove/edit service toggle definitions.
// Bound to the "services" JSON entry in config/main.xml via
// the cfg_services property convention.
Kirigami.FormLayout {
    id: page

    property alias cfg_services: servicesField.text
    property alias cfg_pollInterval: pollIntervalField.value

    // TODO: replace with a proper editable list (name, icon picker,
    // on/off/status commands). Raw JSON field for now.
    TextField {
        id: servicesField
        Kirigami.FormData.label: i18n("Services (JSON):")
    }

    SpinBox {
        id: pollIntervalField
        from: 0
        to: 3600
        Kirigami.FormData.label: i18n("Status poll interval (seconds):")
    }
}
