import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.5

Window {
    visible: true
    width: 360
    height: 720
    title: qsTr("Taskmaster")

    StackView{
        id: contentFrame
        anchors.fill: parent
        initialItem: Qt.resolvedUrl("qrc:/loadPage.qml")
    }

    Component.onCompleted:{
        contentFrame.replace("qrc:/mainPage.qml")
    }
}
