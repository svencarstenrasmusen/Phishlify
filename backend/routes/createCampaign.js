const express = require('express');
const { response } = require('../app');
let router = express.Router({ mergeParams : true });
const connection = require('../db');

router.post('/', (req, res) => {
    console.log('campaign route creation', req.body);
    let name = req.body.name;
    let projectId = req.body.projectId;
    let description = req.body.description;
    let domain = req.body.domain;

    create_campaign_query = `INSERT INTO campaigns (projectId, name, description, domain)
    VALUES (${projectId}, "${name}", "${description}", "${domain}")`;


    connection.query(create_campaign_query, function (err, results) {
        if (err) throw err;
        console.log('results ', results);
        res.status(200).send(results);
    });

});
module.exports = router;