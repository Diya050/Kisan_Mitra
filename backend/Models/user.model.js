import mongoose from "mongoose";

const userSchema = new mongoose.Schema({
    username: { type: String, unique: true, required: true },
    password: { type: String, sparse: true },
    profileImage: { type: String }, // Cloudinary URL
    location: { type: String },     // General location info
    city: { type: String },
    state: { type: String },
    createdAt: { type: Date, default: Date.now },
    crops: { type: [String] },       // List of crops the user grows

    // NEW FIELDS
    soilType: { type: String },      // e.g., Clay, Sandy, Loamy (optional)
    soilPhLevel: { type: Number },   // e.g., 6.5, 7.0 (optional)
    farmingPreference: {             // Organic or Chemical (optional)
        type: String,
        enum: ["Organic", "Chemical"],
    },
    farmSize: { type: String },      // e.g., "5 acres" (optional)
});

export const User = mongoose.model("User", userSchema);