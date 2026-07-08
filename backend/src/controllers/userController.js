const userService = require("../services/userService");

const updateProfile = async (req, res, next) => {
  try {

    const user = await userService.updateProfile(
      req.user._id,
      req.body,
      req.file
    );

    res.status(200).json({
      success: true,
      message: "Profile updated successfully",
      data: user,
    });

  } catch (error) {
    next(error);
  }
};

const changePassword = async (req, res, next) => {
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