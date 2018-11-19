const passport = require('passport');
const User = require('../../api/users/user.model');

module.exports = function localAuthenticate(pesel, password, done) {
  User.findOne({
      pesel: pesel.toLowerCase()
    })
    .then(function (user) {

      if (!user) {
        return done(null, false, {
          error: 'This User is not registered.'
        });
      }
      user.authenticate(password, function (authError, authenticated) {
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
    .catch(function (err) {
      return done(err);
    });
}