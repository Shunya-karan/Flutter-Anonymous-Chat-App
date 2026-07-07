const User = require("../models/User");
const AppError = require("../errors/AppError")
const hashPassword = require("../utils/hashPassword");
const comparePassword = require("../utils/comparePassword");
const generateToken = require("../utils/genrateToken");


const authService={

  async registerUser(userData)  {
  const {username,email,password,interests,bio,gender,profileImage,
} = userData;

  const existingEmail =await User.findOne({ email });

  if (existingEmail) {
    throw new AppError("Email already exists",409);
  }
  const existingUser =await User.findOne({ username });

    if (existingUser) {throw new AppError("User already exists",409);
  }

  const hashedPassword =await hashPassword(password);

  const user =await User.create({username,email,password: hashedPassword,interests,bio,gender,profileImage});
  return user;
},

  async loginUser({ identifier, password })  {

  const user = await User.findOne({
  $or:[
  {email:identifier},
  {username:identifier}
  ]
  }).select("+password");

  if (!user) {
    throw new AppError("Invalid credential", 401);
  }

  // Compare password
  const isMatch = await comparePassword(
    password,
    user.password
  );

  if (!isMatch) {
    throw new AppError("Invalid credentials", 401);
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
},

  async getCurrentUser(userId)  {
    const user = await User.findById(userId);

    if (!user) {
        throw new AppError("User not found",404);
    }

    return user;
}
}

module.exports = authService
