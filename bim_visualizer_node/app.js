const express = require('express');
const path = require('path');
const app = express();

app.use(express.static(__dirname + '/public'))

app.use("/:screen/Build/client.framework.js.gz", (req, res, next) => {
    res.contentType("application/x-javascript");
    res.setHeader("Content-Encoding", "gzip");
    res.sendFile(path.join(__dirname, "/public/client/Build/client.framework.js.gz"));
});

app.use("/:screen/Build/client.data.gz", (req, res, next) => {
    res.contentType("application/x-javascript");
    res.setHeader("Content-Encoding", "gzip");
    res.sendFile(path.join(__dirname, "/public/client/Build/client.data.gz"));
});

app.use("/:screen/Build/client.wasm.gz", (req, res, next) => {
    res.contentType("application/wasm");
    res.setHeader("Content-Encoding", "gzip");
    res.sendFile(path.join(__dirname, "/public/client/Build/client.wasm.gz"));
});

app.use('/:screen', express.static(__dirname + '/public/client'))
app.get('/:screen', (req, res) => {
    res.sendFile('index.html');
});

module.exports = app;