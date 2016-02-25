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

var GET_BUS_STOP_TIME = 'http://www.tmb.cat/piu/ca_ES/piuimodesolucio.jsp?parada='

function sendRequest(url, onSuccess, onFailure) {
    var httpReq = new XMLHttpRequest();
    console.log('Fetching ' + url);
    httpReq.open("GET", url, true);
    httpReq.onreadystatechange = function() {
        if (httpReq.readyState == XMLHttpRequest.DONE) {
            if (httpReq.status == 200) {
                onSuccess(httpReq.responseText);
            }
            else onFailure(httpReq.status, httpReq.statusText);
        }
    }
    httpReq.send();
}

function getBusStopTime(busStopId, onSuccess, onFailure) {
    var url = GET_BUS_STOP_TIME + busStopId
    sendRequest(url, onSuccess, onFailure)
}

function parseStopTime(data) {
    var re = /<td align="center">(\w?\d+)<\/td><td align="center">(\d+|Imminent)(?:\s*min)?<\/td>/g;
    var m;
    var results = [];
    while ((m = re.exec(data)) !== null) {
        if (m.index === re.lastIndex) {
            re.lastIndex++;
        }
        if (m[2] === 'Imminent') m[2] = '0'
        results.push({bus: m[1], time: parseInt(m[2])});
    }
    return results.sort(function(a, b) { return a.time - b.time; })
}

function parseStopName(data) {
    var re = /<p align="center">\s*\w?\d+\s+-\s+(.*)\s+<\/p>/g;
    var m;
    var name = ''
    while ((m = re.exec(data)) !== null) {
        if (m.index === re.lastIndex) {
            re.lastIndex++;
        }
        name = m[1]
    }
    return name
}

function validateBusStop(data) {
    var pos = data.search('No existeix el codi de parada');
    return pos === -1 ? true : false; 
}
