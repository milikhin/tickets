import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Suru 2.2
import QtQuick.Layouts 1.3

ColumnLayout {
    property string currency
    readonly property int itemSpacing: 8
    readonly property var currencies: ['EUR', 'USD', 'RUB']

    spacing: 0

    Label {
        Layout.fillWidth: true
        Layout.topMargin: itemSpacing
        Layout.leftMargin: itemSpacing
        Layout.rightMargin: itemSpacing
        text: i18n.tr('Currency:')
    }

    ComboBox {
        Layout.fillWidth: true
        Layout.leftMargin: itemSpacing
        Layout.rightMargin: itemSpacing
        model: currencies
        Component.onCompleted: {
            currentIndex = currencies.indexOf(currency)
            currentIndexChanged.connect(function() {
                currency = currencies[currentIndex]
            })
        }
    }

    Item {
        Layout.fillHeight: true
    }
}
