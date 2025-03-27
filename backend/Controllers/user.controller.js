import { Vonage } from "@vonage/server-sdk";
import { User } from "../Models/user.model.js";
import jwt from "jsonwebtoken";

const vonage = new Vonage({
  apiKey: process.env.VONAGE_API_KEY,  // Set in .env
  apiSecret: process.env.VONAGE_API_SECRET,  // Set in .env
});

// Function to generate OTP
const generateOTP = () => Math.floor(100000 + Math.random() * 900000).toString();

export const sendOTP = async (req, res) => {
  const { phone } = req.body;
  if (!phone) return res.status(400).json({ message: "Phone number is required" });

  const otp = generateOTP();

  try {
    // Store OTP in DB
    await User.findOneAndUpdate({ phone }, { otp }, { upsert: true, new: true });

    // Send OTP via Vonage
    const from = "Vonage"; // You can use your registered sender ID
    const text = `Your OTP is: ${otp}`;

    const response = await vonage.sms.send({ to: phone, from, text });

    if (response.messages[0].status === "0") {
      res.json({ message: "OTP sent successfully", success: true });
    } else {
      res.status(500).json({ message: response.messages[0]["error-text"], success: false });
    }
  } catch (error) {
    console.error("Error Sending OTP:", error);
    res.status(500).json({ message: "Error sending OTP", success: false });
  }
};

export const verifyOTP = async (req, res) => {
    const { phone, otp } = req.body;
  
    const user = await User.findOne({ phone });
  
    if (!user || user.otp !== otp) {
      return res.status(400).json({ message: "Invalid OTP", success: false });
    }
  
    // Mark user as verified
    user.isVerified = true;
    user.otp = null;
    await user.save();
  
    const token = jwt.sign({ phone }, process.env.JWT_SECRET, { expiresIn: "7d" });
  
    res.json({ message: "Login successful", token, success: true });
  };
