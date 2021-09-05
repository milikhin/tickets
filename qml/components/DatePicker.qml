import QtQuick 2.9
import QtQuick.Controls 2.2

import Ubuntu.Components.Pickers 1.3 as Pickers

import "../utils.js" as QmlJs

Dialog {
    id: messageDialog
    standardButtons: Dialog.Ok | Dialog.Cancel
    modal: true
    title: i18n.tr("Select date")
    property alias date: picker.date

    Pickers.DatePicker {
        id: picker

        Component.onCompleted: {
            // tmp fix rendering issues for Suru Dark
            // TODO: a proper fix for Picker + HighlightMagnifier is needed
            if (QmlJs.isDarker(theme.palette.normal.background, theme.palette.normal.backgroundText)) {
                __styleInstance.highlightColor = theme.palette.normal.background
            }
        }
    }
}
