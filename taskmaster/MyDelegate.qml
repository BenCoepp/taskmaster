import QtQuick 2.0
import QtQuick.LocalStorage 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.5
import "Database.js" as JS
import "Storage.js" as Storage

Item {
    width: parent.width
    height: 100

    property bool creatingNewEntry1: creatingNewEntry
    property bool editingEntry1: editingEntry

    Rectangle {
        id: baseRec
        anchors.fill: parent
        radius: 10
        opacity: 1
        color: "tomato"
        anchors.topMargin: 5
        anchors.rightMargin: 5
        anchors.leftMargin: 5
        antialiasing: true

        MouseArea{
            anchors.fill: parent
            onClicked: {
                baseRec.opacity = 0.9
            }
        }

        Text {
            id: rDate
            anchors.left: parent.left
            y: 10
            width: 105
            height: 35
            text: date
            anchors.leftMargin: 8
            font.pixelSize: 22
            Layout.preferredWidth: parent.width / 4
            color: "black"
        }

        Text {
            id: rDesc
            x: 119
            y: 8
            width: 180
            height: 79
            text: trip_desc
            wrapMode: Text.WrapAnywhere
            Layout.fillWidth: true
            font.pixelSize: 22
            color: "black"
        }

        Text {
            id: rDistance
            anchors.left: parent.left
            anchors.leftMargin: 8
            y: 50
            width: 105
            height: 37
            text: distance
            wrapMode: Text.WordWrap
            font.pixelSize: 22
            Layout.alignment: Qt.AlignRight
            color: "black"
        }



        RoundButton{
            id: editButton
            x: 305
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            width: 40
            height: 40
            anchors.rightMargin: 8
            enabled: !creatingNewEntry && !editingEntry && listView.currentIndex != -1
            Image {
                width: 15
                height: 15
                anchors.centerIn: parent
                source: "qrc:/icons8-support-32.png"
            }
            onClicked: {
                listView.currentIndex = index
                rectangle.visible = true
                labelES.text = "Edit"
                input.editrec(listView.model.get(listView.currentIndex).date,
                              listView.model.get(listView.currentIndex).trip_desc,
                              listView.model.get(listView.currentIndex).distance,
                              listView.model.get(listView.currentIndex).id)
                editingEntry = true
                taskEditVar++
                Storage.set("taskEditVarST", taskEditVar)
            }
        }

    }
}
