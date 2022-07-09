const BimRepository = require('../repositories/bim.repository');
const BimModel = require('../models/bim.model');
const uuid = require('node-uuid');
const { exec } = require('child_process');
const fs = require('fs');

class BimService {
    /**
     * 
     * @param {Value} value The value to be stored
     * @returns {Key} The unique identifier of the stored value
     */
    async put(value) {
        try {
            const key = uuid.v1();

            const bimModel = new BimModel(value);
            const data = JSON.parse(JSON.stringify(bimModel));
            
            await new BimRepository().put(key, data);
            
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
     * @param {File} file The file to be converted
     * @returns {string} converted file path
     */
    async convertModel(file) {
        try {
            // move file to Unity Assets/Models directory
            const oldPath = `./${file.path}`;
            const newPath = '';
            if (!fs.existsSync(newPath)) fs.mkdirSync(newPath);

            fs.rename(oldPath, `${newPath}/${file.originalname}`, function (err) {
                if (err) {
                    const error = new Error();
                    error.status = 500;
                    error.message = err.message;
                    throw error;
                }
            });

            // Add asset bundle tag to file
            const unityPath = 'unity';
            const projectPath = '~/projects/BIM-Liquid-Galaxy-Visualizer/BIMVisualizerUnity';
            const bundleNameScript = `${unityPath} -batchmode -quit -projectPath ${projectPath} -executeMethod ChangeBundleName.Change -logFile log.txt`;
            exec(bundleNameScript, (err, stdout, stderr) => {
                if (err) {
                    const error = new Error();
                    error.status = 500;
                    error.message = err.message;
                    throw error;
                }
            });

            // Build the asset bundle
            
            // move asset bundle to public directory
        } catch (err) {
            const error = new Error();
            error.status = err.status ? err.status : 500;
            error.message = err.message;
            throw error;
        }
    }
}

module.exports = BimService;