const app = require('./app');
const http = require("http").createServer(app);
const PORT = 3210;

http.listen(PORT, () => { console.log(`Server is listening on port ${PORT}`) });