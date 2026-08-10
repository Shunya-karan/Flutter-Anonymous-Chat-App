const reportUserService = require("../services/reportUserService")

async function reportuserController(req, res, next) {
    try {
        const userId = req.user.id;
        const reportuserId = req.params.userId;
        const {reason} = req.body;

        const report = await reportUserService(
            userId,
            reportuserId,
            reason
        )

        res.status(200).json({
            success: true,
            message: "User report successfully",
            data: report,
        });
    } catch (error) {
        next(error)
    }
}

module.exports = reportuserController