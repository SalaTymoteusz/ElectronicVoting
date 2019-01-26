const Image = require("./image.model");
const User = require("../users/user.model");
const upload = require("../../config/multer")
const debug = require('debug')('api:controllers');
const fs = require("fs")
const notFoundPath = "/notFound.gif";
const ResponseWithError = require("../../helpers/errors");

function removeFile(file) {
    //remove file from disc
    fs.unlinkSync(file.path);
    debug("File deleted: " + file.path);
}
exports.createAvatar = async (req, res) => {
    console.log(req.file);
    //TODO: user Authentication
    //upload file to server
    await upload(req, res, async (error) => {
        try {
            // if problem with uploading
            if (error) {
                throw new Error(error);
            } else {
                // if file dont exist throw error
                if (req.file == undefined) {
                    throw new ResponseWithError(400, "File Not Found");
                }
                // search for user
                let user = await User.findById(req.params.id);
                // chceck if user exist
                if (!user) {
                    throw new ResponseWithError(404, "User Not Found");
                }
                // delete if user have previous
                if (user.avatar) {
                    await Image.findByIdAndDelete(user.avatar);
                }
                // create new image
                let newImage = new Image();
                newImage.resource = "AVATAR";
                newImage.image.data = fs.readFileSync(req.file.path);
                newImage.image.contentType = req.file.mimetype;
                let img = await newImage.save();

                //update user
                await User.updateOne({ _id: user._id }, { avatar: img._id });
                // respond with success
                res.sendSuccess({ success: true }, 201);
            }
        }
        catch (e) {
            debug(e);
            res.sendError(e);
        }
        finally {
            //remove file from server
            if (req.file)
                removeFile(req.file);
        }
    })
}
exports.getAvatar = async (req, res) => {
    try {
        // search for user
        let user = await User.findById(req.params.id);
        // chceck if user exist
        if (!user) {
            throw "User Not Found";
        }
        // search for image
        let img = await Image.findById(user.avatar);
        if (!img) {
            throw "Image Not Found";
        }
        // set content type
        res.contentType(img.image.contentType);
        // send image
        res.send(img.image.data);
    }
    catch (e) {
        debug(e);
        // redirect to not found image
        res.redirect(notFoundPath);
    }

}