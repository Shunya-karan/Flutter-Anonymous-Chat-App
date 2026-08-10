const express = require("express");
const router = express.Router();

const reportuserController = require("../controllers/reportUserController");
const authMiddleware = require("../middleware/authMiddleware");


router.post("/:userId",authMiddleware,reportuserController);

module.exports = router;