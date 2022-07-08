const { Level } = require('level');

const db = new Level('./db', { valueEncoding: 'json' });

module.exports = db;