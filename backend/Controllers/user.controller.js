import { v2 as cloudinary } from "cloudinary";
import bcrypt from "bcrypt";
import { User } from "../Models/user.model.js";
import dotenv from "dotenv";
dotenv.config();

// Cloudinary config
cloudinary.config({
  cloud_name: process.env.CLOUD_NAME,
  api_key: process.env.API_KEY,
  api_secret: process.env.API_SECRET,
});

// REGISTER Controller
export const register = async (req, res) => {
  try {
    const { username, password, location, city, state, crops, soilType, soilPhLevel, farmingPreference, farmSize } = req.body;

    if (!username || !password) {
      return res.status(400).json({ message: "Username and Password are required" });
    }

    // Check if user already exists
    const existingUser = await User.findOne({ username });
    if (existingUser) {
      return res.status(400).json({ message: "User already exists" });
    }

    // Handle profile image if provided
    let profileImageUrl = "";
    if (req.file) {
      const result = await cloudinary.uploader.upload(req.file.path, {
        folder: "user_profiles",
      });
      profileImageUrl = result.secure_url;
    }

    // Hash password
    const hashedPassword = await bcrypt.hash(password, 10);

    // Create new user
    const newUser = new User({
      username,
      password: hashedPassword,
      profileImage: profileImageUrl,
      location,
      city,
      state,
      crops,
      soilType,
      soilPhLevel,
      farmingPreference,
      farmSize,
    });

    await newUser.save();

    res.status(201).json({ message: "User registered successfully", user: newUser });
  } catch (error) {
    console.error("Register Error:", error);
    res.status(500).json({ message: "Server error during registration" });
  }
};

// LOGIN Controller
export const login = async (req, res) => {
  try {
    const { username, password } = req.body;

    if (!username || !password) {
      return res.status(400).json({ message: "Username and Password are required" });
    }

    const user = await User.findOne({ username });
    if (!user) {
      return res.status(400).json({ message: "User not found" });
    }

    if (!user.password) {
      return res.status(400).json({ message: "Password not set for this user" });
    }

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(400).json({ message: "Invalid credentials" });
    }

    res.status(200).json({ 
      message: "Login successful", 
      user: {
        id: user._id,
        username: user.username,
        profileImage: user.profileImage,
        location: user.location,
        city: user.city,
        state: user.state,
        crops: user.crops,
        soilType: user.soilType,
        soilPhLevel: user.soilPhLevel,
        farmingPreference: user.farmingPreference,
        farmSize: user.farmSize,
      }
    });
  } catch (error) {
    console.error("Login Error:", error);
    res.status(500).json({ message: "Server error during login" });
  }
};


export const getUser = async (req, res) => {
  try {
      const userId = req.params.id;

      const user = await User.findById(userId).select("-password"); // Exclude password

      if (!user) {
          return res.status(404).json({ message: "User not found" });
      }

      res.status(200).json(user);
  } catch (error) {
      console.error(error);
      res.status(500).json({ message: "Server error fetching user" });
  }
};

export const updateUser = async (req, res) => {
  try {
      const userId = req.params.id;

      let updateData = { ...req.body };

      // If a new profile image is uploaded
      if (req.file) {
          const result = await cloudinary.uploader.upload(req.file.path, {
              folder: "user_profiles",
          });
          updateData.profileImage = result.secure_url;
      }

      const updatedUser = await User.findByIdAndUpdate(userId, updateData, { new: true }).select("-password");

      if (!updatedUser) {
          return res.status(404).json({ message: "User not found" });
      }

      res.status(200).json({ message: "User updated successfully", user: updatedUser });
  } catch (error) {
      console.error(error);
      res.status(500).json({ message: "Server error updating user" });
  }
};
