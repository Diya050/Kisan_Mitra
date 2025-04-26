// backend/Controllers/weather.controller.js
import fetch from 'node-fetch';  // or 'node:fetch' in Node v18+

export async function getWeather(req, res) {
  const location = req.query.location;
  if (!location) {
    return res.status(400).json({ error: 'location query is required' });
  }

  const apiUrl = `https://api.openweathermap.org/data/2.5/weather`
               + `?q=${encodeURIComponent(location)}`
               + `&units=metric&appid=${process.env.OPENWEATHER_KEY}`;
  const apiRes = await fetch(apiUrl);
  const data   = await apiRes.json();

  if (apiRes.status !== 200) {
    return res.status(apiRes.status).json({ error: data.message });
  }

  res.json({
    location:    data.name,
    temperature: data.main.temp,
    description: data.weather[0].description
  });
}
