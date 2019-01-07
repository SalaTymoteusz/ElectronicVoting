
'use strict';
const express = require('express');
const morgan = require('morgan');
const bodyParser = require('body-parser');
const config = require('./config');
const cors = require('cors');
const sendData = require("../../helpers/express.plugins/sendData");

module.exports = (app)=> {

  //set views
  app.set('views',config.root+ '../views');
  app.set('view engine', 'jade');
//parse body
  app.use(bodyParser.urlencoded({ extended: false }));
  app.use(bodyParser.json());
 
  app.use('/', express.static(__dirname + '/public')); 
  //set cors
  app.use(cors());

  //use Send data
  app.use(sendData);

  //set config path for public
  app.set('appPath', config.root);

  app.use(morgan('dev'));
};