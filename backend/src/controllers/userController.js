const userService = require("../services/userService");

async function updateProfile(req, res, next){
  try {

    const user = await userService.updateProfile(
      req.user._id,
      req.body,
      req.file
    );

    res.status(201).json({
      success: true,
      message: "Profile updated successfully",
      data: user,
    });

  } catch (error) {
    next(error);
  }
};

async function changePassword (req, res, next){
    try {

        await userService.changePassword(req.user._id,req.body);

        res.status(200).json({
            success: true,
            message: "Password changed successfully",
        });

    } catch (error) {
        next(error);
    }
};
module.exports = {
  updateProfile,
  changePassword
};