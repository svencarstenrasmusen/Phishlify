const express = require('express');
let router = express.Router({ mergeParams : true });
const connection = require('../db');


router.get('/', (req, res) => {

    console.log('all campaigns route ', req.params)

    let sql_query = `SELECT * FROM campaigns`

    connection.query(sql_query, function (err, results) {
        if (err) throw err;
        console.log('result ', results)
        res.status(200).send(results);
    });
});

module.exports = router;