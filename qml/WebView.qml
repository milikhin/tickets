import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Suru 2.2
import QtQuick.Layouts 1.3
import Morph.Web 0.1
import QtWebEngine 1.1

Item {
    property string baseUrl
    property alias url: webView.url
    property int itemSpacing: 0
    property alias loading: webView.loading

    WebView {
        id: webView
        visible: loading || (webView.title && webView.title !== baseUrl)
        anchors.fill: parent
        zoomFactor: Suru.units.gu(1) / 8
        onTitleChanged: {
            // webView.title === baseUrl => true -- page loading failed
            // direct binding doesn't work for some reason
            errorMsg.visible = !webView.loading && (webView.title === baseUrl || !webView.title)
        }
        onLoadingChanged: {
            errorMsg.visible = !webView.loading && (webView.title === baseUrl || !webView.title)
        }

        onNavigationRequested: function(request) {
            const urlStr = request.url.toString()
            console.log('Navigation requested', urlStr)
            const isWhilteLabelRequested = urlStr.indexOf('https://' + baseUrl) === 0
            if (isWhilteLabelRequested) {
                return
            }

            Qt.openUrlExternally(request.url)
        }

        onNewViewRequested: function(request) {
            var url = request.requestedUrl.toString()
            console.log('New tab requested', url)
            Qt.openUrlExternally(url)
        }

    }

    Label {
        id: errorMsg
        visible: false

        anchors {
            left: parent.left
            right: parent.right
            verticalCenter: parent.verticalCenter
            leftMargin: itemSpacing
            rightMargin: itemSpacing
        }

        horizontalAlignment: Qt.AlignHCenter
        text: qsTr('Unable to load search results. Please check you network connection')
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
    }
}


