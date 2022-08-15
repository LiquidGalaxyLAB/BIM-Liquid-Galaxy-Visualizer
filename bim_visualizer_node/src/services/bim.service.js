const BimRepository = require('../repositories/bim.repository');
const BimModel = require('../models/bim.model');
const uuid = require('node-uuid');
// const { exec } = require('child_process');
const fs = require('fs');
const path = require('path');

require('dotenv').config({
    path: path.join(__basedir, `./.env.${process.env.NODE_ENV}`) 
});

class BimService {
    /**
     * 
     * @param {Value} value The value to be stored
     * @returns {Data} The stored values
     */
    async put(value) {
        try {
            let key = value.key;
            
            // if has key, update
            if (key) {
                await this.getByKey(key);
            } else {
                key = uuid.v1();
            }

            const bimModel = new BimModel(value);
            const data = JSON.parse(JSON.stringify(bimModel));
            
            await new BimRepository().put(key, data);
            
            return data;
        } catch (err) {
            const error = new Error();
            error.status = err.status ? err.status : 500;
            error.message = err.message ? err.message : 'Error while storing the value';
            throw error;
        }
    }

    /**
     * 
     * @returns {Array} Array of values
     */
    async getAll() {
        try {
            const values = await new BimRepository().getAll();
            return values;
        } catch (err) {
            const error = new Error();
            error.status = 500;
            error.message = 'Error while fetching values';
            throw error;
        }
    }

    /**
     * 
     * @param {Key} key The unique identifier of the value to be retrieved
     * @returns {Value} The value associated with the key
     */
    async getByKey(key) {
        try {
            if (!key)  {
                const error = new Error();
                error.status = 400;
                error.message = 'Key is required';
                throw error;
            }

            const value = await new BimRepository().getByKey(key);
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
            await this.getByKey(key);
            await new BimRepository().delete(key);
        } catch(err) {
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

    /**
     * 
     * @param {string} name The model display name
     * @param {File} file The file to be converted
     * @returns {Key} The unique identifier of the stored value
     */
    async uploadModel(name, file) {
        try {
            const key = uuid.v1();

            // // move model to Unity Assets/Models directory
            // const newPath = process.env.MODELS_LOCATION;
            // if (!fs.existsSync(newPath)) fs.mkdirSync(newPath);

            const oldPath = `./${file.path}`;
            fs.rename(oldPath, `public/models/${key}`, function (err) {
                if (err) {
                    const error = new Error();
                    error.status = 500;
                    error.message = err.message;
                    throw error;
                }
            });

            // // Build asset bundle
            // const unityPath = process.env.UNITY_PATH;
            // const projectPath = process.env.UNITY_PROJECT_PATH;
            // const bundleNameScript = `${unityPath} -batchmode -quit -projectPath ${projectPath} -executeMethod CreateAssetBundles.BuildAllAssetBundles -logFile log.txt`;
            // exec(bundleNameScript, (err, stdout, stderr) => {
            //     if (err) {
            //         const error = new Error();
            //         error.status = 500;
            //         error.message = err.message;
            //         throw error;
            //     }
            // });

            const bimModel = new BimModel({ name: name, isDemo: false, modelPath: 'models/' + key });
            const data = JSON.parse(JSON.stringify(bimModel));
            await new BimRepository().put(key, data);

            return key;
        } catch (err) {
            const error = new Error();
            error.status = err.status ? err.status : 500;
            error.message = err.message;
            throw error;
        }
    }
}

module.exports = BimService;