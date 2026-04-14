const express = require('express');
const cors = require('cors');
require('dotenv').config();

const expenseRoutes = require('./routes/expenses');
const authRoutes = require('./routes/auth');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

app.get("/", (req, res) => {
  res.send("SpendWise API running 🚀");
});

app.use('/api/auth', authRoutes);
app.use('/api/expenses', expenseRoutes);

app.get('/health', (_req, res) =>
  res.json({ status: 'ok', service: 'SpendWise API' })
);

app.listen(PORT, () => {
  console.log(`🚀 SpendWise API running on port ${PORT}`);
});