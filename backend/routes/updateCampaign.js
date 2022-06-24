const express = require('express');
const { response } = require('../app');
let router = express.Router({ mergeParams : true });
const connection = require('../db');

router.post('/', (req, res) => {
    console.log('campaign route update', req.body);
    let campaignId = req.body.campaignId;
    let subject = req.body.subject;
    let content = req.body.content;


    update_campaign_query = `UPDATE campaigns SET subject = "${subject}", content = "${content}" WHERE campaignId = ${campaignId}`;


    connection.query(update_campaign_query, function (err, results) {
        if (err) throw err;
        console.log('results ', results);
        res.status(200).send(results);
    });

});
module.exports = router;