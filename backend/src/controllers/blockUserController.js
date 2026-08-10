const blockedUserService = require("../services/blockServices")

async function blockuserController(req, res, next) {
    try {
        const userId = req.user.id;
        const blockeduserId = req.params.userId;

        const blocked = await blockedUserService(
            userId,
            blockeduserId
        )

        res.status(200).json({
            success: true,
            message: "User Blocked successfully",
            data: blocked,
        });
    } catch (error) {
        next(error)
    }
}

module.exports = blockuserController