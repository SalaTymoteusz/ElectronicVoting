'use strict';

var passport = require('passport');
var config = require('../config/environment');
var jwt = require('jsonwebtoken');
var expressJwt = require('express-jwt');
var compose = require('composable-middleware');
var User = require('../api/user/user.model');
const ResponseWithError = require("../helpers/errors");

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
      .use(function (req, res, next) {
        try {
          // allow access_token to be passed through query parameter as well
          if (req.query && req.query.hasOwnProperty('access_token')) {
            req.headers.authorization = 'Bearer ' + req.query.access_token;
          } else if (!req.headers.authorization) {
            throw new ResponseWithError(401, "Unauthorized");
          }
          req.headers.authorization = 'Bearer ' + req.headers.authorization;
          validateJwt(req, res, next);
        } catch (e) {
          res.sendError(e);
        }
      })
      // Attach user to request
      .use(function (req, res, next) {
        try {
          User.findByIdAsync(req.user._id)

            .then(function (user) {
              if (!user) {
                throw new ResponseWithError(401, "Unauthorized");
              }
              req.user = user;
              next();
            })
            .catch(function (err) {
              return next(err);
            });
        } catch (e) {
          res.sendError(e);
        }
      })

  );
}

/**
 * Checks if the user role meets the minimum requirements of the route
 */
function hasRole(roleRequired) {
  try{
  if (!roleRequired) {
    throw new ResponseWithError(401, "Unauthorized");
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
        throw new ResponseWithError(403, "Forbidden");
      }
    });
  }
  catch(e){
    res.sendError(e);
  }
}

function isAuthor() {
  try{
  return compose()
    .use(isAuthenticated())
    .use(function (req, res, next) {
      if (req.user._id == req.body.userId || req.user.role == 'admin') {
        next();
      } else {
        throw new ResponseWithError(403, "Forbidden");
      }
    });
  }catch(e){
    res.sendError(e);
  }
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
