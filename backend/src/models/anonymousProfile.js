const mongoose =require('mongoose');

const anonymouseProfileSchema = new mongoose.Schema({
    user:{
        type: mongoose.Schema.Types.ObjectId,
        ref: "User",
        required: true,
        unique: true
    },
    displayName:{
        type:String,
        required:true,
        unique:true,
        trim:true
    },
    avatar:{
        type:String,
        required:true
    },

},
{
    timestamps:true
}

);

const AnonymousProfile= mongoose.model(
    "anonymouseProfile",
    anonymouseProfileSchema
);

module.exports = AnonymousProfile;