
const router = require('express/lib/router')();
const controller = require('./image.controller');

// const multer = require('../../config/multer');

// send avatar to server
router.post('/avatar/:id', controller.createAvatar);
// get avatar from server
router.get('/avatar/:id', controller.getAvatar);


module.exports = router;