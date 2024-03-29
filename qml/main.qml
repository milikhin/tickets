import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import QtQuick.Controls.Suru 2.2
import QtQuick.Layouts 1.3
import Qt.labs.platform 1.0
import Qt.labs.settings 1.0
import Ubuntu.Components 1.3 as UITK

import "./utils.js" as QmlJs
import "./components" as Components

ApplicationWindow {
    id: root
    visible: true
    width: 320
    height: 480

    readonly property string defaultTitle: i18n.tr("Search for airline tickets")
    readonly property int itemSpacing: 8
    // White Label base URL
    readonly property string whiteLabelUrl: 'tickets.milikhin.name'
    // JetRadar base URL
    readonly property string mainUrl: 'jetradar.com'
    // (optional) Link prefix generated by JetRadar's link generator
    readonly property string partnerUrl: ''
    readonly property string lang: locale.name.split('_')[0]

    title: defaultTitle

    header: ToolBar {
        RowLayout {
            spacing: itemSpacing
            anchors {
                fill: parent
            }

            Components.ToolButton {
                onClicked: {
                    pageStack.pop()
                    headerText.text = defaultTitle
                }
                icon: 'go-previous'
                visible: pageStack.depth > 1
            }
            Label {
                id: headerText
                text: root.title
                elide: Label.ElideRight
                horizontalAlignment: Qt.AlignLeft
                verticalAlignment: Qt.AlignVCenter
                Layout.fillWidth: true
            }
            Components.ToolButton {
                id: openBrowserBtn
                icon: 'external-link'
                visible: pageStack.currentItem.url !== undefined
                onClicked: {
                    var url = QmlJs.getSearchUrl({
                        baseUrl: mainUrl,
                        from: searchParams.fromIata,
                        to: searchParams.toIata,
                        departDate: searchParams.departDate,
                        returnDate: searchParams.returnDate,
                        adults: searchParams.adultsNumber,
                        children: searchParams.childrenNumber,
                        infants: searchParams.infantsNumber,
                        currency: searchParams.currency,
                        lang: root.lang,
                    })
                    // URL is generated by JetRadar link generator
                    var fullUrl = partnerUrl
                        ? partnerUrl + encodeURIComponent(url)
                        : url
                    Qt.openUrlExternally(fullUrl)
                }
            }
            Components.ToolButton {
                icon: 'settings'
                visible: pageStack.depth === 1
                onClicked: {
                    pageStack.push('./Settings.qml', {
                        currency: searchParams.currency
                    })
                    headerText.text = i18n.tr('Settings')
                    pageStack.currentItem.currencyChanged.connect(function() {
                        searchParams.currency = pageStack.currentItem.currency
                    })
                }
            }
        }

        // ProgressBar {
        //     anchors {
        //         bottom: parent.bottom
        //         left: parent.left
        //         right: parent.right
        //         leftMargin: -itemSpacing
        //         rightMargin: -itemSpacing
        //     }
        //     indeterminate: true
        //     visible: pageStack.currentItem.loading === true
        // }
    }

    Component.onCompleted: {
        i18n.domain = "tickets.mikhael"
    }

    Components.SearchParams {
        id: searchParams
    }

    StackView {
        id: pageStack
        initialItem: main
        anchors.fill: parent
        anchors.bottomMargin: Qt.inputMethod.visible
            ? Qt.inputMethod.keyboardRectangle.height / Screen.devicePixelRatio
            : 0
        // Ensures the focus changes to your page whenever
        // you show a different page
        onCurrentItemChanged: {
            currentItem.forceActiveFocus()
        }
    }

    ScrollView {
        id: main
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

        ColumnLayout {
            width: root.width - itemSpacing * 2
            x: itemSpacing

            Components.FakeTextField {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignTop
                Layout.topMargin: itemSpacing

                label: i18n.tr('From:')
                placeHolder: i18n.tr('Select airport...')
                text: searchParams.fromCity
                    ? searchParams.fromCity + ' (' + searchParams.fromIata + ')'
                    : ''
                required: true
                onClicked: {
                    pageStack.push('./CityPicker.qml', { lang: root.lang })
                    headerText.text = i18n.tr('Departure city')
                    pageStack.currentItem.selected.connect(function(iata, name) {
                        searchParams.setFrom(iata, name)
                        pageStack.pop()
                        headerText.text = defaultTitle
                    })
                }

                hasButton: true
                btnIcon: 'retweet'
                buttonEnabled: searchParams.fromIata || searchParams.toIata
                onBtnClicked: {
                    const currentFromIata = searchParams.fromIata
                    const currentFromCity = searchParams.fromCity
                    searchParams.setFrom(searchParams.toIata || '', searchParams.toCity || '')
                    searchParams.setTo(currentFromIata || '', currentFromCity || '')
                }
            }

            Components.FakeTextField {
                Layout.fillWidth: true

                label: i18n.tr('To:')
                text: searchParams.toCity
                    ? searchParams.toCity + ' (' + searchParams.toIata + ')'
                    : ''
                placeHolder: i18n.tr('Select airport...')
                required: true
                onClicked: {
                    pageStack.push('./CityPicker.qml', { lang: root.lang })
                    headerText.text = i18n.tr('Destination city')
                    pageStack.currentItem.selected.connect(function(iata, name) {
                        searchParams.setTo(iata, name)
                        pageStack.pop()
                        headerText.text = defaultTitle
                    })
                }
            }

            Components.FakeTextField {
                Layout.fillWidth: true

                hasButton: true
                label: i18n.tr('Depart:')
                placeHolder: i18n.tr('Select date...')
                text: searchParams.departDate
                    ? searchParams.departDate.toLocaleDateString()
                    : ''
                required: true
                btnIcon: 'reset'
                onClicked: {
                    departPicker.open()
                    if (searchParams.departDate) {
                        departPicker.date = searchParams.departDate
                    }
                }
                onBtnClicked: searchParams.departDate = new Date(Date.now() + 24 * 60 * 60 * 1000) // tomorrow
            }

            Components.FakeTextField {
                Layout.fillWidth: true

                hasButton: true
                label: i18n.tr('Return:')
                placeHolder: i18n.tr('Select date...')
                text: searchParams.returnDate
                    ? searchParams.returnDate.toLocaleDateString()
                    : ''
                onClicked: {
                    returnPicker.open()
                    returnPicker.date = searchParams.returnDate || searchParams.departDate
                }
                onBtnClicked: searchParams.returnDate = undefined
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 0

                Label {
                    Layout.fillWidth: true
                    text: i18n.tr('Adults (12+):')
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                }
                TextField {
                    Layout.fillWidth: true
                    text: searchParams.adultsNumber || ''
                    inputMethodHints: Qt.ImhDigitsOnly
                    placeholderText: '0'
                    onTextChanged: {
                        if (isNaN(text)) {
                            return
                        }

                        searchParams.adultsNumber = parseInt(text) || 0
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: itemSpacing

                Column {
                    Layout.fillWidth: true
                    Layout.preferredWidth: parent.parent.width / 2

                    Label {
                        width: parent.width
                        text: i18n.tr('Children (2-12):')
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    }
                    TextField {
                        width: parent.width
                        text: searchParams.childrenNumber || ''
                        inputMethodHints: Qt.ImhDigitsOnly
                        placeholderText: '0'
                        onTextChanged: {
                            if (isNaN(text)) {
                                return
                            }

                            searchParams.childrenNumber = parseInt(text) || 0
                        }
                    }
                }

                Column {
                    Layout.fillWidth: true
                    Layout.preferredWidth: parent.parent.width / 2

                    Label {
                        width: parent.width
                        text: i18n.tr('Infants (under 2):')
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    }
                    TextField {
                        width: parent.width
                        text: searchParams.infantsNumber || ''
                        inputMethodHints: Qt.ImhDigitsOnly
                        placeholderText: '0'
                        onTextChanged: {
                            if (isNaN(text)) {
                                return
                            }

                            searchParams.infantsNumber = parseInt(text) || 0
                        }
                    }
                }
            }

            UITK.Button {
                color: theme.palette.normal.positive
                Layout.fillWidth: true
                Layout.topMargin: itemSpacing * 2
                Layout.bottomMargin: itemSpacing
                text: i18n.tr('Search flights')
                enabled: searchParams.fromIata && searchParams.toIata &&
                         searchParams.departDate &&
                         (searchParams.adultsNumber || searchParams.childrenNumber || searchParams.infantsNumber)
                onClicked: {
                    headerText.text = searchParams.fromCity + ' - ' + searchParams.toCity
                    var url = QmlJs.getSearchUrl({
                        baseUrl: whiteLabelUrl,
                        from: searchParams.fromIata,
                        to: searchParams.toIata,
                        departDate: searchParams.departDate,
                        returnDate: searchParams.returnDate,
                        adults: searchParams.adultsNumber,
                        children: searchParams.childrenNumber,
                        infants: searchParams.infantsNumber,
                        currency: searchParams.currency,
                        lang: root.lang
                    })
                    pageStack.push('./WebView.qml', {
                        baseUrl: whiteLabelUrl,
                        url: url,
                        itemSpacing: itemSpacing
                    })
                }
            }
        }

        Components.DatePicker {
            id: departPicker
            x: (root.width - width) / 2
            y: (root.height - height) / 2 - header.height
            onAccepted: {
                searchParams.departDate = date
            }
        }

        Components.DatePicker {
            id: returnPicker
            x: (root.width - width) / 2
            y: (root.height - height) / 2 - header.height
            onAccepted: {
                searchParams.returnDate = date
            }
        }
    }
}
