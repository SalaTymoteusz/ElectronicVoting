const Image = require("./image.model");
const User = require("../users/user.model");
const upload=require("../../config/multer")
const debug = require('debug')('api:controllers');
const fs=require("fs")

function removeFile(file){
    //remove file from disc
    fs.unlinkSync(file.path)
    debug("File deleted")
}
exports.createAvatar=async (req,res)=>{
    //TODO: user Authentication
    //upload file to server
    await upload(req,res,async (error)=>{
        try{
            // if problem with uploading
            if(error){
                throw new Error("unkown error ",error)
            }else{
                // search for user
                let user= await User.findById(req.params.id);
                // chceck if user exist
                if(!user){
                    throw new Error("user not Found")
                }
                 // if file dont exist throw error
                if(req.file == undefined){
                    throw new Error("attach File")
                }else{
                    // delete if user do have avatar previous
                    if(user.avatar){
                      await Image.findByIdAndDelete(user.avatar);
                    }
                    // create new image
                    let newImage= new Image();
                    //set user 
                    // newImage.userID=req.params.id
                    newImage.resource="AVATAR";
                    newImage.image.data=fs.readFileSync(req.file.path);
                    newImage.image.contentType=req.file.mimetype;
                    let img = await newImage.save();
                    
                    //update user
                    await User.updateOne({_id:user._id},{avatar:img._id});
                    // respond with success
                    // TODO: SuccessResponse
                    res.send({success:true})
                }
            }
        }
        catch(e){
            debug(e)
            console.log(e);
            // TODO: ErrorResponse
            res.send({success:false,error:e.message})
        }
        finally{
            //remove file from server
            if(req.file)
            removeFile(req.file);
        }
    })
}
 exports.getAvatar=async (req,res)=>{
     try{
          // search for user
          let user= await User.findById(req.params.id);
          // chceck if user exist
          if(!user){
              throw new Error("user not Found")
          }
          // search for image
          let img=await Image.findById(user.avatar);
          if(!img){
            throw new Error("image not Found")
            }   
          // set content type
          res.contentType(img.image.contentType);
          // send image
          res.send(img.image.data);
     }
     catch(e){
         console.log(e)
          // TODO: ErrorResponse
          res.status(404);
          res.send({success:false,error:e.message})
     }
 
 }