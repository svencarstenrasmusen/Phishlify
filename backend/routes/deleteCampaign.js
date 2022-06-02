const express = require('express');
const { response } = require('../app');
let router = express.Router({ mergeParams : true });
const connection = require('../db');

router.post('/', (req, res) => {
    console.log('campaign route deletion', req.body);
    let campaignId = req.body.campaignId;
    delete_campaign_query = `DELETE FROM campaigns WHERE campaignId = ${campaignId};`;


    connection.query(delete_campaign_query, function (err, results) {
        if (err) throw err;
        console.log('results ', results);
        res.status(200).send(results);
    });

});
module.exports = router;