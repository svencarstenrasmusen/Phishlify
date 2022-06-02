const express = require('express');
let router = express.Router({ mergeParams : true });
const connection = require('../db');


router.get('/', (req, res) => {

    let campaignId = req.params.campaignId;

    console.log('email by campaign route ', req.params)

    let sql_query = `SELECT * FROM targets WHERE campaignId = ${campaignId};`;

    connection.query(sql_query, function (err, results) {
        if (err) throw err;
        console.log('result ', results)
        res.status(200).send(results);
    });
});

module.exports = router;