-- =============================================================
-- SpendWise PostgreSQL Schema for Supabase
-- HOW TO USE: Paste this entire file into the Supabase SQL Editor
--             and click "Run". Do this ONCE before starting the server.
-- =============================================================

-- -------------------------------------------------------------
-- 1. TABLES
-- -------------------------------------------------------------

CREATE TABLE IF NOT EXISTS users (
  id            BIGSERIAL     PRIMARY KEY,
  name          VARCHAR(100)  NOT NULL,
  email         VARCHAR(255)  NOT NULL UNIQUE,
  password_hash VARCHAR(255)  NOT NULL,
  created_at    TIMESTAMPTZ   DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS expenses (
  id         BIGSERIAL    PRIMARY KEY,
  user_id    BIGINT       NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  title      VARCHAR(255) NOT NULL,
  amount     FLOAT        NOT NULL,
  category   VARCHAR(100) NOT NULL,
  date       VARCHAR(30)  NOT NULL,
  type       VARCHAR(10)  NOT NULL CHECK (type IN ('expense', 'income')),
  notes      TEXT,
  created_at TIMESTAMPTZ  DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_expenses_date    ON expenses(date);
CREATE INDEX IF NOT EXISTS idx_expenses_user_id ON expenses(user_id);

-- -------------------------------------------------------------
-- 2. ANALYTICS FUNCTIONS (called via supabase.rpc() in the API)
-- -------------------------------------------------------------

-- 2a. Total amount for a given type (expense or income)
CREATE OR REPLACE FUNCTION get_expense_total(p_user_id BIGINT, p_type TEXT)
RETURNS FLOAT
LANGUAGE SQL SECURITY DEFINER AS $$
  SELECT COALESCE(SUM(amount), 0)::FLOAT
  FROM   expenses
  WHERE  user_id = p_user_id
    AND  type    = p_type;
$$;

-- 2b. Breakdown of totals per category
CREATE OR REPLACE FUNCTION get_category_totals(
  p_user_id BIGINT,
  p_type    TEXT,
  p_from    TEXT DEFAULT NULL,
  p_to      TEXT DEFAULT NULL
)
RETURNS TABLE(category TEXT, total FLOAT)
LANGUAGE SQL SECURITY DEFINER AS $$
  SELECT   category,
           SUM(amount)::FLOAT AS total
  FROM     expenses
  WHERE    user_id = p_user_id
    AND    type    = p_type
    AND   (p_from IS NULL OR date >= p_from)
    AND   (p_to   IS NULL OR date <= p_to)
  GROUP BY category
  ORDER BY total DESC;
$$;

-- 2c. Monthly totals for the last N months
CREATE OR REPLACE FUNCTION get_monthly_totals(p_user_id BIGINT, p_months INT DEFAULT 6)
RETURNS TABLE(month TEXT, type TEXT, total FLOAT)
LANGUAGE SQL SECURITY DEFINER AS $$
  SELECT   LEFT(date, 7)      AS month,
           type,
           SUM(amount)::FLOAT AS total
  FROM     expenses
  WHERE    user_id = p_user_id
    AND    date >= to_char(
                     NOW() - (p_months || ' months')::INTERVAL,
                     'YYYY-MM-DD'
                   )
  GROUP BY month, type
  ORDER BY month ASC;
$$;

-- 2d. Daily totals for the last N days
CREATE OR REPLACE FUNCTION get_daily_totals(p_user_id BIGINT, p_days INT DEFAULT 30)
RETURNS TABLE(day TEXT, type TEXT, total FLOAT)
LANGUAGE SQL SECURITY DEFINER AS $$
  SELECT   LEFT(date, 10)     AS day,
           type,
           SUM(amount)::FLOAT AS total
  FROM     expenses
  WHERE    user_id = p_user_id
    AND    date >= to_char(
                     NOW() - (p_days || ' days')::INTERVAL,
                     'YYYY-MM-DD'
                   )
  GROUP BY day, type
  ORDER BY day ASC;
$$;
