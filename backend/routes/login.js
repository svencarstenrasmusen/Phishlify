const express = require('express');
const router = express.Router();
const connection = require('../db');
const bcrypt = require("bcryptjs");

router.post('/', (req, res) => {
    console.log('login req ', req.body)
    let email = req.body.email;
    let password = req.body.password;

    let password_query = `SELECT password FROM user where email = "${email}";`;

    connection.query(password_query, function(pwErr, hash) {
        if (pwErr) {
            console.error('Error: on logging in user.');
            res.status(400).send('Error: on logging in user.');
        } else if (hash.length < 1) {
            //User does not exist.
            res.status(400).send(false);
        } else {
            console.log("comparing hash...");
            bcrypt.compare(password, hash[0].password, function(compErr, isMatch) {
                if (compErr) {
                    console.error('Error: on comparing hashes.');
                    res.status(400).send('Error: on comparing hashes.');
                } else if (!isMatch) {
                    console.log("Password does not match!");
                    res.status(409).send('Credentials are not correct!!!') 
                } else {
                    let sql_query = `SELECT * FROM user where email="${email}";`;
                    console.log("Password matches!");
                    connection.query(sql_query, function (err, results) {
                        if (err) throw err;
                        console.log('result ', results.length)
                        if (results.length > 0) {
                            // login successful
                            res.status(200).send(results);
                        }
                        else {
                            // Credentials are not correct !
                            res.status(409).send('Credentials are not correct!') 
                        }
                    });
                }
            })
        }
    });

});

module.exports = router;