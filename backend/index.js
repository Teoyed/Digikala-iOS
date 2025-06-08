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

// GET Cart (Fetch all items in the cart dynamically from the database)
app.get('/api/cart', (req, res) => {
    const query = `
        SELECT
            ci.id,
            ci.product_id,
            ci.quantity,
            p.id AS product_id_actual,
            p.name,
            p.price,
            p.manufacturer,
            p.image_url,
            p.category,
            p.description
        FROM
            cart_items ci
        JOIN
            products p ON ci.product_id = p.id;
    `;

    pool.query(query)
        .then(([results]) => {
            // Map the database results to match your Swift CartItem structure
            const cartItems = results.map(row => ({
                id: row.id,
                productId: row.product_id, // This should match the productId in your Swift CartItem
                quantity: row.quantity,
                product: {
                    id: row.product_id_actual || row.product_id, // Ensure this matches your Swift Product.id
                    name: row.name,
                    price: String(row.price), // Ensure price is sent as a string as per your Swift model
                    manufacturer: row.manufacturer,
                    imageURL: row.image_url,
                    category: row.category,
                    description: row.description
                }
            }));

            // Send the cart data in the format expected by your Swift app
            res.json({ items: cartItems });
        })
        .catch((err) => {
            console.error('Error fetching cart from database:', err);
            // Send a 500 error and a clear message to the client
            res.status(500).json({ message: 'Failed to fetch cart items from database.' });
        });
});

// POST Add to Cart
app.post('/api/cart', (req, res) => {
    // Log the received body to see what the app is sending
    console.log('Received add to cart request body:', req.body);

    const { product_id, quantity } = req.body; // Ensure these names match what Swift sends

    // IMPORTANT: Add validation here (e.g., if product_id or quantity are missing/invalid)
    if (!product_id || quantity === undefined) {
        return res.status(400).json({ message: 'Missing product_id or quantity' });
    }

    const query = 'INSERT INTO cart_items (product_id, quantity) VALUES (?, ?) ON DUPLICATE KEY UPDATE quantity = quantity + VALUES(quantity)';
    // This query inserts if the item is new, or adds to quantity if it already exists.

    pool.query(query, [product_id, quantity])
        .then(([result]) => {
            if (result.affectedRows === 0) {
                console.error('Error adding to cart:', new Error('No rows affected'));
                return res.status(500).json({ message: 'Error adding to cart' });
            }
            console.log('Item added/updated in cart:', result); // Log success
            res.status(200).json({ message: 'Item added to cart', cartItemId: result.insertId });
        })
        .catch((err) => {
            console.error('MySQL Error adding to cart:', err); // Log specific MySQL error
            res.status(500).json({ message: 'Error adding to cart' });
        });
});

const port = process.env.PORT || 3000;
app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});