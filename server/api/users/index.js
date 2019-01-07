/**
 * Using Rails-like standard naming convention for endpoints.
 * GET     /users              ->  index
 * POST    /users              ->  create
 * GET     /users/:id          ->  show
 * PUT     /users/:id          ->  update
 * DELETE  /users/:id          ->  destroy
 */

const router = require('express/lib/router')();
const controller = require('./user.controller');

// const multer = require('../../config/multer');

router.get('/', controller.index);
router.post('/', controller.create);
router.post('/login', controller.login);
router.get('/:id', controller.show);
router.delete('/:id', controller.destroy);

module.exports = router;