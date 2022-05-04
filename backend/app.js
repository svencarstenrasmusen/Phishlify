const express = require('express');
const app = express();
const bodyParser = require('body-parser');
const port = 3000;
const connection = require('./db');

// routes imports
const registerRoute = require('./routes/register');
const loginRoute = require('./routes/login');
const projectsRoute = require('./routes/projects');
const campaignsRoute = require('./routes/campaigns');

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

// routes 
app.use('/register', registerRoute);
app.use('/login', loginRoute);
app.use('/projects/:email', projectsRoute);
app.use('/campaigns/:projectid', campaignsRoute);

// start server 
app.listen(port, () => {
    console.log(`Hello world app listening on port ${port}!`);
    connection.connect(function (err) {
        if (err) {
            console.log(err);
            throw err;
        }
        console.log('Database connected!');
    });
});

module.exports = app;