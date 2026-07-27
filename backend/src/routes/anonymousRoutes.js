const express = require("express");
const {generateAnonymousName, generateAnonymousProfile}=require('../controllers/anonymousController.js');
const authMiddleware = require("../middleware/authMiddleware.js");

const router = express.Router();

router.get('/generate-name',generateAnonymousName);
router.post('/create-anonymous-profile',authMiddleware,generateAnonymousProfile)

module.exports=router;

