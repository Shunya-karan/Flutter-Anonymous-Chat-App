const mongoose = require("mongoose");

const blockedUserSchema = new mongoose.Schema(
    {
        user: {
            type: mongoose.Schema.Types.ObjectId,
            ref: "User",
            required: true,
        },

        blockedUser: {
            type: mongoose.Schema.Types.ObjectId,
            ref: "User",
            required: true,
        },
    },
    {
        timestamps: true,
    }
);

blockedUserSchema.index(
    { user: 1, blockedUser: 1 },
    { unique: true }
);

const blockedUserModel = mongoose.model(
    "BlockedUser",
    blockedUserSchema
);

module.exports = blockedUserModel;