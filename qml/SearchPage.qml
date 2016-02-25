/*
 * Copyright (C) 2016 Pau Capella
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.0
import Sailfish.Silica 1.0

import "Database.js" as Database

Page {
    id: searchPage
    property bool canCover: false

    function update() {
        app.cover.update();
        var stops = Database.getStops();
        stopsView.model.clear();
        stops.forEach(function(s) { stopsView.model.append(s); });
    }

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: parent.height

        VerticalScrollDecorator {}

        SilicaListView {
            id: stopsView
            anchors.fill: parent
            currentIndex: -1
            width: parent.width
            model: ListModel {}

            header: Column {
                id: headerContainer
                width: parent.width

                PageHeader {
                    title: qsTr("Enter bus stop code")
                }

                SearchField {
                    id: searchField
                    inputMethodHints: Qt.ImhDigitsOnly
                    width: parent.width
                    //placeholderText: qsTr("")

                    EnterKey.onClicked: {
                        pageStack.push(Qt.resolvedUrl("StopPage.qml"),
                       {'busStopCode': searchField.text})
                    }
                }
                SectionHeader {
                    text: qsTr("Favorite Stops")
                    visible: stopsView.model.count > 0
                }
            }

            delegate: ListItem {
                id: listItem
                contentHeight: Theme.itemSizeSmall
                menu: contextMenu

                anchors.leftMargin: Theme.paddingLarge
                anchors.left: parent.left

                Label {
                    id: nameLabel
                    text: name
                    anchors.topMargin: Theme.paddingMedium
                }
                Label {
                    text: qsTr("Bus stop code %1").arg(code)
                    color: Theme.secondaryColor
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: Theme.paddingMedium
                    font.pixelSize: Theme.fontSizeExtraSmall
                }

                RemorseItem { id: remorse }

                ContextMenu {
                    id: contextMenu

                    MenuItem {
                        text: qsTr("Delete Bus Stop")
                        onClicked: {
                            remorse.execute(listItem, qsTr("Deleting Bus Stop"), function() {
                                var code = stopsView.model.get(index).code;
                                stopsView.model.remove(index);
                                Database.deleteStop(code);
                            })
                        }
                    }
                }
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("StopPage.qml"),
                                   {'busStopCode': code, 'busStopTitle': name})
                }
                onPressAndHold: listItem.showMenu()
            }
        }
    }

    onStatusChanged: {
        if (status === PageStatus.Active) {
            update();
        }
    }
}
