const mysql = require("mysql");

const connection = mysql.createConnection({
    host: '127.0.0.1',
    database: 'phishlify',
    user: 'root',
    password: '1flockenfutter!1',
    port: 3307
});

module.exports = connection;