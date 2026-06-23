const User = require("../models/User");

const hashPassword = require("../utils/hashPassword");

const registerUser = async (userData) => {
  const {username,email,password,interests,} = userData;

  const existingUser =await User.findOne({ email });

  if (existingUser) {
    throw new Error(
      "Email already exists"
    );
  }

  const hashedPassword =await hashPassword(password);

  const user =await User.create({username,email,password: hashedPassword,interests,});
  return user;
};

module.exports = {
  registerUser,
};