const passport = require('passport');
const LocalStrategy = require('passport-local').Strategy;

const jwt = require('express-jwt');
const config = require("./config");
const User = require('../../api/users/user.model');
let localAuthenticate = require("./auth");
module.exports = (app) => {
  //initialize Auth
  app.use(passport.initialize());
  passport.use(
    new LocalStrategy({
        usernameField: 'pesel',
        passwordField: 'password' // this is the virtual field on the model
      },
      function (username, password, done) {
        return localAuthenticate(username, password, done);
      }
    )
  );
  app.use(
    jwt({
      secret: config.secret,
      credentialsRequired: false,
      getToken: function fromHeaderOrQuerystring(req) {
        if (req.headers.authorization) {
          return req.headers.authorization;
        } else if (req.query && req.query.token) {
          return req.query.token;
        }
        return null;
      }
    })
  );
}