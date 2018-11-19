var passport = require('passport');
var LocalStrategy = require('passport-local').Strategy;

function localAuthenticate(User, login, password, done) {
  User.findOne({
    login: login.toLowerCase()
  })
    .populate('movies ratings reviews likes ')
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

exports.setup = function(User, config) {
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
