const mysql = require("mysql");

const connection = mysql.createConnection({
    host: 'localhost',
    database: 'phishlify',
    user: 'root',
    password: '87654321'
});

module.exports = connection;