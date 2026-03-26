const express = require('express');
const cors = require('cors');
require('dotenv').config();
const articleRoutes = require('./routes/articles');

const app = express();

// Middleware
app.use(express.json());
app.use(cors({
  origin: [
    http://47.128.239.61:5000/api/articles
    process.env.AMPLIFY_URL || 'https://main.d1ynnrlj3b1zmq.amplifyapp.com/'
  ],
  credentials: true
}));

// Routes
app.use('/api', articleRoutes);

// Health check
app.get('/health', (req, res) => {
  res.json({ status: 'Backend is running!' });
});

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
