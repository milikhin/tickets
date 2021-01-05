import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Suru 2.2
import QtQuick.Layouts 1.3

import Ubuntu.Components 1.3 as UITK

ToolButton {
    id: root
    property string icon

    focusPolicy: Qt.NoFocus
    UITK.Icon {
        anchors.centerIn: parent
        color: theme.palette.normal.backgroundText
        height: Suru.units.gu(2)
        width: Suru.units.gu(2)
        name: root.icon
    }
}
