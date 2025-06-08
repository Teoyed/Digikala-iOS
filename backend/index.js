require('dotenv').config();
const express = require('express');
const mysql = require('mysql2/promise');
const cors = require('cors');

const app = express();
app.use(cors());
app.use(express.json());

const pool = mysql.createPool({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0
});

// Test connection
app.get('/api/ping', async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT 1');
    res.json({ success: true });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Get all products
app.get('/api/products', async (req, res) => {
     try {
       const [rows] = await pool.query('SELECT * FROM products');
       res.json(rows);
     } catch (err) {
       res.status(500).json({ error: err.message });
     }
   });

const port = process.env.PORT || 3000;
app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});