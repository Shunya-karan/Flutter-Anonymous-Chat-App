const authService = require("../services/authServices")

const register = async (req,res,next) => {
  try {
    const user =
      await authService.registerUser(req.body);

    res.status(201).json({
      success: true,
      message:
        "User registered successfully",
    });

  } catch (error) {
    next(error);
  }
};

const login = async (req, res, next) => {
  try {
    const data = await authService.login(req.body);

    res.status(200).json({
      success: true,
      message: "Login successful",
      data,
    });
  } catch (error) {
    next(error);
  }
};

module.exports = {
  register,
  login
};