const express = require('express');
const router = express.Router();
const BimController = require('../../controllers/bim.controller');

router.route('/').get(async (req, res) => {
    await new BimController().getAll(req, res);
});

router.route('/').post(async (req, res) => {
    await new BimController().put(req, res);
});

router.route('/upload').post(async (req, res) => {
    await new BimController().uploadModel(req, res);
})

router.route('/:key').get(async (req, res) => {
    await new BimController().getByKey(req, res);
});

router.route('/:key').delete(async (req, res) => {
    await new BimController().delete(req, res);
});

module.exports = router;