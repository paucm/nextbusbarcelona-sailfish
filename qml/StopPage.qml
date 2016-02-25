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

import "TmbService.js" as Tmb
import "Database.js" as Database


Page {
    id: stopPage
    property string busStopCode
    property string busStopTitle: ''
    property bool loading: false
    property bool canCover: true
    property real lastCheck: -1

    function populate() {
        busStopView.model.clear();
        Tmb.getBusStopTime(busStopCode,
            function(data) {
                if (!Tmb.validateBusStop(data)) {
                    busy.error = qsTr("Invalid stop code");
                    refreshMenu.enabled = false;
                }
                else {
                    var res = Tmb.parseStopTime(data);
                    if (res.length === 0)
                        busy.error = qsTr("No lines found");
                    else
                        res.forEach(function(r) { busStopView.model.append(r); });
                    busStopTitle = Tmb.parseStopName(data)
                }
                loading = false;
                app.cover.update();
            },
            function(status, statusText) {
                pageStack.pop()
                busy.error = qsTr("Error %1: %2").arg(status).arg(statusText);
                loading = false;
                app.cover.update();
            });
        loading = true;
        lastCheck = Date.now();
    }

    function update() {
        if ((Date.now() - lastCheck) > 30000) {
            populate();
        }
    }

    function save() {
        Database.storeStop(busStopCode, busStopTitle);
    }

    function getModel() {
        return busStopView.model;
    }

    SilicaFlickable {
        anchors.fill: parent

        VerticalScrollDecorator {}

        RemorsePopup { id: remorse }

        PullDownMenu {

            MenuItem {
                id: saveStopMenu
                text: qsTr("Favourite")
                onClicked: remorse.execute(qsTr("Marking Bus Stop as favourite"), save)
            }
            MenuItem {
                id: refreshMenu
                text: qsTr("Refresh")
                onClicked: populate()
            }
        }

        contentHeight: parent.height

        BusyModal {
            id: busy
            running: loading
        }

        SilicaListView {
            id: busStopView
            anchors.fill: parent
            currentIndex: -1
            model: ListModel {}

            header: PageHeader {
                title: busStopTitle
            }

            delegate: ListItem {
                Label {
                    id: lineLabel
                    anchors.left: parent.left
                    anchors.leftMargin: Theme.paddingLarge
                    text: bus
                    font.pixelSize: Theme.fontSizeLarge
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignVCenter
                }
                Label {
                    id: timeLabel
                    anchors.right: parent.right
                    anchors.rightMargin: Theme.paddingLarge
                    anchors.baseline: lineLabel.baseline
                    text: time ? qsTr("%n min(s)", "", time) : qsTr('imminent')
                    horizontalAlignment: Text.AlignRight
                }
            }
        }
    }

    Component.onCompleted: {
        update()
    }
}
