
import dotenv from 'dotenv'
import { app } from "./app.js";
import express from "express";
import cors from "cors";

dotenv.config()
const app = express();
app.use(cors());
app.use(express.json());

app.get("/data", (req, res) => {
    res.json({ message: "Hello, Farmers!" });
});

const PORT = process.env.port || 3000;
app.listen(PORT, () => {
    console.log(`Server running on http://localhost:${PORT}`);
});
