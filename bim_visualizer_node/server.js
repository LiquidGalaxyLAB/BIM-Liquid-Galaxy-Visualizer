global.__basedir = __dirname;
const app = require('./src/app');
const PORT = 3210;

app.listen(PORT, () => { console.log(`Server is listening on port ${PORT}`) });