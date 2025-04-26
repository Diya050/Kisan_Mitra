// backend/Routes/weather.routes.js
import express from 'express';
import { getWeather } from '../Controllers/weather.controller.js';
const router = express.Router();

router.get('/', getWeather);

export default router;
