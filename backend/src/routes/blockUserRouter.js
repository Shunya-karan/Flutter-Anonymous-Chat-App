const express = require("express");
const router = express.Router();

const blockuserController = require("../controllers/blockUserController");
const authMiddleware = require("../middleware/authMiddleware");


router.post("/:userId",authMiddleware,blockuserController);

module.exports = router;