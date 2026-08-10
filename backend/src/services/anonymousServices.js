const AnonymousProfile = require('../models/anonymousProfile.js');
const { generateDisplayName } = require('../utils/displayNameGenerator.js');
const {
    checkChangeLimit,
} = require("../utils/profileChangeLimit.js");
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

    const now = new Date();

    //    * Check whether display name actually changed
    const nameChanged =
        displayName !== undefined &&
        displayName.trim() !== anonymousProfile.displayName;

    //  * Check whether avatar actually changed
    const avatarChanged =
        avatar !== undefined &&
        avatar !== anonymousProfile.avatar;

    //  * Nothing changed
    if (!nameChanged && !avatarChanged) {
        return anonymousProfile;
    }


    if (nameChanged) {
        const newDisplayName = displayName.trim();
        const exists = await AnonymousProfile.findOne({
            displayName: newDisplayName,
            _id: { $ne: anonymousProfile._id },
        });

        if (exists) {
            throw new AppError("Display name already taken.", 409);
        }

        const nameLimit = checkChangeLimit(
            anonymousProfile.displayNameChangeDates
        );

        if (!nameLimit.allowed) {
            throw new AppError(
                `You can change your display name again in ${Math.ceil(
                    nameLimit.retryAfter / 3600
                )} hours.`,
                429
            );
        }

        anonymousProfile.displayName = newDisplayName;
        anonymousProfile.displayNameChangeDates = nameLimit.recentChanges;
        anonymousProfile.displayNameChangeDates.push(now);

    }
        if (avatarChanged) {

            const avatarLimit = checkChangeLimit(
                anonymousProfile.avatarChangeDates
            );

            if (!avatarLimit.allowed) {
                throw new AppError(
                    `You can change your avatar again in ${Math.ceil(
                        avatarLimit.retryAfter / 3600
                    )} hours.`,
                    429
                );
            }

            anonymousProfile.avatar = avatar;

            anonymousProfile.avatarChangeDates =
                avatarLimit.recentChanges;

            anonymousProfile.avatarChangeDates.push(
                now
            );
        

    }

    await anonymousProfile.save();

    return anonymousProfile;
}

module.exports = {
    getAnonymousProfile,
    generateUniquedisplayName,
    createAnonymousProfile,
    updateAnonymousProfile,
};