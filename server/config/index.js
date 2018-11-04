const expressConf=require("./express");
const mongooseConf=require("./mongoose");
const passportConf=require("./passport");


//initialize configs
module.exports = (app)=>{
    expressConf(app);
    mongooseConf();
    passportConf(app);
}