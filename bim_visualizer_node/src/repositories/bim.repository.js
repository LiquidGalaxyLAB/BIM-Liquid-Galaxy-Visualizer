const db = require('../db/db');

class BimRepository {
    /**
     * 
     * @param {Key} key The unique identifier of the value to be stored
     * @param {Value} value The value to be stored
     * @returns {Promise<void>} Promise
     */
    async put(key, value) {
        return await db.put(key, value);
    }

    /**
     * @returns {Array} Array of values
     */
    async getAll() {
        const values = [];
        for await (const value of db.values()) {
            values.push(value);
        }
        return values;
    }

    /**
     * 
     * @param {Key} key The unique identifier of the value to be retrieved
     * @returns {Promise<string>} Promise
     */
    async getByKey(key) {
        return await db.get(key);
    }

    /**
     * 
     * @param {Key} key The unique identifier of the value to be deleted
     * @returns {Promise<void>} Promise
     */
    async delete(key) {
        return await db.del(key);
    }
}

module.exports = BimRepository;