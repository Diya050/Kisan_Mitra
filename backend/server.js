
import dotenv from 'dotenv'
import {connectDb} from './DB/index.js';
import { app } from "./app.js";
dotenv.config();

const PORT = process.env.port || 3000;
connectDb()
  .then(() => {
    app.listen(PORT, () => {
      console.log("⚙️  Server listening on Port:", PORT);
    });
  })
  .catch((err) => console.log(err));