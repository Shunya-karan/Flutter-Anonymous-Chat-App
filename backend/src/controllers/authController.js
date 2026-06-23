const authService = require("../services/authServices")

const register = async (req,res,next
) => {
  try {
    const user =
      await authService.registerUser(
        req.body
      );

    res.status(201).json({
      success: true,
      message:
        "User registered successfully",
      data: user,
    });

  } catch (error) {
    res.status(500).json({
      success: false,
      message:error.message
    });
  }
};

module.exports = {
  register,
};