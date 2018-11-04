const mongoose = require('mongoose');
const config = require('./config');
module.exports=()=>{
  //connect to mongo
mongoose.connect(config.uri, config.options);

//make response as promises
mongoose.Promise = global.Promise;

//check connections
mongoose.connection.on('error', function(err) {
  console.error(
    'MongoDB connection to <' + config.uri + '> failed: ' + err
  );

  process.exit(-1);

});
}