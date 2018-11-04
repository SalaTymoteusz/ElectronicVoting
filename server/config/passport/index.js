const passport = require('passport');
const jwt = require('express-jwt');
const config=require("./config");
require('./auth').setup();
module.exports = (app)=> {
  //initialize Auth
  app.use(passport.initialize());
//   app.use(
//     jwt({
//       secret: config.secret,
//       credentialsRequired: false,
//       getToken: function fromHeaderOrQuerystring(req) {
//         if (req.headers.authorization) {
//           return req.headers.authorization;
//         } else if (req.query && req.query.token) {
//           return req.query.token;
//         }
//         return null;
//       }
//     })
//   );
}