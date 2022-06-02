const express = require('express');
const { response } = require('../app');
let router = express.Router({ mergeParams : true });
const connection = require('../db');

router.post('/', (req, res) => {
    console.log('email route deleting', req.body);
    let email = req.body.email;
    let campaignId = req.body.campaignId;

    delete_email_query = `DELETE FROM targets WHERE campaignId = ${campaignId} AND email = "${email}";`;


    connection.query(delete_email_query, function (err, results) {
        if (err) throw err;
        console.log('results ', results);
        res.status(200).send(results);
    });

});
module.exports = router;