const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');

const app = express();
const PORT = 5000;

app.use(express.json());
app.use(cors());

// MySQL Database Connection
const db = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: 'root',
    database: 'tracking_db_v2'  // ✅ New database
});


// Connect to MySQL
db.connect((err) => {
    if (err) {
        console.error('❌ MySQL Connection Failed:', err);
    } else {
        console.log('✅ MySQL Connected Successfully!');
    }
});

// ✅ API Route to Store Location & Network Strength Data from Android
app.post('/store-tracking-data', (req, res) => {
    const { latitude, longitude, network_type } = req.body;

    console.log("📩 Incoming Data:", req.body);  // Debugging log

    if (!latitude || !longitude || !network_type) {
        return res.status(400).json({ message: 'Missing required fields', received: req.body });
    }

    const query = 'INSERT INTO tracking_data_v2 (latitude, longitude, network_type) VALUES (?, ?, ?)';
    db.query(query, [latitude, longitude, network_type], (err, result) => {
        if (err) {
            console.error('❌ Error inserting data:', err);
            return res.status(500).json({ message: 'Database error' });
        }
        res.status(201).json({ message: '✅ Tracking data stored successfully!' });
    });
});


// ✅ API Route to Retrieve Stored Location & Network Strength Data
// ✅ API to Retrieve Stored Location & Network Type Data
app.get('/get-tracking-data', (req, res) => {
    db.query('SELECT * FROM tracking_data_v2 ORDER BY timestamp DESC', (err, results) => {
        if (err) {
            console.error('❌ Error fetching data:', err);
            return res.status(500).json({ message: 'Database error' });
        }
        res.status(200).json(results);
    });
});


// Start the Server
app.listen(PORT, () => {
    console.log(`🚀 Server is running on http://localhost:${PORT}`);
});
