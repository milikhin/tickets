import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Suru 2.2
import QtQuick.Layouts 1.3

import "./utils.js" as QmlJs

ColumnLayout {
    id: root
    readonly property int itemSpacing: 8
    readonly property int spacing: itemSpacing
    property string lang

    signal selected(string code, string name)

    onFocusChanged: {
        textField.focus = true
    }


    Label {
        Layout.topMargin: itemSpacing
        Layout.leftMargin: itemSpacing
        Layout.rightMargin: itemSpacing

        text: i18n.tr('Search:')
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
    }

    TextField {
        id: textField
        Layout.fillWidth: true
        Layout.leftMargin: itemSpacing
        Layout.rightMargin: itemSpacing
        Layout.bottomMargin: itemSpacing
        property real uid

        inputMethodHints: Qt.ImhNoPredictiveText
        focus: true

        placeholderText: i18n.tr("City or airport...")
        onTextChanged: {
            model.clear()
            if (!text) {
                return
            }

            var requestId = Math.random()
            uid = requestId

            error.visible = false
            resultsLabel.visible = false
            busyIndicator.visible = true

            QmlJs.findCity(text, root.lang, function(err, res) {
                if (uid !== requestId) {
                    return
                }

                busyIndicator.visible = false
                if (err) {
                    error.visible = true
                    return console.error(err)
                }
                resultsLabel.visible = true

                model.clear()
                res.forEach(function(airport, i) {
                    model.append({ name: airport.name, code: airport.code })
                })
            })
        }
    }

    Label {
        id: error
        Layout.fillWidth: true
        Layout.leftMargin: itemSpacing
        Layout.rightMargin: itemSpacing
        visible: false

        text: i18n.tr('Unable to load airport list. Please check you network connection')
        horizontalAlignment: Qt.AlignHCenter
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
    }

    Label {
        id: resultsLabel
        Layout.fillWidth: true
        Layout.leftMargin: itemSpacing
        Layout.rightMargin: itemSpacing
        visible: false

        text: i18n.tr(model.count > 0 ? 'Select city/airport:' : 'No results found')
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
    }

    Item {
        Layout.fillWidth: true
        BusyIndicator {
            id: busyIndicator
            anchors.horizontalCenter: parent.horizontalCenter
            visible: false
        }
    }

    ColumnLayout {
        Layout.fillWidth: true
        Layout.fillHeight: true
        spacing: 0

        Rectangle {
            Layout.fillWidth: true
            Layout.leftMargin: itemSpacing
            Layout.rightMargin: itemSpacing
            height: Suru.units.dp(1)
            color: Suru.neutralColor
            visible: model.count > 0 && !busyIndicator.visible
        }

        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            implicitHeight: contentHeight
            flickableDirection: Flickable.VerticalFlick
            boundsBehavior: Flickable.StopAtBounds
            clip: true

            model: ListModel {
                id: model
            }

            ScrollBar.vertical: ScrollBar {}

            delegate: MouseArea {
                width: root.width - itemSpacing
                x: itemSpacing
                height: listContent.height
                onClicked: {
                    selected(code, name)
                }

                Column {
                    width: parent.width

                    Rectangle {
                        height: 40
                        id: listContent
                        width: parent.width
                        color: "transparent"

                        Label {
                            anchors.fill: parent
                            elide: Label.ElideRight
                            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                            text: name
                            verticalAlignment: Qt.AlignVCenter
                        }
                    }
                }
            }
        }
    }
}
