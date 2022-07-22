const express = require('express');
const router = express.Router();
const path = require('path');
const { WebSocketServer } = require("ws");
const wss = new WebSocketServer({ port: 3220 });
const { ByteArray } = require('../../utils/byteArray');
const { FindMaxFrames } = require('../../utils/findMaxFrames');

router.use('/Build/client.framework.js.gz', (req, res) => {
    res.contentType('application/x-javascript');
    res.setHeader('Content-Encoding', 'gzip');
    res.sendFile(path.join(__basedir, '/public/client/Build/client.framework.js.gz'));
});

router.use('/Build/client.data.gz', (req, res) => {
    res.contentType('application/x-javascript');
    res.setHeader('Content-Encoding', 'gzip');
    res.sendFile(path.join(__basedir, '/public/client/Build/client.data.gz'));
});

router.use('/Build/client.wasm.gz', (req, res) => {
    res.contentType('application/wasm');
    res.setHeader('Content-Encoding', 'gzip');
    res.sendFile(path.join(__basedir, '/public/client/Build/client.wasm.gz'));
});
router.use('/', express.static(__basedir + '/public/client'));

wss.on('connection', async (ws, req) => {
    console.log("a user connected");

    const maxFrames = await FindMaxFrames();
    const maxFramesWithOffset = parseInt(maxFrames) + 10;
    const encodedMaxFrames = ByteArray(maxFramesWithOffset.toString());
    ws.send(encodedMaxFrames);

    ws.on('close', () => {
        console.log("client left");
    });
});

module.exports = router;