module.exports = class BimModel {
    constructor({ name, isDemo, modelPath, meta } = {}) {
        this.name = name;
        this.isDemo = isDemo;
        this.modelPath = modelPath;
        this.meta = meta;
    }
}