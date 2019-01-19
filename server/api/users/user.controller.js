const User = require('./user.model');
const Image = require("../images/image.model");
const debug = require('debug')('api:controllers');
const passport = require("passport")
const config = require("../../config").config;
const jsign = require('jsonwebtoken/sign');
const ResponseWithError = require("../../helpers/errors");

exports.index = async (req, res) => {
  console.log(req.query)
  for(let q in req.query){
    if(req.query[q][0]=='/'){
      req.query[q]=req.query[q].slice(1,req.query[q].length);
      req.query[q]= new RegExp(req.query[q]);
    }
  }
  console.log(req.query)

  // req.query.map(x=>{
  //   if(x[0]=='/')
  //     return new RegExp(x);
  //   else return x;
  // })
  try { 
    //search for users
    const data = await User.find(req.query)
    data.map(x => x.profile);
    res.header("x-count",data.length);
    res.sendSuccess(data);
  } catch (err) {
    debug(err);
    res.sendError(err)
  }
};

exports.create = async (req, res) => {
  try {
    //remove role if somebody want to add
    const {
      group,
      permissions,
      votes,
      gaveVote,
      ...userData
    } = req.body;
    // validate data with user model
    const newUser = new User(userData);

    //save new user
    const user = await newUser.save();;
    // create token
    const token = jsign({
      _id: user._id
      //TODO: Change Secret
    },
      "ala ma kota",
      {
        expiresIn: 60 * 5 * 60
      });
    //response with simple user Data and token
    res.sendSuccess({
      ...user.profile,
      token
    }, 201)
  } catch (err) {
    debug(err);
    res.sendError(err)
  }
};
exports.update = async (req, res) => {
  console.log(req.body);
  try {
    const user = await User.findById(req.params.id);
    if (!user)
      throw new ResponseWithError(404, "Not Found");

      let userData={desc,surname,email}=req.body;
      await user.update(userData);
    res.sendSuccess({
      ...user.profile,
      ...userData
    }, 201)
  } catch (err) {
    debug(err);
    res.sendError(err)
  }
};
exports.show = async (req, res) => {
  //TODO: user Authentication
  try {
    //search for specific User
    const user = await User.findById(req.params.id);
    if (!user)
      throw new ResponseWithError(404, "Not Found");
    res.sendSuccess(user);
    //TODO: user send
  } catch (err) {
    debug(err);
    res.sendError(err)
  }
};
//TODO: Update

exports.destroy = async (req, res) => {
  //TODO: user Authentication
  try {
    //search for specific User
    const user = await User.findById(req.params.id);
    if (!user) throw new ResponseWithError(404, "Not Found");
    //remove him if exist
    if (user.avatar) {
      await Image.findByIdAndDelete(user.avatar);
    }
    await user.remove();
    res.sendSuccess({ removed: user });
  } catch (err) {
    debug(err);
    res.sendError(err)
  }
};
exports.login = async (req, res, next) => {
  passport.authenticate('local', (err, user, info) => {
    try {
      var error =  err || info;
      if (error) {

        throw error
      }
      if (!user) {
        throw new ResponseWithError(404, "Not Found")
      }
      var token = jsign({
        _id: user._id
      }, config.passport.secret, {
          expiresIn: 60 * 5 * 60
        });
      res.sendSuccess({
        ...user.profile,
        token
      });
    }
    catch (err) {
      debug(err);
      res.sendError(err)
    }
  })(req, res, next);

}
