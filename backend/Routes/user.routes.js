import express from "express";
import { register, login, getUser, updateUser } from "../Controllers/user.controller.js"
import { upload } from "../Middlewares/multer.middleware.js";  // We will use Multer for handling profileImage uploads

const router = express.Router();

// Register a new user (with optional profile image)
router.post("/register", upload.single("profileImage"), register);

// Login existing user
router.post("/login", login);

// Get user details
router.get("/:id", getUser);

// Update user details (with optional new profile image)
router.put("/:id", upload.single("profileImage"), updateUser);

export default router;
