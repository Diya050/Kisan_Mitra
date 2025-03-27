import mongoose from "mongoose";

const userSchema = new mongoose.Schema({
    name: { type: String, required: true },
    phone: { type: String, unique: true, sparse: true },
    profileImage: { type: String },  // Cloudinary URL
    location: { type: String },  // User's location for weather/news
    city: {type: String},
    state: {type: String},
    verificationStatus: { type: Boolean, default: false },
    createdAt: { type: Date, default: Date.now },
    crops: {type: [String]},
});

export const User = mongoose.model("User", userSchema);