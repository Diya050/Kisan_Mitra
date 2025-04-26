import express from 'express';
import cookieParser from 'cookie-parser';
import cors from 'cors';
import newsRouter from './Routes/news.js';
import userRouter from './Routes/user.routes.js';
import weatherRoutes from './Routes/weather.routes.js';

const app = express();

// Configure CORS
app.use(cors({
  origin: '*', // Replace with your frontend domain or use '*' for allowing all
  methods: ['GET', 'POST', 'PUT', 'DELETE'], // Define allowed HTTP methods
  credentials: true, // Allow credentials (cookies, authorization headers, etc.)
}));

app.get("/data", (req, res) => {
    res.json({ message: "Hello, Farmers!" });
});

app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(cookieParser());

app.use('/weather', weatherRoutes);
app.use("/api/v1/news/", newsRouter);
app.use("/api/v1/user/", userRouter);

app._router.stack
  .filter(r => r.route && r.route.path)
  .forEach(r => console.log(`Route: [${Object.keys(r.route.methods)[0].toUpperCase()}] ${r.route.path}`));

export { app };
