const BimService = require('../services/bim.service');
const upload = require('../middlewares/upload');

class BimController {
    /**
     * 
     * @param {Request} req The request object
     * @param {Response} res The response object
     * @returns {Response} The response object
     */
    async put(req, res) {
        try {
            const value = req.body;
            const key = await new BimService().put(value);
            res.status(200).json({
                'success': true,
                'value': key
            });
        } catch(err) {
            res.status(err.status).json({
                'success': false,
                'message': err.message
            });
        }
    }

    /**
     * 
     * @param {Request} req The request object
     * @param {Response} res The response object
     * @returns {Response} The response object
     */
    async getAll(req, res) {
        try {
            const values = await new BimService().getAll();
            res.status(200).json({
                'success': true,
                'values': values
            });
        } catch (err) {
            res.status(err.status).json({
                'success': false,
                'message': err.message
            });
        }
    }

    /**
     * 
     * @param {Request} req The request object
     * @param {Response} res The response object
     * @returns {Response} The response object
     */
    async getByKey(req, res) {
        try {
            const key = req.params.key;
            const value = await new BimService().getByKey(key);
            res.status(200).json({
                'success': true,
                'value': value
            });
        } catch(err) {
            res.status(err.status).json({
                'success': false,
                'message': err.message
            });
        }
    }

    /**
     * 
     * @param {Request} req The request object
     * @param {Response} res The response object
     * @returns {Response} The response object
     */
    async delete(req, res) {
        try {
            const key = req.params.key;
            await new BimService().delete(key);
            res.status(200).json({
                'success': true
            });
        } catch(err) {
            res.status(err.status).json({
                'success': false,
                'message': err.message
            });
        }
    }

    /**
     * 
     * @param {Request} req The request object
     * @param {Response} res The response object
     * @returns {Response} The response object
     */
    async uploadModel(req, res) {
        try {
            await upload(req, res);

            const file = req.file;
            const name = req.body.name;
            const key = await new BimService().uploadModel(name, file);

            res.status(200).json({
                'success': true,
                'key': key
            });
        } catch (err) {
            res.status(err.status).json({
                'success': false,
                'message': err.message
            });
        }
    }
}

module.exports = BimController;