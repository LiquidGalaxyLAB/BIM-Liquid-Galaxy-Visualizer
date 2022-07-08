const express = require('express');
const appRouter = express.Router();
const galaxyRoutes = require('./routes/galaxy');
const bimRoutes = require('./routes/bim');

appRouter.use(express.json());

appRouter.use('/', galaxyRoutes);
appRouter.use('/bim', bimRoutes);

module.exports = appRouter;