'use strict';

var passport = require('passport');
var config = require('../config/environment');
var jwt = require('jsonwebtoken');
var expressJwt = require('express-jwt');
var compose = require('composable-middleware');
var User = require('../api/user/user.model');
var validateJwt = expressJwt({
  secret: config.secrets.session
});

/**
 * Attaches the user object to the request if authenticated
 * Otherwise returns 403
 */
function isAuthenticated() {
  return (
    compose()
      // Validate jwt
      .use(function(req, res, next) {
        // allow access_token to be passed through query parameter as well
        if (req.query && req.query.hasOwnProperty('access_token')) {
          req.headers.authorization = 'Bearer ' + req.query.access_token;
        } else if (!req.headers.authorization) {
          return res.status(401).send({ error: 'Unauthorized' });
        }
        req.headers.authorization = 'Bearer ' + req.headers.authorization;
        validateJwt(req, res, next);
      })
      // Attach user to request
      .use(function(req, res, next) {
        User.findByIdAsync(req.user._id)

          .then(function(user) {
            if (!user) {
              return res.status(401).send({ error: 'Unauthorized' });
            }
            req.user = user;
            next();
          })
          .catch(function(err) {
            return next(err);
          });
      })
  );
}

/**
 * Checks if the user role meets the minimum requirements of the route
 */
function hasRole(roleRequired) {
  if (!roleRequired) {
    throw new Error('Required role needs to be set');
  }

  return compose()
    .use(isAuthenticated())
    .use(function meetsRequirements(req, res, next) {
      if (
        config.userRoles.indexOf(req.user.role) >=
        config.userRoles.indexOf(roleRequired)
      ) {
        next();
      } else {
        res.status(403).send('Forbidden');
      }
    });
}

function isAuthor() {
  return compose()
    .use(isAuthenticated())
    .use(function(req, res, next) {
      if (req.user._id == req.body.userId || req.user.role == 'admin') {
        next();
      } else {
        res.status(403).send('Forbidden');
      }
    });
}
/**
 * Returns a jwt token signed by the app secret
 */
function signToken(id, role) {
  return jwt.sign({ _id: id, role: role }, config.secrets.session, {
    expiresIn: 60 * 5 * 60
  });
}

exports.isAuthenticated = isAuthenticated;
exports.hasRole = hasRole;
exports.isAuthor = isAuthor;
exports.signToken = signToken;
