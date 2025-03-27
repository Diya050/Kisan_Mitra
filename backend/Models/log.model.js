import mongoose from "mongoose";

const userLogSchema = new mongoose.Schema({
    userId: { type: mongoose.Schema.Types.ObjectId, ref: "User", required: true }, // Reference to User
    action: { type: String, required: true }, // e.g., "Login", "Viewed News", "Submitted Query"
    timestamp: { type: Date, default: Date.now } // Auto-generated timestamp
});

export const UserLog = mongoose.model("UserLog", userLogSchema);
