const express = require('express');
const app = express();
const port = 3000;

const connection = require('./db');


// gives you projects against email 
app.get('/projects/:email', (request, response) => {

    const email = request.params.email;
    console.log(email);
    let sql_query = `Select * from user
    JOIN projects ON user.userId = projects.userId
    WHERE user.email="${email}"`

    connection.query(sql_query, function (err, results) {
        if (err) throw err;
        console.log('result ', results)
        response.send(results);
    });
});

app.listen(port, () => {
    console.log(`Hello world app listening on port ${port}!`)
    connection.connect(function (err) {
        if (err) throw err;
        console.log('Database connected!');
    })
})