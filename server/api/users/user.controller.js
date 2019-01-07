const User = require('./user.model');
const debug = require('debug')('api:controllers');
const passport = require("passport")
const config = require("../../config").config;
const jsign = require('jsonwebtoken/sign');
const error = require("../../helpers/errors");

exports.index = async (req, res) => {
  //TODO: user Authentication
  try {
    //search for users
    const data = await User.find()
    data.map(x => x.profile);
    res.sendData(data);
  } catch (err) {
    debug(err);
    res.sendData(new error.response(500, err.message))
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
    }, "ala ma kota", {
      expiresIn: 60 * 5 * 60
    });
    //response with simple user Data and token
    res.sendData({
      user: user.profile,
      token: token
    })
  } catch (err) {
    debug(err);
    res.sendData(new error.response(500, err.message))
  }
};
exports.show = async (req, res) => {
  //TODO: user Authentication
  try {
    //search for specific User
    const user = await User.findById(req.params.id);
    if (!user)
      throw new error.response(404, "Not Found");
//TODO: user send
  } catch (err) {
    debug(err);
    res.sendData(new error.response(500, err.message))
  }
};
//TODO: Update

exports.destroy = async (req, res) => {
  //TODO: user Authentication
  try {
    //search for specific User
    const user = await User.findById(req.params.id);
    if (!user) throw new error.response(404, "Not Found");
    //remove him if exist
    await user.remove()
    res.sendData("removed");
  } catch (err) {
    debug(err);
    res.sendData(new error.response(500, err.message))
  }
};
exports.login = async (req, res, next) => {
  passport.authenticate('local', function (err, user, info) {
    var error = err || info;
    if (error) {
      return res.status(401).json(error);
    }
    if (!user) {
      return res
        .status(404)
        .json({
          message: 'Something went wrong, please try again.'
        });
    }
    var token = jsign({
      _id: user._id
    }, config.passport.secret, {
      expiresIn: 60 * 5 * 60
    });
    res.json({
      user: user.profile,
      token: token
    });
  })(req, res, next);
}




