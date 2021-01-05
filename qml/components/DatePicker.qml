import QtQuick 2.9
import QtQuick.Controls 2.2

import Ubuntu.Components.Pickers 1.3 as Pickers

Dialog {
    id: messageDialog
    standardButtons: Dialog.Ok | Dialog.Cancel
    modal: true
    title: qsTr("Select date")
    property alias date: picker.date

    Pickers.DatePicker {
        id: picker
    }
}
