const express = require('express');
const path = require('path');
const app = express();
const { WebSocketServer } = require("ws");
const wss = new WebSocketServer({ port: 3220 });

const clients = [];

app.use(express.static(__dirname + '/public'));

app.use('/:screen/Build/client.framework.js.gz', (req, res, next) => {
    res.contentType('application/x-javascript');
    res.setHeader('Content-Encoding', 'gzip');
    res.sendFile(path.join(__dirname, '/public/client/Build/client.framework.js.gz'));
});

app.use('/:screen/Build/client.data.gz', (req, res, next) => {
    res.contentType('application/x-javascript');
    res.setHeader('Content-Encoding', 'gzip');
    res.sendFile(path.join(__dirname, '/public/client/Build/client.data.gz'));
});

app.use('/:screen/Build/client.wasm.gz', (req, res, next) => {
    res.contentType('application/wasm');
    res.setHeader('Content-Encoding', 'gzip');
    res.sendFile(path.join(__dirname, '/public/client/Build/client.wasm.gz'));
});

app.get('/:screen', (req, res, next) => {
    let byteArr = [];
    const buffer = Buffer.from(req.params.screen, "utf16le");
    for (var i = 0; i < buffer.length; i++) {
        byteArr.push(buffer[i]);
    }
    clients.push(byteArr);
    next();
});
app.use('/:screen', express.static(__dirname + '/public/client'));

wss.on("connection", (ws) => {
    console.log("a user connected");

    const encodedClientId = clients.shift();
    ws.send(encodedClientId);

    ws.on("close", () => {
        console.log("client left");
    });
});

module.exports = app;