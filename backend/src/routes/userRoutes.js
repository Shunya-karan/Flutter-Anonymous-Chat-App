const express = require("express");

const router = express.Router();
const userController = require("../controllers/userController");
const authMiddleware = require("../middleware/authMiddleware");

router.put("/update-profile",authMiddleware,userController.updateProfile);
router.put("/change-password",authMiddleware,userController.changePassword)


module.exports = router;