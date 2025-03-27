import express from "express";
import { sendOTP, verifyWhatsAppOTP } from "../Controllers/user.controller.js";
const userRouter = express.Router();

userRouter.post("/send-otp", sendOTP);
userRouter.post("/verify-otp", verifyWhatsAppOTP);

export default userRouter;
