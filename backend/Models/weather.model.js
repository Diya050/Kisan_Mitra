const mongoose = require('mongoose');

const weatherSchema = new mongoose.Schema({
  location: { type: String, required: true },
  temperature: { type: Number, required: true }, // in Celsius
  humidity: { type: Number, required: true }, // percentage
  condition: { type: String, required: true }, // e.g., Sunny, Rainy
  windSpeed: { type: Number }, // in km/h
  recordedAt: { type: Date, default: Date.now }
});

export const Weather = mongoose.model('Weather', weatherSchema);
