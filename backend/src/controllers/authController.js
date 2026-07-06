const authService = require("../services/authServices")



const authController={

async register(req,res,next) {
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
},

async login(req, res, next) {
  try {
    const data = await authService.loginUser(req.body);

    res.status(200).json({
      success: true,
      message: "Login successful",
      data,
    });
  } catch (error) {
    next(error);
  }
},

async getCurrentUser(req, res, next)  {
    try {
        const user = await authService.getCurrentUser(
            req.user._id
        );

        res.status(200).json({
            success: true,
            data: user,
        });

    } catch (error) {
        next(error);
    }
}
}


module.exports = authController