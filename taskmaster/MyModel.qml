import QtQuick 2.0
import QtQuick.LocalStorage 2.0
import "Database.js" as JS

ListModel {
    id: listModel
    Component.onCompleted: JS.dbReadAll()
}
