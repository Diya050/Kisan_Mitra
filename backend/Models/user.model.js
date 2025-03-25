import mongoose from "mongoose";

const userSchema = new mongoose.Schema({
    name: { type: String, required: true },
    email: { type: String, unique: true, sparse: true },
    phone: { type: String, unique: true, sparse: true },
    password: { type: String, required: true },  // Hashed password
    profileImage: { type: String },  // Cloudinary URL
    role: { type: String, enum: ["Farmer", "Admin"], default: "Farmer" },
    location: { type: String },  // User's location for weather/news
    verificationStatus: { type: Boolean, default: false },
    settings: { 
        language: { type: String, default: "en" }, 
        notificationsEnabled: { type: Boolean, default: true } 
    },
    createdAt: { type: Date, default: Date.now },
    });

    export const User = mongoose.model("User", userSchema);