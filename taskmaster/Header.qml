import QtQuick 2.7
import QtQuick.Window 2.0
import QtQuick.Controls 2.5
import QtQuick.LocalStorage 2.0
import "Database.js" as JS
import QtQuick.Layouts 1.1

Item {
    id: root
    width: 340
    height: 150

    function insertrec() {
        var rowid = parseInt(JS.dbInsert(dateInput.text, descInput.text, distInput.text), 10)
        if (rowid) {
            listView.model.setProperty(listView.currentIndex, "id", rowid)
            listView.forceLayout()
        }
        return rowid;
    }

    function editrec(Pdate, Pdesc, Pdistance, Prowid) {
        dateInput.text = Pdate
        descInput.text = Pdesc
        distInput.text = Pdistance
    }

    function initrec_new() {
        dateInput.clear()
        descInput.clear()
        distInput.clear()
        listView.model.insert(0, {
                                  date: "",
                                  trip_desc: "",
                                  distance: ""
                              })
        listView.currentIndex = 0
        dateInput.forceActiveFocus()
    }

    function initrec() {
        dateInput.clear()
        descInput.clear()
        distInput.clear()
    }

    function setlistview() {
        listView.model.setProperty(listView.currentIndex, "date",
                                   dateInput.text)
        listView.model.setProperty(listView.currentIndex, "trip_desc",
                                   descInput.text)
        listView.model.setProperty(listView.currentIndex, "distance",
                                   distInput.text)
    }

    Rectangle {
        id: rootrect
        border.width: 10
        color: "#161616"

        ColumnLayout {
            id: mainLayout
            anchors.fill: parent

            Rectangle {
                id: gridBox
                Layout.fillWidth: true

                GridLayout {
                    id: gridLayout
                    rows: 3
                    flow: GridLayout.TopToBottom
                    anchors.fill: parent

                    Text {
                        text: "Date:"
                        font.pixelSize: 22
                        rightPadding: 10
                    }

                    Text {
                        text: "Description:"
                        font.pixelSize: 22
                        rightPadding: 10
                    }

                    Text {
                        text: "Distance:"
                        font.pixelSize: 22
                    }

                    TextField{
                        id: dateInput
                        placeholderText: "Date"
                        width: 200
                        height: 40
                    }

                    TextField{
                        id: descInput
                        placeholderText: "Desciption"
                        width: 200
                        height: 40
                    }

                    TextField{
                        id: distInput
                        placeholderText: "Distance"
                        width: 200
                        height: 40
                    }
                }
            }
        }
    }
}
