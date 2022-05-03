const express = require('express');
let router = express.Router({ mergeParams : true });
const connection = require('../db');


router.get('/', (req, res) => {

    console.log('projects route ',req.params)

    const email = req.params.email;
    let sql_query = `Select * from user
    JOIN projects ON user.userId = projects.userId
    WHERE user.email="${email}"`

    connection.query(sql_query, function (err, results) {
        if (err) throw err;
        console.log('result ', results)
        response.send(results);
    });
});

module.exports = router;