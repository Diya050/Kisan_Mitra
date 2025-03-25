const WeatherSchema = new mongoose.Schema({
    location: { type: String, required: true },
    temperature: { type: Number, required: true },
    humidity: { type: Number, required: true },
    conditions: { type: String, required: true },
    forecast: { type: String },  // Future forecast details
    timestamp: { type: Date, default: Date.now }
  });
  