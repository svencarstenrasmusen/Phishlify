const express = require('express');
const { response } = require('../app');
let router = express.Router({ mergeParams : true });
const connection = require('../db');
var nodemailer = require('nodemailer');

router.post('/', (req, res) => {
    console.log('campaign route creation', req.body);
    let email = req.body.email;

    var transporter = nodemailer.createTransport({
        service: 'gmail',
        auth: {
            user: 'phishlify@gmail.com',
            pass: 'random123random'
        }
    });

    var mailOptions = {
        from: 'phishlify@gmail.com',
        to: 'sven.the.eagle@gmail.com',
        subject: 'testPhishlify123',
        text: 'I hope this worked.'
    };

    transporter.sendMail(mailOptions, function(error, info) {
        if (error) {
            console.log(error);
        } else {
            console.log('Email sent: ', + info.response);
        }
    });

});
module.exports = router;