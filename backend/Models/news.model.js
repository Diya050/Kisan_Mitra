import mongoose from "mongoose";

const newsSchema = new mongoose.Schema({
  title: { type: String, required: true, unique: true },
  content: { type: String, required: true },
  image: { type: String }, // URL to the news image
  author: { type: String, default: 'Admin' },
  category: { type: String, enum: ['Agriculture', 'Technology', 'Weather', 'Market']},
  publishedAt: { type: Date, default: Date.now }
});

export const News = mongoose.model('News', newsSchema);
