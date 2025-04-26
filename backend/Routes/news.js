// routes/news.js
import express from 'express';
import axios from 'axios';

const router = express.Router();

router.get('/', async (req, res) => {
  try {
    const { data } = await axios.get('https://newsdata.io/api/1/news', {
      params: {
        apikey:   process.env.NEWSDATA_API_KEY,
        country:  'in',
        language: 'en',
        category: 'domestic,environment,food,health,technology',
      }
    });
    // data.results is an array of { title, description, link, pubDate, ... }
    res.json(data.results);
  } catch (err) {
    console.error('Error fetching news:', err.message);
    res.status(500).json({ error: 'Failed to fetch news' });
  }
});

export default router;
