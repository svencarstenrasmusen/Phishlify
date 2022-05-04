const express = require('express');
const router = express.Router();
const connection = require('../db');

router.post('/', (req, res) => {
    console.log('register 1 ', req.body);
    const name = req.body.name;
    const email = req.body.email;
    const password = req.body.password;

    const userExists = `SELECT * from user WHERE email="${email}"`;

    connection.query(userExists, function (err, results) {
        if (err) throw err;
        if (results.length > 0) {
            res.send('User Already Exists!')
        }
        else {
            if(name !== '' && email !== '' && password !==''){
                let sql_query = `INSERT INTO user (name, email, password)
                VALUES ("${name}", "${email}", ${password})`;
                connection.query(sql_query, function (err, results) {
                    if (err) throw err;
                    console.log('result ', results)
                    res.send("User Inserted!");
                });
            } else {
                res.send('Fields cannot be empty!')
            }
        }
    });
});

module.exports = router;