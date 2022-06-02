const express = require('express');
const router = express.Router();
const connection = require('../db');
const bcrypt = require('bcryptjs');

const saltRounds = 10;

router.post('/', (req, res) => {
    console.log('register 1 ', req.body);
    const name = req.body.name;
    const email = req.body.email;
    const password = req.body.password;

    const userExists = `SELECT * from user WHERE email="${email}"`;

    connection.query(userExists, function (err, results) {
        if (err) throw err;
        if (results.length > 0) {
            res.send(409);
        }
        else {
            bcrypt.genSalt(saltRounds, function (encErr, salt) {
                if (encErr) {
                    console.error('Error: on hashing password.');
                    res.status(400).send('Error: on hashing password.');
                } else {
                    console.log('hashing...');
                    bcrypt.hash(password, salt, function (hashErr, hash) {
                        if (name !== '' && email !== '' && password !== '') {
                            let sql_query = `INSERT INTO user (name, email, password)
                                            VALUES ("${name}", "${email}", "${hash}")`;
                            connection.query(sql_query, function (err, results) {
                                if (err) throw err;
                                console.log('result ', results);
                                res.status(200).send(results);
                            });
                        } else {
                            res.send('Fields cannot be empty!')
                        }
                    })
                }
            });
        }
    });
});

module.exports = router;