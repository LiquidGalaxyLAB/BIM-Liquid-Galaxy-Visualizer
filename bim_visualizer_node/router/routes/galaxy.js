const express = require('express');
const router = express.Router();
const path = require('path');
const { WebSocketServer } = require("ws");
const wss = new WebSocketServer({ port: 3220 });

const clients = [];

router.use(express.static(__basedir + '/public'));

router.use('/:screen/Build/client.framework.js.gz', (req, res) => {
    res.contentType('application/x-javascript');
    res.setHeader('Content-Encoding', 'gzip');
    res.sendFile(path.join(__basedir, '/public/client/Build/client.framework.js.gz'));
});

router.use('/:screen/Build/client.data.gz', (req, res) => {
    res.contentType('application/x-javascript');
    res.setHeader('Content-Encoding', 'gzip');
    res.sendFile(path.join(__basedir, '/public/client/Build/client.data.gz'));
});

router.use('/:screen/Build/client.wasm.gz', (req, res) => {
    res.contentType('application/wasm');
    res.setHeader('Content-Encoding', 'gzip');
    res.sendFile(path.join(__basedir, '/public/client/Build/client.wasm.gz'));
});

router.route('/:screen').get((req, res, next) => {
    let byteArr = [];
    const buffer = Buffer.from(req.params.screen, "utf16le");
    for (var i = 0; i < buffer.length; i++) {
        byteArr.push(buffer[i]);
    }
    clients.push(byteArr);
    next();
});
router.use('/:screen', express.static(__basedir + '/public/client'));

wss.on("connection", (ws) => {
    console.log("a user connected");

    const encodedClientId = clients.shift();
    ws.send(encodedClientId);

    ws.on("close", () => {
        console.log("client left");
    });
});

module.exports = router;