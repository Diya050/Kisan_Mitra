import express from "express";
import { sendOTP, verifyOTP } from "../Controllers/user.controller.js";
const userRouter = express.Router();

userRouter.post("/send-otp", sendOTP);
userRouter.post("/verify-otp", verifyOTP);

export default userRouter;
