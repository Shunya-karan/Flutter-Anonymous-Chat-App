const User = require("../models/User");
const AppError = require("../errors/AppError");
const comparePassword = require("../utils/comparePassword");
const hashPassword = require("../utils/hashPassword");

const updateProfile = async (userId, data) => {

  const user = await User.findById(userId);

  if (!user) {
    throw new AppError("User not found", 404);
  }

    const allowedUpdates = [
    "username",
    "bio",
    "gender",
    "interests",
    "profileImage",
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
};

const changePassword=async(userId, data)=>{
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
module.exports = {
  updateProfile,
  changePassword
};