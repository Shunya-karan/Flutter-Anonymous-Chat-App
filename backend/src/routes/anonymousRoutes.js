const express = require("express");
const {generateAnonymousName, 
    generateAnonymousProfile, 
    updateAnonymousProfileController, 
    getAnonymousProfileController}=require('../controllers/anonymousController.js');
const authMiddleware = require("../middleware/authMiddleware.js");


const router = express.Router();

router.get('/generate-name',generateAnonymousName);
router.post('/profile',authMiddleware,generateAnonymousProfile)
router.put('/profile',authMiddleware,updateAnonymousProfileController)
router.get('/profile',authMiddleware,getAnonymousProfileController)

module.exports=router;

