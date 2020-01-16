import QtQuick 2.0
import QtQuick.Controls 2.5

Item {
    anchors.fill: parent
    width: 360
    height: 720

    Rectangle{
        id: background
        anchors.fill: parent
        color: "#2c3e50"

        BusyIndicator {
            id: busyIndicator
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenterOffset: 250
            anchors.verticalCenter: parent.verticalCenter
        }

        Label {
            id: label
            anchors.horizontalCenter: parent.horizontalCenter
            y: 484
            color: "#fdfdfd"
            text: qsTr("Ben Coepp")
            font.family: "Verdana"
            font.bold: true
            font.pointSize: 25
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }
    }

    Rectangle{
        anchors.centerIn: parent
        color: "#18bc9c"
        radius: 99
        width: 200
        height: 200

        Image {
            id: image
            x: 50
            y: 50
            width: 100
            height: 100
            source: "qrc:/Square150x150Logo.png"
            fillMode: Image.PreserveAspectFit
        }
    }
}
