const debug = require('debug')('mongo:controllers');
const User = require('../../api/users/user.model');
//var passport = require('passport');
const jsign = require('jsonwebtoken/sign');

const error=require("../../helpers/errors");

exports.index = async (req, res) => {
  try {

    //search for users
    const data = await User.find()
    res.sendData(data);
  } catch (err) {
    debug(err);
    res.sendData(new error.response(500, err.message))
  }
};


exports.create = async (req, res) => {
  try {
    //remove role if somebody want to add
    const{group,permissions, ...userData}=req.body;
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
      user: {
        id: user._id,
        pesel: user.pesel,
        role: user.role,
  
      },
      token: token
    })
  } catch (err) {
    debug(err);
    res.sendData(new error.response(500, err.message))
  }
};
exports.show = async (req, res) => {
  try {
    //search for specific User
    const user = await User.findById(req.params.id);
    if (!user)
      throw new error.response(404, "Not Found");
  } catch (err) {
    debug(err);
    res.sendData(new error.response(500, err.message))
  }
};
//TODO: Update

exports.destroy = async (req, res) => {
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