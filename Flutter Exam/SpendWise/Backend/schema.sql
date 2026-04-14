-- SpendWise MySQL Schema
-- Run this once to set up the database

CREATE DATABASE IF NOT EXISTS spendwise
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE spendwise;

CREATE TABLE IF NOT EXISTS expenses (
  id         INT            AUTO_INCREMENT PRIMARY KEY,
  title      VARCHAR(255)   NOT NULL,
  amount     DOUBLE         NOT NULL,
  category   VARCHAR(100)   NOT NULL,
  date       VARCHAR(30)    NOT NULL,   -- stored as ISO-8601 string (e.g. 2026-03-09T10:30:00.000)
  type       ENUM('expense','income') NOT NULL DEFAULT 'expense',
  notes      TEXT,
  created_at TIMESTAMP      DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_expenses_date (date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
