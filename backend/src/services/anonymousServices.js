const AnonymousProfile =require('../models/anonymousProfile.js');
const { generateDisplayName } = require( '../utils/displayNameGenerator.js');
const { avatarGenerator } = require('../utils/avatarGenerator.js');
const AppError = require('../errors/AppError.js');

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

async function createAnonymousProfile(userId, displayName) {
    
    const exists = await AnonymousProfile.exists({ displayName });

    if (exists) {
        throw new AppError("Display name already taken.",409);
    }
    const avatar = avatarGenerator();

    const anonymousProfile = await AnonymousProfile.create({
        user: userId,
        displayName,
        avatar
    })
    return anonymousProfile;
}

module.exports={
    generateUniquedisplayName,
    createAnonymousProfile
}