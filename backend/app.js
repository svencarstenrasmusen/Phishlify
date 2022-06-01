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
const deleteProjectRoute = require('./routes/deleteProject');
const campaignsRoute = require('./routes/campaigns');
const createCampaignRoute = require('./routes/createCampaign');
const campaignsByProjectId = require('./routes/campaignsByProjectId');
const deleteCampaignRoute = require('./routes/deleteCampaign');
const emailsAdd = require('./routes/emailsAdd');

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
app.use('/campaigns/delete', deleteCampaignRoute);
app.use('/projects/delete', deleteProjectRoute);
app.use('/emails/add', emailsAdd);

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