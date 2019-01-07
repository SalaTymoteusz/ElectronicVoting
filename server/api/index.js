module.exports = function(app) {
    // Insert routes below
  
    app.use('/users', require('./users'));
    app.use('/images', require('./images'));
  
  };