const jwt = require("jsonwebtoken");
const User = require("../models/User");
const AppError = require("../errors/AppError");

const authMiddleware = async (req, res, next) => {
  try {
    const authHeader = req.headers.authorization;

    if (!authHeader || !authHeader.startsWith("Bearer ")) {
      throw new AppError("Access denied. No token provided.", 401);
    }

    const token = authHeader.split(" ")[1];

    const decoded = jwt.verify(
      token,
      process.env.JWT_SECRET
    );

    const user = await User.findById(decoded.id);

    if (!user) {
      throw new AppError("User not found.", 404);
    }

    req.user = user;

    next();

  } catch (error) {
    next(error);
  }
};

module.exports = authMiddleware;