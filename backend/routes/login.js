const express = require('express');
const router = express.Router();
const connection = require('../db');

router.post('/', (req, res) => {
    console.log('login req ', req.body)
    let email = req.body.email;
    let password = req.body.password;
    let sql_query = `SELECT * FROM user where email="${email}" AND password=${password}`

    connection.query(sql_query, function (err, results) {
        if (err) throw err;
        console.log('result ', results.length)
        if (results.length > 0) {
            // login successful
            res.send('200');
        }
        else {
            // Credentials are not correct !
            res.send('400') 
        }
    });
});

module.exports = router;