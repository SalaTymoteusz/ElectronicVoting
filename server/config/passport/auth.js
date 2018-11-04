const passport = require('passport');
const User = require('../../api/users/user.model');
const LocalStrategy = require('passport-local').Strategy;

function localAuthenticate(login, password, done) {

  User.findOne({
    login: login.toLowerCase()
  })
    .then(function(user) {
      if (!user) {
        return done(null, false, {
          error: 'This User is not registered.'
        });
      }
      user.authenticate(password, function(authError, authenticated) {
        if (authError) {
          return done(authError);
        }
        if (!authenticated) {
          return done(null, false, {
            error: 'This password is not correct.'
          });
        } else {
          return done(null, user);
        }
      });
    })
    .catch(function(err) {
      return done(err);
    });
}

exports.setup =() =>{
  passport.use(
    new LocalStrategy(
      {
        usernameField: 'login',
        passwordField: 'password' // this is the virtual field on the model
      },
      function(login, password, done) {
        return localAuthenticate(User, login, password, done);
      }
    )
  );
};