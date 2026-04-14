# SpendWise — MySQL Commands

## Connect to MySQL
```bash
mysql -u root -proot1234
```

---

## Database Operations

```sql
-- List all databases
SHOW DATABASES;

-- Select spendwise DB
USE spendwise;

-- Check current database
SELECT DATABASE();
```

---

## Table Operations

```sql
-- List all tables
SHOW TABLES;

-- View table structure
DESCRIBE expenses;

-- View full table definition
SHOW CREATE TABLE expenses;
```

---

## SELECT (Read)

```sql
-- All expenses
SELECT * FROM expenses;

-- All expenses ordered by date (newest first)
SELECT * FROM expenses ORDER BY date DESC;

-- Only expenses (not income)
SELECT * FROM expenses WHERE type = 'expense';

-- Only income
SELECT * FROM expenses WHERE type = 'income';

-- Filter by category
SELECT * FROM expenses WHERE category = 'Food & Dining';

-- Filter by month (e.g. March 2026)
SELECT * FROM expenses WHERE LEFT(date, 7) = '2026-03';

-- Search by title keyword
SELECT * FROM expenses WHERE title LIKE '%coffee%';

-- Single record by ID
SELECT * FROM expenses WHERE id = 1;

-- Total expense amount
SELECT SUM(amount) AS total_expense FROM expenses WHERE type = 'expense';

-- Total income amount
SELECT SUM(amount) AS total_income FROM expenses WHERE type = 'income';

-- Balance (income - expense)
SELECT
  SUM(CASE WHEN type = 'income'  THEN amount ELSE 0 END) AS total_income,
  SUM(CASE WHEN type = 'expense' THEN amount ELSE 0 END) AS total_expense,
  SUM(CASE WHEN type = 'income'  THEN amount ELSE -amount END) AS balance
FROM expenses;

-- Category-wise totals
SELECT category, SUM(amount) AS total
FROM expenses
WHERE type = 'expense'
GROUP BY category
ORDER BY total DESC;

-- Monthly totals
SELECT LEFT(date, 7) AS month, type, SUM(amount) AS total
FROM expenses
GROUP BY month, type
ORDER BY month DESC;

-- Count of records
SELECT COUNT(*) AS total_records FROM expenses;
```

---

## INSERT (Create)

```sql
-- Add an expense
INSERT INTO expenses (title, amount, category, date, type, notes)
VALUES ('Lunch', 250.00, 'Food & Dining', '2026-03-09T13:00:00.000', 'expense', 'Burger and fries');

-- Add income
INSERT INTO expenses (title, amount, category, date, type, notes)
VALUES ('Salary', 50000.00, 'Salary', '2026-03-01T09:00:00.000', 'income', 'March salary');
```

---

## UPDATE (Edit)

```sql
-- Update amount of a record
UPDATE expenses SET amount = 300.00 WHERE id = 1;

-- Update multiple fields
UPDATE expenses SET title = 'Dinner', amount = 450.00, notes = 'Updated' WHERE id = 1;

-- Update category for all matching records
UPDATE expenses SET category = 'Food & Dining' WHERE category = 'Food';
```

---

## DELETE (Remove)

```sql
-- Delete a single record by ID
DELETE FROM expenses WHERE id = 1;

-- Delete all expenses of a category
DELETE FROM expenses WHERE category = 'Others';

-- Delete all records in a month
DELETE FROM expenses WHERE LEFT(date, 7) = '2026-01';

-- Delete ALL records (keep table structure)
DELETE FROM expenses;

-- Reset auto-increment counter after full delete
ALTER TABLE expenses AUTO_INCREMENT = 1;
```

---

## Table Management

```sql
-- Drop (delete) the expenses table entirely
DROP TABLE IF EXISTS expenses;

-- Drop the entire spendwise database
DROP DATABASE IF EXISTS spendwise;

-- Recreate the database
CREATE DATABASE spendwise CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

---

## Useful Extras

```sql
-- Check how many rows are in the table
SELECT COUNT(*) FROM expenses;

-- Check the latest 10 entries
SELECT * FROM expenses ORDER BY created_at DESC LIMIT 10;

-- Check for any NULL notes
SELECT * FROM expenses WHERE notes IS NULL;

-- Show indexes on the table
SHOW INDEX FROM expenses;
```

---

## Exit MySQL
```sql
EXIT;
```
