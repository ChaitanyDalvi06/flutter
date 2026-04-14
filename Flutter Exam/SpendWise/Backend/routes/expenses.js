const express = require('express');
const router  = express.Router();
const pool    = require('../db');

// ── Utilities ────────────────────────────────────────────────────────────────

/** Normalise a row: ensure amount is a JS number, not a DECIMAL string. */
function normalise(row) {
  return { ...row, amount: parseFloat(row.amount) };
}

// ── GET /api/expenses ─────────────────────────────────────────────────────────
// Query params (all optional):
//   year, month      → filter by calendar month
//   from, to         → ISO date-range filter
router.get('/', async (req, res) => {
  try {
    const { year, month, from, to } = req.query;
    let sql  = 'SELECT * FROM expenses';
    const params = [];

    if (year && month) {
      // e.g. "2026-03" — ISO strings start with YYYY-MM so LEFT(date,7) works
      const m = String(month).padStart(2, '0');
      sql += ' WHERE LEFT(date, 7) = ?';
      params.push(`${year}-${m}`);
    } else if (from && to) {
      sql += ' WHERE date >= ? AND date <= ?';
      params.push(from, to);
    } else if (from) {
      sql += ' WHERE date >= ?';
      params.push(from);
    } else if (to) {
      sql += ' WHERE date <= ?';
      params.push(to);
    }

    sql += ' ORDER BY date DESC';

    const [rows] = await pool.query(sql, params);
    res.json(rows.map(normalise));
  } catch (err) {
    console.error('GET /expenses error:', err);
    res.status(500).json({ error: err.message });
  }
});

// ── GET /api/expenses/total ───────────────────────────────────────────────────
// Query param: type ('expense' | 'income')
router.get('/total', async (req, res) => {
  try {
    const { type } = req.query;
    if (!type) return res.status(400).json({ error: 'type param required' });

    const [rows] = await pool.query(
      'SELECT SUM(amount) AS total FROM expenses WHERE type = ?',
      [type],
    );
    res.json({ total: parseFloat(rows[0].total) || 0 });
  } catch (err) {
    console.error('GET /expenses/total error:', err);
    res.status(500).json({ error: err.message });
  }
});

// ── GET /api/expenses/analytics/category-totals ───────────────────────────────
// Query params: type (required), from (optional ISO), to (optional ISO)
router.get('/analytics/category-totals', async (req, res) => {
  try {
    const { type, from, to } = req.query;
    if (!type) return res.status(400).json({ error: 'type param required' });

    let sql = 'SELECT category, SUM(amount) AS total FROM expenses WHERE type = ?';
    const params = [type];

    if (from) { sql += ' AND date >= ?'; params.push(from); }
    if (to)   { sql += ' AND date <= ?'; params.push(to);   }

    sql += ' GROUP BY category ORDER BY total DESC';

    const [rows] = await pool.query(sql, params);
    res.json(rows.map(r => ({ ...r, total: parseFloat(r.total) })));
  } catch (err) {
    console.error('GET /analytics/category-totals error:', err);
    res.status(500).json({ error: err.message });
  }
});

// ── GET /api/expenses/analytics/monthly-totals ────────────────────────────────
// Query param: months (default 6)
router.get('/analytics/monthly-totals', async (req, res) => {
  try {
    const months = parseInt(req.query.months || '6', 10);
    // Get cutoff date as ISO string (approximate 30 days per month)
    const from = new Date(Date.now() - months * 30 * 24 * 60 * 60 * 1000)
      .toISOString();

    const [rows] = await pool.query(
      `SELECT LEFT(date, 7) AS month, type, SUM(amount) AS total
       FROM expenses
       WHERE date >= ?
       GROUP BY month, type
       ORDER BY month ASC`,
      [from],
    );
    res.json(rows.map(r => ({ ...r, total: parseFloat(r.total) })));
  } catch (err) {
    console.error('GET /analytics/monthly-totals error:', err);
    res.status(500).json({ error: err.message });
  }
});

// ── GET /api/expenses/analytics/daily-totals ─────────────────────────────────
// Query param: days (default 30)
router.get('/analytics/daily-totals', async (req, res) => {
  try {
    const days = parseInt(req.query.days || '30', 10);
    const from = new Date(Date.now() - days * 24 * 60 * 60 * 1000).toISOString();

    const [rows] = await pool.query(
      `SELECT LEFT(date, 10) AS day, type, SUM(amount) AS total
       FROM expenses
       WHERE date >= ?
       GROUP BY day, type
       ORDER BY day ASC`,
      [from],
    );
    res.json(rows.map(r => ({ ...r, total: parseFloat(r.total) })));
  } catch (err) {
    console.error('GET /analytics/daily-totals error:', err);
    res.status(500).json({ error: err.message });
  }
});

// ── POST /api/expenses ────────────────────────────────────────────────────────
router.post('/', async (req, res) => {
  try {
    const { title, amount, category, date, type, notes } = req.body;

    if (!title || amount == null || !category || !date || !type) {
      return res.status(400).json({ error: 'Missing required fields' });
    }

    const [result] = await pool.query(
      'INSERT INTO expenses (title, amount, category, date, type, notes) VALUES (?, ?, ?, ?, ?, ?)',
      [title, parseFloat(amount), category, date, type, notes ?? null],
    );

    res.status(201).json({ id: result.insertId });
  } catch (err) {
    console.error('POST /expenses error:', err);
    res.status(500).json({ error: err.message });
  }
});

// ── PUT /api/expenses/:id ─────────────────────────────────────────────────────
router.put('/:id', async (req, res) => {
  try {
    const id = parseInt(req.params.id, 10);
    const { title, amount, category, date, type, notes } = req.body;

    const [result] = await pool.query(
      'UPDATE expenses SET title=?, amount=?, category=?, date=?, type=?, notes=? WHERE id=?',
      [title, parseFloat(amount), category, date, type, notes ?? null, id],
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({ error: 'Expense not found' });
    }
    res.json({ updated: result.affectedRows });
  } catch (err) {
    console.error('PUT /expenses/:id error:', err);
    res.status(500).json({ error: err.message });
  }
});

// ── DELETE /api/expenses/:id ──────────────────────────────────────────────────
router.delete('/:id', async (req, res) => {
  try {
    const id = parseInt(req.params.id, 10);
    const [result] = await pool.query('DELETE FROM expenses WHERE id = ?', [id]);

    if (result.affectedRows === 0) {
      return res.status(404).json({ error: 'Expense not found' });
    }
    res.json({ deleted: result.affectedRows });
  } catch (err) {
    console.error('DELETE /expenses/:id error:', err);
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
