const express = require('express');
const { response } = require('../app');
let router = express.Router({ mergeParams : true });
const connection = require('../db');

router.post('/', (req, res) => {
    console.log('project route deletion', req.body);
    let projectId = req.body.projectId;
    delete_campaign_query = `DELETE FROM campaigns WHERE projectId = ${projectId};`;
    
    delete_project_query = `DELETE FROM projects WHERE projectId = ${projectId};`;


    connection.query(delete_campaign_query, function (err, results) {
        if (err) {
            res.status(400).send('Error on deleting campaigns of project.');
        } else {
            connection.query(delete_project_query, function(err2, projResults) {
                if (err) {
                    res.status(400).send('Error on deleting project.');
                } else {
                    res.status(200).send(projResults);
                }
            });
        }
    });

});
module.exports = router;