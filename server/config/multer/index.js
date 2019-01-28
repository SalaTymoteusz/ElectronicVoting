const multer = require('multer');
const path   = require('path');
const debug = require('debug')('multer');

/** Storage Engine */
const storageEngine = multer.diskStorage({
  destination: './public',
  filename: function(req, file, fn){
    debug("Received File: "+file.originalname)
    fn(null,  new Date().getTime().toString()+'-'+file.fieldname+path.extname(file.originalname));
  }
}); 

//init

const upload =  multer({
  storage: storageEngine,
  limits:{
    fileSize:1024*1024*5 //B->KB->MB *5
  },
  fileFilter: function(req, file, callback){
    validateFile(file, callback); 
  },

}).single('image');


var validateFile = function(file, cb ){
 // console.log(file);
  allowedFileTypes = /jpeg|jpg|png|gif/;
  const extension = allowedFileTypes.test(path.extname(file.originalname).toLowerCase());
  const mimeType  = allowedFileTypes.test(file.mimetype);
  if(extension && mimeType){
    return cb(null, true);
  }else{
    cb("Invalid file type. Only JPEG, PNG and GIF file are allowed.")
  }
}


module.exports = upload;