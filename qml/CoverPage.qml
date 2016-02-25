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

CoverBackground {
    id: cover

    Image {
        id: image
        anchors.centerIn: parent
        height: sourceSize.height * width / sourceSize.width
        opacity: 0.1
        source: "icons/cover.png"
        width: parent.width
    }

    Label {
        id: title
        anchors.centerIn: parent
        text: qsTr("Next Bus\nBarcelona")
    }

    CoverActionList {
        id: coverAction

        CoverAction {
            iconSource: "image://theme/icon-cover-sync"
            onTriggered: app.pageStack.currentPage.update()
        }
    }

    SilicaListView {
        id: coverView
        //anchors.centerIn: parent
        width: parent.width
        height: parent.height
        model: ListModel {}

        delegate: ListItem {
            Label {
                id: lineCoverLabel
                anchors.left: parent.left
                anchors.leftMargin: Theme.paddingSmall
                text: bus
                font.pixelSize: Theme.fontSizeLarge
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
            }
            Label {
                anchors.right: parent.right
                anchors.rightMargin: Theme.paddingSmall
                anchors.baseline: lineCoverLabel.baseline
                text: time ? qsTr("%n min(s)", "", time) : qsTr('imminent')
                horizontalAlignment: Text.AlignRight
            }
        }
    }

    function update() {
        coverView.model.clear();
        var page = app.pageStack.currentPage;
        if (page && page.canCover) {
            title.visible = false;
            coverAction.enabled = true;
            //refreshCoverAction.visible = true
            var model = page.getModel();
            var max_count = Math.min(model.count, 4);
            for (var i = 0; i < max_count; i++) {
                coverView.model.append(model.get(i));
            }
        }
        else {
            title.visible = true;
            coverAction.enabled = false;
        }
    }
}
