const AppError = require("../errors/AppError.js");
const User = require("../models/User");
const { getAnonymousProfile,createAnonymousProfile, generateUniquedisplayName, updateAnonymousProfile } = require("../services/anonymousServices.js");


const getAnonymousProfileController = async (req, res, next) => {
    try {
        const userId = req.user.id;
        const profile = await getAnonymousProfile(userId)
        return res.status(200).json({
            success:true,
            profile,

        })
    }catch(error){
        next(error)
    }
    
}
//generateNanoymousName
const generateAnonymousName = async (req, res, next) => {
    try {
        const displayName = await generateUniquedisplayName();

        return res.status(200).json({
            success: true,
            displayName,
        });
    } catch (error) {
        next(error);
    }
};

//createAnonymousProfile

const generateAnonymousProfile = async (req, res, next) => {
    try {
        const userId = req.user.id;
        const { displayName, avatar } = req.body;

        if (!displayName || !avatar) {
            throw new AppError("displayName and avatar is required", 400);
        }

        const anonymousProfile = await createAnonymousProfile(
            userId,
            displayName,
            avatar
        );

        await User.findByIdAndUpdate(userId, {
            anonymousProfile: anonymousProfile._id,
        });

        return res.status(201).json({
            success: true,
            message: "Anonymous profile created successfully.",
            anonymousProfile,
        });

    } catch (error) {
        next(error);
    }

}

//updateAnonymousProfile
const updateAnonymousProfileController = async (req, res, next) => {
    try {
        const userId = req.user.id;
        const { displayName, avatar } = req.body;

        const profile = await updateAnonymousProfile(userId, displayName, avatar);

        return res.status(200).json({
            success: true,
            message: "Anonymous profile updated successfully.",
            anonymousProfile: profile,
        });
    } catch (error) {
        next(error);
    }
};

module.exports = {
    getAnonymousProfileController,
    generateAnonymousName,
    generateAnonymousProfile,
    updateAnonymousProfileController
}