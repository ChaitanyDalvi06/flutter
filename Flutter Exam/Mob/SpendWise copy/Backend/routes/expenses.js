const express  = require('express');
const router   = express.Router();
const supabase = require('../db');
const authenticateToken = require('../middleware/auth');

// All expense routes require a valid JWT
router.use(authenticateToken);

// Helper: ensure amount is a JS number
function normalise(row) {
  return { ...row, amount: parseFloat(row.amount) };
}

// GET /api/expenses
// Query params (all optional): year, month, from, to
router.get('/', async (req, res) => {
  try {
    const userId = req.user.id;
    const { year, month, from, to } = req.query;

    let query = supabase
      .from('expenses')
      .select('*')
      .eq('user_id', userId)
      .order('date', { ascending: false });

    if (year && month) {
      const m = String(month).padStart(2, '0');
      query = query.like('date', `${year}-${m}%`);
    } else if (from && to) {
      query = query.gte('date', from).lte('date', to);
    } else if (from) {
      query = query.gte('date', from);
    } else if (to) {
      query = query.lte('date', to);
    }

    const { data, error } = await query;
    if (error) throw error;
    res.json(data.map(normalise));
  } catch (err) {
    console.error('GET /expenses error:', err);
    res.status(500).json({ error: err.message });
  }
});

// GET /api/expenses/total
// Query param: type ('expense' | 'income')
router.get('/total', async (req, res) => {
  try {
    const userId = req.user.id;
    const { type } = req.query;
    if (!type) return res.status(400).json({ error: 'type param required' });

    const { data, error } = await supabase.rpc('get_expense_total', {
      p_user_id: userId,
      p_type: type,
    });
    if (error) throw error;
    res.json({ total: parseFloat(data) || 0 });
  } catch (err) {
    console.error('GET /expenses/total error:', err);
    res.status(500).json({ error: err.message });
  }
});

// GET /api/expenses/analytics/category-totals
// Query params: type (required), from (optional), to (optional)
router.get('/analytics/category-totals', async (req, res) => {
  try {
    const userId = req.user.id;
    const { type, from, to } = req.query;
    if (!type) return res.status(400).json({ error: 'type param required' });

    const { data, error } = await supabase.rpc('get_category_totals', {
      p_user_id: userId,
      p_type: type,
      p_from: from ?? null,
      p_to: to ?? null,
    });
    if (error) throw error;
    res.json(data.map(r => ({ ...r, total: parseFloat(r.total) })));
  } catch (err) {
    console.error('GET /analytics/category-totals error:', err);
    res.status(500).json({ error: err.message });
  }
});

// GET /api/expenses/analytics/monthly-totals
// Query param: months (default 6)
router.get('/analytics/monthly-totals', async (req, res) => {
  try {
    const userId = req.user.id;
    const months = parseInt(req.query.months || '6', 10);

    const { data, error } = await supabase.rpc('get_monthly_totals', {
      p_user_id: userId,
      p_months: months,
    });
    if (error) throw error;
    res.json(data.map(r => ({ ...r, total: parseFloat(r.total) })));
  } catch (err) {
    console.error('GET /analytics/monthly-totals error:', err);
    res.status(500).json({ error: err.message });
  }
});

// GET /api/expenses/analytics/daily-totals
// Query param: days (default 30)
router.get('/analytics/daily-totals', async (req, res) => {
  try {
    const userId = req.user.id;
    const days = parseInt(req.query.days || '30', 10);

    const { data, error } = await supabase.rpc('get_daily_totals', {
      p_user_id: userId,
      p_days: days,
    });
    if (error) throw error;
    res.json(data.map(r => ({ ...r, total: parseFloat(r.total) })));
  } catch (err) {
    console.error('GET /analytics/daily-totals error:', err);
    res.status(500).json({ error: err.message });
  }
});

// POST /api/expenses
router.post('/', async (req, res) => {
  try {
    const userId = req.user.id;
    const { title, amount, category, date, type, notes } = req.body;

    if (!title || amount == null || !category || !date || !type) {
      return res.status(400).json({ error: 'Missing required fields' });
    }

    const { data, error } = await supabase
      .from('expenses')
      .insert({
        user_id: userId,
        title,
        amount: parseFloat(amount),
        category,
        date,
        type,
        notes: notes ?? null,
      })
      .select('id')
      .single();

    if (error) throw error;
    res.status(201).json({ id: data.id });
  } catch (err) {
    console.error('POST /expenses error:', err);
    res.status(500).json({ error: err.message });
  }
});

// PUT /api/expenses/:id
router.put('/:id', async (req, res) => {
  try {
    const userId = req.user.id;
    const id = parseInt(req.params.id, 10);
    const { title, amount, category, date, type, notes } = req.body;

    const { data, error } = await supabase
      .from('expenses')
      .update({ title, amount: parseFloat(amount), category, date, type, notes: notes ?? null })
      .eq('id', id)
      .eq('user_id', userId)
      .select('id');

    if (error) throw error;
    if (!data || data.length === 0) {
      return res.status(404).json({ error: 'Expense not found' });
    }
    res.json({ updated: data.length });
  } catch (err) {
    console.error('PUT /expenses/:id error:', err);
    res.status(500).json({ error: err.message });
  }
});

// DELETE /api/expenses/:id
router.delete('/:id', async (req, res) => {
  try {
    const userId = req.user.id;
    const id = parseInt(req.params.id, 10);

    const { data, error } = await supabase
      .from('expenses')
      .delete()
      .eq('id', id)
      .eq('user_id', userId)
      .select('id');

    if (error) throw error;
    if (!data || data.length === 0) {
      return res.status(404).json({ error: 'Expense not found' });
    }
    res.json({ deleted: data.length });
  } catch (err) {
    console.error('DELETE /expenses/:id error:', err);
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
