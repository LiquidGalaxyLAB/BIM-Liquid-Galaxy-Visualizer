const multer = require("multer");
const util = require("util");
const fs = require("fs");

const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    const path = "./tempDir";
    if (!fs.existsSync(path)) fs.mkdirSync(path);
    cb(null, path);
  },
  filename: (req, file, cb) => {
    cb(null, file.originalname);
  },
});

const upload = multer({
  storage: storage,
}).single('file');

const uploadFileMiddleware = util.promisify(upload);

module.exports = uploadFileMiddleware;