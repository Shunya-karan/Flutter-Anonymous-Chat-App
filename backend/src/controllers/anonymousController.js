const AppError = require("../errors/AppError.js");
const User=require("../models/User");
const { createAnonymousProfile,generateUniquedisplayName } = require("../services/anonymousServices.js");

//generateNanoymousName
const generateAnonymousName = async (req, res,next) => {
  try {
    const displayName = await generateUniquedisplayName();

    return res.status(200).json({
      success: true,
      displayName,
    });
  } catch (error) {
    next(error);
  }
};

//createAnonymousProfile

const generateAnonymousProfile = async(req,res,next)=>{
    try{
        const userId = req.user.id;
        const {displayName}=req.body;

        if(!displayName){
            throw new AppError("displayName is required",400);
        }

        const anonymousProfile = await createAnonymousProfile(
            userId,
            displayName
        );

        await User.findByIdAndUpdate(userId, {
            anonymousProfile: anonymousProfile._id,
        });

        return res.status(201).json({
            success: true,
            message: "Anonymous profile created successfully.",
            anonymousProfile,
        });

    }catch(error){
        next(error);
    }

}
module.exports={
    generateAnonymousName,
    generateAnonymousProfile
}