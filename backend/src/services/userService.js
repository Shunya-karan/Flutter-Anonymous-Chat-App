const User = require("../models/User");
const AppError = require("../errors/AppError");
const comparePassword = require("../utils/comparePassword");
const hashPassword = require("../utils/hashPassword");
const streamifier = require("streamifier");
const cloudinary = require("../config/cloudinary");


const UserService={
// updateProfile
  async updateProfile(userId, data,file)  {

    // Find User
      const user = await User.findById(userId);

    if (!user) {
        throw new AppError("User not found", 404);
  }

    // Check username uniqueness
    if (data.username && data.username !== user.username) {
    const usernameExists = await User.findOne({
        username: data.username,
    });
    if (usernameExists) {
        throw new AppError(
            "Username already exists",
            409
        );
    }
}

  let imageUrl =user.profileImage;
  if(file){
    const result = await new Promise((resolve,reject)=>{
      const stream = cloudinary.uploader.upload_stream(
        {
          folder:"talkloop/profile_images",
        },
        (error,result)=>{
          if(error) return reject(error);
          resolve(result);
        }
      );
      streamifier.createReadStream(file.buffer).pipe(stream);
    });
    imageUrl =result.secure_url;
    user.profileImage = imageUrl;

  }

    const allowedUpdates = [
    "username",
    "bio",
    "gender",
    "interests",
    ];

    const updates = Object.keys(data);

    const isValidOperation = updates.every((field) =>
    allowedUpdates.includes(field)
    );

    if (!isValidOperation) {
    throw new AppError("Invalid update fields", 400);
    }
    updates.forEach((field) => {
        user[field] = data[field];
    }); 

  await user.save();

  return user;
},

 async changePassword(userId, data){
    const {oldPassword,newPassword} = data

    const user = await User.findById(userId).select("+password");

    if(!user){
        throw new AppError(
            "user not found",
            404
        )
    }
    const ismatch = await comparePassword(
        oldPassword,
        user.password
    );
    if(!ismatch){
        throw new AppError(
            "Incoreect Password",
            400
        )
    }
    user.password = await hashPassword(newPassword);

    await user.save();
}
}

module.exports = UserService