//TODO: MOve this error to another file
class ResponseError extends Error {
    constructor(code, message) {
      super(message);
      this.code = code;
      this.error = message;
    }
  }
  module.exports=ResponseError;