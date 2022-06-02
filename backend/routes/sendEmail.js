const express = require('express');
const { response } = require('../app');
let router = express.Router({ mergeParams : true });
const connection = require('../db');
var nodemailer = require('nodemailer');

router.post('/', (req, res) => {
    console.log('campaign route creation', req.body);
    let email = req.body.email;
    let subject = req.body.subject;
    let text = req.body.text;

    var transporter = nodemailer.createTransport({
        service: 'gmail',
        requireTLS: true,

        auth: {
            user: 'sven.the.eagle@gmail.com',
            pass: ''
        }
    });

    var mailOptions = {
        from: 'sven.the.eagle@gmail.com',
        to: email,
        subject: subject,
        text: text
    };

    transporter.sendMail(mailOptions, function(error, info) {
        if (error) {
            console.log(error);
            res.status(400).send(false);
        } else {
            console.log('Email sent: ', + info.response);
            res.status(200).send(true);
        }
    });

});
module.exports = router;