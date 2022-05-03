const express = require('express');
const router = express.Router();
const connection = require('../db');

router.post('/', (req, res) => {
    console.log('register 1 ', req.body);
    const userId = req.body.userId;
    const name = req.body.name;
    const email = req.body.email;
    const password = req.body.password;

    const userExists = `SELECT * from user WHERE email="${email}"`;

    connection.query(userExists, function (err, results) {
        if (err) throw err;
        if (results.length > 0) {
            res.send('User Alreadry Exists !')
        }
        else {
            if(userId !== '' && name !== '' && email !== '' && password !==''){
                let sql_query = `INSERT INTO user
                VALUES (${userId}, "${name}", "${email}", ${password})`;
                connection.query(sql_query, function (err, results) {
                    if (err) throw err;
                    console.log('result ', results)
                    res.send("User Inserted ! ");
                });
            } else {
                res.send('Fields cannot be empty!')
            }
        }
    });
});

module.exports = router;