const reportUserModel = require("../models/reportModel")
const AppError = require("../errors/AppError");


async function reportUserService(userId, reporteduserId, reportReason) {

    if (!reporteduserId || !reportReason) {
        throw new AppError(
            "Reported user and reason are required.",
            400
        )
    }

    if (userId.toString() === reporteduserId.toString()) {
        throw new AppError(
            "You cannot report yourself", 400
        )
    }

    const existingUser = await reportUserModel.findOne({
        reporter: userId,
        reportedUser: reporteduserId,

    });

    if (existingUser) {
        throw new AppError(
            "User already reported", 409
        );
    }

    const report = await reportUserModel.create({
        reporter: userId,
        reportedUser: reporteduserId,
        reason: reportReason
    });
    return report;

};

module.exports = reportUserService