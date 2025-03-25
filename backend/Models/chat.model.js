import mongoose from "mongoose";

const chatSchema = new mongoose.Schema({
    userId: { type: mongoose.Schema.Types.ObjectId, ref: "User", required: true },
    messages: [
      {
        sender: { type: String, enum: ["User", "AI"], required: true },
        text: { type: String },
        image: { type: String },  // Cloudinary URL if applicable
        timestamp: { type: Date, default: Date.now }
      }
    ]
});

export const User = mongoose.model("chat", chatSchema);