const BimService = require('../services/bim.service');

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
    async get(req, res) {
        try {
            const key = req.params.key;
            const value = await new BimService().get(key);
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
}

module.exports = BimController;