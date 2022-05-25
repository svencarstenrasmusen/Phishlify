const express = require('express');
const app = express();
const bodyParser = require('body-parser');
const port = 3000;
const connection = require('./db');
const cors = require('cors');

// routes imports
const registerRoute = require('./routes/register');
const loginRoute = require('./routes/login');
const projectsRoute = require('./routes/projects');
const createProjectRoute = require('./routes/createProject');
const campaignsRoute = require('./routes/campaigns');
const createCampaignRoute = require('./routes/createCampaign');
const campaignsByProjectId = require('./routes/campaignsByProjectId');

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use(cors());
// routes
app.use('/register', registerRoute);
app.use('/login', loginRoute);
app.use('/projects/:email', projectsRoute);
app.use('/projects/create', createProjectRoute);
app.use('/campaigns/all', campaignsRoute);
app.use('/campaigns/create', createCampaignRoute);
app.use('/campaignsByProjectId/:projectId', campaignsByProjectId);

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