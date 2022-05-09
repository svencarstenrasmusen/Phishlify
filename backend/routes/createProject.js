const express = require('express');
const { response } = require('../app');
let router = express.Router({ mergeParams : true });
const connection = require('../db');

router.post('/', (req, res) => {
    console.log('project route creation', req.body);
    let name = req.body.name;
    let personInCharge = req.body.personInCharge;
    let domain = req.body.domain;
    let startDate = req.body.startDate;
    let endDate = req.body.endDate;
    let language = req.body.language;
    let email = req.body.email;
    let userId;

    userid_sql_query = `SELECT userId from user WHERE email = "${email}"`;


    connection.query(userid_sql_query, function (err, resId) {
        if (err) throw err;
        console.log('resId ', resId);
        
        userId = resId[0].userId;
        create_project_query = `INSERT INTO projects (name, personInCharge, domain, startDate, endDate, userId, language)
        VALUES ("${name}", "${personInCharge}", "${domain}", "${startDate}", "${endDate}", "${userId}", "${language}")`;
        
        connection.query(create_project_query, function (err, results) {
            if (err) throw err;
            console.log('results ', results);
            res.status(200).send(results);
        });
    });

});

module.exports = router;
