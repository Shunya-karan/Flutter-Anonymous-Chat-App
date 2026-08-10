const AnonymousProfile = require('../models/anonymousProfile.js');
const { generateDisplayName } = require('../utils/displayNameGenerator.js');
const AppError = require('../errors/AppError.js');


async function getAnonymousProfile(userId) {
    const profile = await AnonymousProfile.findOne({
        user: userId,
    }).select("displayName avatar -_id");

    if (!profile) {
        throw new AppError("Anonymous profile not found.", 404);
    }

    return profile
}
//generateDisplayName
async function generateUniquedisplayName() {
    let displayName;
    let exists = true;

    while (exists) {
        displayName = generateDisplayName();
        exists = await AnonymousProfile.exists({
            displayName,
        });

    }
    return displayName;
};
//createAnonymousProfile
async function createAnonymousProfile(userId, displayName, avatar) {

    const exists = await AnonymousProfile.exists({ displayName });

    if (exists) {
        throw new AppError("Display name already taken.", 409);
    }

    const anonymousProfile = await AnonymousProfile.create({
        user: userId,
        displayName,
        avatar
    })
    return anonymousProfile;
}

async function updateAnonymousProfile(userId, displayName, avatar) {

    const anonymousProfile = await AnonymousProfile.findOne({ user: userId });

    if (!anonymousProfile) {
        throw new AppError("Anonymous profile not found.", 404);
    }

    const exists = await AnonymousProfile.findOne({
        displayName,
        _id: { $ne: anonymousProfile._id },
    });

    if (exists) {
        throw new AppError("Display name already taken.", 409);
    }

    anonymousProfile.displayName = displayName;
    anonymousProfile.avatar = avatar;

    await anonymousProfile.save();

    return anonymousProfile;
}

module.exports = {
    getAnonymousProfile,
    generateUniquedisplayName,
    createAnonymousProfile,
    updateAnonymousProfile,
};