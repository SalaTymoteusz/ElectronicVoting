'use strict';
const debug = require('debug')('mongo:schemas');
const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const ImageSchema = new Schema({
    resource:{
        type:String,
        enum:["AVATAR","NOTFOUND","OTHER"],
        default:"OTHER"
    },
    image:{data:Buffer,contentType:String
    }
});
module.exports = mongoose.model("Image",ImageSchema,"Images");