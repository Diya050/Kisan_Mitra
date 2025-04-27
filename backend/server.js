
import dotenv from 'dotenv'
import express from 'express';
import {connectDb} from './DB/index.js';
import { app } from "./app.js";
import newsRoutes from './Routes/news.js';


const PORT = process.env.port || 3000;

dotenv.config();


app.use('/news', newsRoutes);

connectDb()
  .then(() => {
    app.listen(PORT, () => {
      console.log("⚙️  Server listening on Port:", PORT);
    });
  })
  .catch((err) => console.log(err));