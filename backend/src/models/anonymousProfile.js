const mongoose = require("mongoose");

const anonymousProfileSchema = new mongoose.Schema(
  {
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
      unique: true,
    },

    displayName: {
      type: String,
      required: true,
      unique: true,
      trim: true,
    },

    avatar: {
      type: String,
      required: true,
    },

    // Display name changes in the last 24 hours
    displayNameChangeDates: {
      type: [Date],
      default: [],
    },

    // Avatar changes in the last 24 hours
    avatarChangeDates: {
      type: [Date],
      default: [],
    },
  },
  {
    timestamps: true,
  }
);

const AnonymousProfile = mongoose.model(
  "anonymousprofiles",
  anonymousProfileSchema
);

module.exports = AnonymousProfile;