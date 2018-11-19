const expressConf = require("./express");
const mongooseConf = require("./mongoose");
const passportConf = require("./passport");


//initialize configs
module.exports = (app) => {
    expressConf(app);
    mongooseConf();
    passportConf(app);
}
module.exports.config = {
    express: require("./express/config"),
    mongoose: require("./mongoose/config"),
    passport: require("./passport/config")
}