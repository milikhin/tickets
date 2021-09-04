import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Suru 2.2
import QtQuick.Layouts 1.3

import Ubuntu.Components 1.3 as UITK

Item {
    id: root
    property string label
    property string text
    property bool required: false
    property bool hasButton: false
    property bool buttonEnabled: true
    property string btnIcon: 'edit-clear'
    property string placeHolder
    signal btnClicked()
    signal clicked()

    height: childrenRect.height

    ColumnLayout {
        id: layout
        width: parent.width
        spacing: 0

        Label {
            Layout.fillWidth: true
            text: root.label
            font.bold: required
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        }

        RowLayout {
            Layout.fillWidth: true

            Item {
                Layout.fillWidth: true
                height: textField.height

                TextField {
                    id: textField
                    width: parent.width
                    text: root.text
                    focus: false
                    placeholderText: root.placeHolder
                }

                MouseArea {
                    anchors.fill: parent
                    preventStealing: true
                    propagateComposedEvents: false
                    onClicked: root.clicked()
                }
            }

            Button {
                onClicked: btnClicked()
                opacity: hasButton ? 1 : 0
                enabled: hasButton && buttonEnabled
                UITK.Icon {
                    anchors.centerIn: parent
                    color: theme.palette.normal.backgroundText
                    height: Suru.units.gu(2)
                    width: Suru.units.gu(2)
                    name: btnIcon
                }
            }
        }
    }
}
