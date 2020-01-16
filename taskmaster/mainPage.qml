import QtQuick 2.0
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtQuick.LocalStorage 2.12
import "Database.js" as JS
import "Storage.js" as Storage

Item {
    width: 360
    height: 720
    anchors.fill: parent

    property bool creatingNewEntry: false
    property bool editingEntry: false

    property int taskCreatedVar: Storage.get("taskCreatedVarST", 0)
    property int taskDeletedVar: Storage.get("taskDeletedVarST", 0)
    property int taskEditVar: Storage.get("taskEditVarST", 0)

    Component.onCompleted: {
        JS.dbInit()
    }

    Rectangle {
        id: recBackground
        anchors.fill: parent
        color: "#18bc9c"
    }

    SwipeView {
        id: swipeView
        currentIndex: 2
        anchors.fill: parent

        onCurrentIndexChanged: {
            if(swipeView.currentIndex == 0){
                image.opacity = 1
                image1.opacity = 0.3
                image2.opacity = 0.3
            }else if(swipeView.currentIndex == 1){
                image.opacity = 0.3
                image1.opacity = 1
                image2.opacity = 0.3
            }else if(swipeView.currentIndex == 2){
                image.opacity = 0.3
                image1.opacity = 0.3
                image2.opacity = 1
            }
        }

        Item {
            id: staticsPage
            width: 360
            height: 720

            Label{
                anchors.horizontalCenter: parent.horizontalCenter
                y: 100
                text: "Created Tasks:"
                font.pointSize: 20
            }

            Label {
                id: labelCreatedTaskCount
                anchors.horizontalCenter: parent.horizontalCenter
                y: 150
                text: taskCreatedVar
                font.bold: true
                font.pointSize: 15
            }

            Label {
                y: 200
                text: "Deleted Tasks:"
                anchors.horizontalCenter: parent.horizontalCenter
                font.pointSize: 20
            }

            Label {
                id: labelDeletedTaskCount
                y: 250
                text: taskDeletedVar
                anchors.horizontalCenter: parent.horizontalCenter
                font.pointSize: 15
                font.bold: true
            }

            Label {
                y: 30
                text: "Oberview"
                anchors.horizontalCenter: parent.horizontalCenter
                font.pointSize: 25
            }

            Label {
                y: 300
                text: "Edited Tasks:"
                anchors.horizontalCenter: parent.horizontalCenter
                font.pointSize: 20
            }

            Label {
                id: labelEditTaskCount
                y: 350
                text: taskEditVar
                anchors.horizontalCenter: parent.horizontalCenter
                font.pointSize: 15
                font.bold: true
            }

            Label {
                id: label
                anchors.horizontalCenter: parent.horizontalCenter
                y: 430
                width: 230
                height: 130
                text: qsTr("This Overview is just for looking at the flow of Data they serve no real porpose")
                wrapMode: Text.WordWrap
                font.pointSize: 10
            }
        }

        Item {
            id: toDoPage
            width: 360
            height: 720


            ListView {
                id: listView
                anchors.fill: parent
                model: MyModel {}
                delegate: MyDelegate {}
                // Don't allow changing the currentIndex while the user is creating/editing values.
                enabled: !creatingNewEntry && !editingEntry

                highlight: highlightBar
                highlightFollowsCurrentItem: true
                focus: true

                header: Component {
                    Text {
                        x: swipeView.width/2-50
                        text: "Saved Tasks"
                        font.pointSize: 15
                    }
                }
            }

            RoundButton {
                id: newButton
                anchors.horizontalCenter: parent.horizontalCenter
                y: parent.height-130
                width: 50
                height: 50
                text: "+"
                font.pointSize: 15
                antialiasing: true
                onClicked: {
                    rectangle.visible = true
                    labelES.text = "New"
                    input.initrec_new()
                    creatingNewEntry = true
                    listView.model.setProperty(listView.currentIndex, "id", 0)
                    taskCreatedVar++
                    Storage.set("taskCreatedVarST", taskCreatedVar)
                }
            }

            Rectangle{
                id: rectangle
                anchors.centerIn: parent
                width: parent.width-10
                height: 400
                radius: 10
                visible: false

                Header {
                    id: input
                    width: parent.width
                    height: 200
                    anchors.centerIn: parent
                }

                RowLayout{
                    anchors.bottom: parent.bottom
                    width: parent.width
                    height: 50

                    MouseArea{
                        id: saveButton
                        enabled: creatingNewEntry || editingEntry && listView.currentIndex != -1
                        anchors.left: parent.left
                        height: parent.height
                        width: parent.width/3
                        onClicked: {
                            rectangle.visible = false
                            var insertedRow = false;
                            if (listView.model.get(listView.currentIndex).id < 1) {
                                //insert mode
                                if (input.insertrec()) {
                                    // Successfully inserted a row.
                                    input.setlistview()
                                    insertedRow = true
                                } else {
                                    // Failed to insert a row; display an error message.
                                    statustext.text = "Failed to insert row"
                                }
                            } else {
                                // edit mode
                                input.setlistview()
                                JS.dbUpdate(listView.model.get(listView.currentIndex).date,
                                            listView.model.get(listView.currentIndex).trip_desc,
                                            listView.model.get(listView.currentIndex).distance,
                                            listView.model.get(listView.currentIndex).id)
                                creatingNewEntry = false
                                editingEntry = false
                            }

                            if (insertedRow) {
                                input.initrec()
                                creatingNewEntry = false
                                editingEntry = false
                                listView.forceLayout()
                            }
                        }

                        Image{
                            anchors.centerIn: parent
                            width: 40
                            height: 40
                            source: "qrc:/icons8-häkchen-32.png"
                        }
                    }
                    MouseArea{
                        id: deleteButton
                        enabled: !creatingNewEntry && listView.currentIndex != -1
                        height: parent.height
                        width: parent.width/3
                        anchors.horizontalCenter: parent.horizontalCenter
                        onClicked: {
                            rectangle.visible = false
                            JS.dbDeleteRow(listView.model.get(listView.currentIndex).id)
                            listView.model.remove(listView.currentIndex, 1)
                            if (listView.count == 0) {
                                // ListView doesn't automatically set its currentIndex to -1
                                // when the count becomes 0.
                                listView.currentIndex = -1
                            }
                            editingEntry = false
                            creatingNewEntry = false
                            taskDeletedVar++
                            Storage.set("taskDeletedVarST", taskDeletedVar)
                        }

                        Image{
                            anchors.centerIn: parent
                            width: 40
                            height: 40
                            source: "qrc:/icons8-löschen-32.png"
                        }
                    }
                    MouseArea{
                        id: cancelButton
                        enabled: (creatingNewEntry || editingEntry) && listView.currentIndex != -1
                        height: parent.height
                        width: parent.width/3
                        anchors.right: parent.right
                        onClicked: {
                            rectangle.visible = false
                            if (listView.model.get(listView.currentIndex).id === 0) {
                                // This entry had an id of 0, which means it was being created and hadn't
                                // been saved to the database yet, so we can safely remove it from the model.
                                listView.model.remove(listView.currentIndex, 1)
                            }
                            listView.forceLayout()
                            creatingNewEntry = false
                            editingEntry = false
                            input.initrec()
                        }

                        Image{
                            anchors.centerIn: parent
                            width: 40
                            height: 40
                            source: "qrc:/icons8-löschen-32 (1).png"
                        }
                    }
                }

                Label {
                    id: labelES
                    anchors.horizontalCenter: parent.horizontalCenter
                    y: 8
                    text: qsTr("Edit")
                    font.pointSize: 25
                }
            }
        }

        Item {
            id: doneTaskPage
            width: 360
            height: 720

            Label {
                id: label1
                anchors.horizontalCenter: parent.horizontalCenter
                y: 30
                text: qsTr("Credit:")
                font.pointSize: 25
            }

            Rectangle {
                id: rectangle2
                anchors.horizontalCenter: parent.horizontalCenter
                y: 149
                width: 204
                height: 204
                color: "#15997f"
                radius: 99
                antialiasing: true
            }

            Rectangle {
                id: rectangle1
                anchors.horizontalCenter: parent.horizontalCenter
                y: 150
                width: 200
                height: 200
                color: "#18bc9c"
                radius: 99
                antialiasing: true

                Image {
                    id: image3
                    anchors.centerIn: parent
                    width: 140
                    height: 140
                    fillMode: Image.PreserveAspectFit
                    source: "qrc:/Square150x150Logo.png"
                }
            }

            Label {
                id: label2
                anchors.horizontalCenter: parent.horizontalCenter
                y: 360
                text: qsTr("Made/Coded by")
                font.pointSize: 15
            }

            Label {
                id: label3
                anchors.horizontalCenter: parent.horizontalCenter
                y: 405
                color: "#fdfdfd"
                text: qsTr("Ben Coepp")
                font.bold: true
                font.pointSize: 20
            }

            Label {
                id: label4
                anchors.horizontalCenter: parent.horizontalCenter
                y: 470
                width: 250
                height: 150
                text: qsTr("The App was created with the Local Storage Example of Qt, the Bacend JS Script was nearly compleatly used. This is an Example of how a SQL-Database can be used in QT, it shows how I would implement such a Link.")
                font.pointSize: 15
                wrapMode: Text.WordWrap
            }

        }
    }


    Rectangle {
        id: rectangleBar
        y: 620
        anchors.bottom: parent.bottom
        antialiasing: true
        width: parent.width
        height: 100
        color: "#2c3e50"
        radius: 25
        anchors.bottomMargin: -30

        MouseArea {
            id: mouseAreaStaticsticB
            anchors.left: parent.left
            width: parent.width/3
            height: 70
            onClicked: {
                swipeView.setCurrentIndex(0)
                image.opacity = 1
                image1.opacity = 0.3
                image2.opacity = 0.3
            }

            Image {
                id: image
                width: 40
                height: 40
                opacity: 0.3
                anchors.centerIn: parent
                source: "qrc:/icons8-lesezeichen-32.png"
                fillMode: Image.PreserveAspectFit
            }
        }

        MouseArea {
            id: mouseAreaTask
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width/3
            height: 70
            onClicked: {
                swipeView.setCurrentIndex(1)
                image.opacity = 0.3
                image1.opacity = 1
                image2.opacity = 0.3
            }

            Image {
                id: image1
                width: 40
                height: 40
                anchors.centerIn: parent
                source: "qrc:/icons8-kalender-32.png"
                fillMode: Image.PreserveAspectFit
            }
        }

        MouseArea {
            id: mouseAreaDone
            anchors.right: parent.right
            width: parent.width/3
            height: 70
            onClicked: {
                swipeView.setCurrentIndex(2)
                image.opacity = 0.3
                image1.opacity = 0.3
                image2.opacity = 1
            }

            Image {
                id: image2
                width: 40
                height: 40
                opacity: 0.3
                anchors.centerIn: parent
                source: "qrc:/icons8-ok-32.png"
                fillMode: Image.PreserveAspectFit
            }
        }
    }
}


