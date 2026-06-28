const User = require("../models/User");
const AppError = require("../errors/AppError")
const hashPassword = require("../utils/hashPassword");
const comparePassword = require("../utils/comparePassword");
const generateToken = require("../utils/genrateToken");

const registerUser = async (userData) => {
  const {username,email,password,interests,bio,gender,profileImage,
} = userData;

  const existingUser =await User.findOne({ email });

  if (existingUser) {
    throw new AppError(
      "Email already exists",
      409
    );
  }

  const hashedPassword =await hashPassword(password);

  const user =await User.create({username,email,password: hashedPassword,interests,bio,gender,profileImage});
  return user;
};


const login = async ({ email, password }) => {

  const user = await User.findOne({ email }).select("+password");
  if (!user) {
    throw new AppError("Invalid email or password", 401);
  }

  // Compare password
  const isMatch = await comparePassword(
    password,
    user.password
  );

  if (!isMatch) {
    throw new AppError("Invalid email or password", 401);
  }

  // Generate JWT
  const token = generateToken(user._id);

  return {
    token,
    user: {
      id: user._id,
      username: user.username,
      email: user.email,
      interests: user.interests,
    },
  };
};

const getCurrentUser = async (userId) => {
    const user = await User.findById(userId);

    if (!user) {
        throw new AppError("User not found",404);
    }

    return user;
};



module.exports = {
  registerUser,
  login,
  getCurrentUser
};
