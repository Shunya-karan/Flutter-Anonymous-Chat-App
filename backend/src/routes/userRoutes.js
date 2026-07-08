const express = require("express");

const router = express.Router();
const userController = require("../controllers/userController");
const authMiddleware = require("../middleware/authMiddleware");
const upload = require("../middleware/uploadMiddleware");

router.put("/update-profile",authMiddleware,
    upload.single("profileImage"),
    userController.updateProfile);
router.put("/change-password",authMiddleware,userController.changePassword)


module.exports = router;