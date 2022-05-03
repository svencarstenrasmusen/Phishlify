const express = require('express');
// const router = express.Router();
let router = express.Router({ mergeParams : true });

const connection = require('../db');

router.get('/', (request, response) => {
    console.log('message ',request.params)
    const projectId = request.params.projectid;
    
    let sql_query = `SELECT * FROM campaigns where projectId="${projectId}"`
    connection.query(sql_query, function (err, results) {
        if (err) throw err;
        console.log('result ', results)
        response.send(results);
    });
});

module.exports = router;