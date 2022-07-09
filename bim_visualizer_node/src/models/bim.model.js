module.exports = class BimModel {
    constructor({ isDemo, modelPath, meta } = {}) {
        this.isDemo = isDemo;
        this.modelPath = modelPath;
        this.meta = meta;
    }
}