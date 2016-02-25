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

.pragma library
.import QtQuick.LocalStorage 2.0 as Sql



var db = Sql.LocalStorage.openDatabaseSync("NextBusBarcelona", "0.1", "Next Bus Barcelona Database", 100000, function(db) {
    db.transaction(function(tx) {
        tx.executeSql("CREATE TABLE IF NOT EXISTS Stops(code INTEGER UNIQUE, name TEXT)");
    });
    db.changeVersion("", "0.1");
});

function getStops() {
    var stops = []
    db.readTransaction(function(tx) {
        var rs = tx.executeSql("SELECT code, name FROM Stops");
        for (var i=0; i < rs.rows.length; i++) {
            stops.push({code: rs.rows.item(i).code, name: rs.rows.item(i).name});
        } 
    });
    return stops
}

function storeStop(code, name) {
    db.transaction(function(tx) {
        tx.executeSql("INSERT OR REPLACE INTO Stops VALUES (?, ?)", [code, name]);
    });
}

function deleteStop(code) {
    db.transaction(function(tx) {
        tx.executeSql("DELETE FROM Stops WHERE code = ?", [code]);
    });
}
