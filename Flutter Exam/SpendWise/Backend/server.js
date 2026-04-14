const express = require('express');
const cors    = require('cors');
require('dotenv').config();

const expenseRoutes = require('./routes/expenses');
const authRoutes    = require('./routes/auth');
const pool          = require('./db');

const app  = express();
const PORT = parseInt(process.env.PORT || '3000', 10);

// ── Middleware ────────────────────────────────────────────────────────────────
app.use(cors());
app.use(express.json());

// ── Routes ────────────────────────────────────────────────────────────────────
app.use('/api/auth',     authRoutes);
app.use('/api/expenses', expenseRoutes);

app.get('/health', (_req, res) => res.json({ status: 'ok', service: 'SpendWise API' }));

// ── Ensure users table exists ─────────────────────────────────────────────────
async function ensureUsersTable(conn) {
  await conn.query(`
    CREATE TABLE IF NOT EXISTS users (
      id            INT           AUTO_INCREMENT PRIMARY KEY,
      name          VARCHAR(100)  NOT NULL,
      email         VARCHAR(255)  NOT NULL UNIQUE,
      password_hash VARCHAR(255)  NOT NULL,
      created_at    TIMESTAMP     DEFAULT CURRENT_TIMESTAMP
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
  `);
}

// ── Start ─────────────────────────────────────────────────────────────────────
async function start() {
  try {
    const conn = await pool.getConnection();
    await ensureUsersTable(conn);
    conn.release();
    console.log('✅ MySQL connected — users table ready');

    app.listen(PORT, () => {
      console.log(`🚀 SpendWise API running → http://localhost:${PORT}`);
      console.log(`   Auth:     http://localhost:${PORT}/api/auth`);
      console.log(`   Expenses: http://localhost:${PORT}/api/expenses`);
    });
  } catch (err) {
    console.error('❌ Failed to connect to MySQL:', err.message);
    console.error('   Make sure MySQL is running and .env credentials are correct.');
    process.exit(1);
  }
}

start();
