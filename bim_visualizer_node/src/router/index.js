const express = require('express');
const appRouter = express.Router();
const galaxyRoutes = require('./routes/galaxy');
const bimRoutes = require('./routes/bim');

appRouter.use(express.json());

appRouter.use('/tmp', express.static(__basedir + '/public/tmp'));

appRouter.use('/galaxy', galaxyRoutes);
appRouter.use('/bim', bimRoutes);

module.exports = appRouter;