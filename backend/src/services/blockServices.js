const blockedUserModel = require("../models/blockUserModel")
const AppError = require("../errors/AppError");


async function blockedUserService(userId, blockeduserId) {
    if (userId.toString() === blockeduserId.toString()) {
        throw new AppError(
            "You cannot block yourself", 400
        )
    }

    const existingUser = await blockedUserModel.findOne({
        user:userId, 
        blockedUser:blockeduserId
    });

    if (existingUser) {
        throw new AppError(
            "User already block", 409
        );
    }

    const blocked =await blockedUserModel.create({
        user:userId,
        blockedUser:blockeduserId
    });
    return blocked;

};

module.exports = blockedUserService