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

    ColumnLayout {
        anchors.fill: parent
        visible: loading || webView.title !== baseUrl

        ProgressBar {
            Layout.fillWidth: true
            indeterminate: true
            visible: webView.loading
        }

        WebView {
            id: webView
            Layout.fillWidth: true
            Layout.fillHeight: true
            zoomFactor: Suru.units.gu(1) / 8
            onLoadProgressChanged: {
                console.log('load progress', loadProgress)
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
    }

    Label {
        // webView.title === baseUrl => true when page loading failed
        visible: !webView.loading && webView.title === baseUrl
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


