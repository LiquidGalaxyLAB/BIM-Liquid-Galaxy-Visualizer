const BimRepository = require('../repositories/bim.repository');
const uuid = require('node-uuid');

class BimService {
    /**
     * 
     * @param {Value} value The value to be stored
     * @returns {Key} The unique identifier of the stored value
     */
    async put(value) {
        try {
            const key = uuid.v1();
            await new BimRepository().put(key, value);
            return key;
        } catch (err) {
            const error = new Error();
            error.status = 500;
            error.message = 'Error while storing the value';
            throw error;
        }
    }

    /**
     * 
     * @param {Key} key The unique identifier of the value to be retrieved
     * @returns {Value} The value associated with the key
     */
    async get(key) {
        try {
            if (!key)  {
                const error = new Error();
                error.status = 400;
                error.message = 'Key is required';
                throw error;
            }

            const value = await new BimRepository().get(key);
            return value;
        } catch(err) {
            const error = new Error();
            if (err.status == 404) {
                error.message = 'There is no value associated with this key';
                error.status = err.status;
                throw error;
            }
            error.status = 500;
            error.message = 'Error while retrieving the value';
            throw error;
        }
    }

    /**
     * 
     * @param {Key} key The unique identifier of the value to be deleted
     * @returns {void} void
     */
    async delete(key) {
        try {
            await this.get(key);
            await new BimRepository().delete(key);
        } catch(err) {
            console.log('err',err);
            const error = new Error();
            if (err.status == 404) {
                error.message = 'There is no value associated with this key';
                error.status = err.status;
                throw error;
            }
            error.status = 500;
            error.message = 'Error while deleting the value';
            throw error;
        }
    }
}

module.exports = BimService;