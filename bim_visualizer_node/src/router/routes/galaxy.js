const express = require('express');
const router = express.Router();
const path = require('path');
const { WebSocketServer } = require("ws");
const wss = new WebSocketServer({ port: 3220 });
const { ByteArray } = require('../../utils/byteArray');
const { FindMaxFrames } = require('../../utils/findMaxFrames');
const maxFrames = ( async () => { await FindMaxFrames() } )();

const clients = [];

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
    const byteArr = ByteArray(req.params.screen);
    clients.push(byteArr);
    next();
});
router.use('/:screen', express.static(__basedir + '/public/client'));

wss.on("connection", (ws) => {
    console.log("a user connected");

    const encodedClientId = clients.shift();
    ws.send(encodedClientId);

    const maxFramesWithOffset = maxFrames + 10;
    const encodedMaxFrames = ByteArray(maxFramesWithOffset);
    ws.send(encodedMaxFrames);

    ws.on("close", () => {
        console.log("client left");
    });
});

module.exports = router;