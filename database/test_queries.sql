-- ============================================================
-- Portfolio Assistant - Test Queries
-- Version: 1.2 (November 2025)
-- Author: Laura (Senior Data Model Analyst)
-- ============================================================

PRAGMA foreign_keys = ON;

-- ============================================================
-- 1. Basic Structure Validation
-- ============================================================

-- List all users and portfolios
SELECT u.name AS user_name, p.name AS portfolio_name, p.created_at
FROM User u
JOIN Portfolio p ON u.id = p.user_id;

-- List all accounts with type and base currency
SELECT a.name AS account_name, a.account_type, a.base_currency, c.fx_to_eur
FROM Account a
JOIN Currency c ON a.base_currency = c.code;

-- Count assets per account
SELECT acc.name AS account_name, COUNT(ast.id) AS total_assets
FROM Account acc
LEFT JOIN Asset ast ON acc.id = ast.account_id
GROUP BY acc.name;

-- ============================================================
-- 2. Portfolio Value (Unrealized)
-- ============================================================
-- Calculate current market value for each asset using latest price
SELECT
    a.name AS asset_name,
    ac.name AS account_name,
    t.currency_code,
    SUM(t.quantity) AS total_units,
    ph.close_price AS last_price,
    ROUND(SUM(t.quantity) * ph.close_price, 2) AS current_value
FROM Transaction t
JOIN Asset a ON a.id = t.asset_id
JOIN Account ac ON ac.id = a.account_id
JOIN PriceHistory ph ON ph.asset_id = a.id
WHERE ph.date = (SELECT MAX(date) FROM PriceHistory ph2 WHERE ph2.asset_id = a.id)
  AND t.type IN ('buy','sell')
GROUP BY a.name;

-- ============================================================
-- 3. Realized PnL for Administered Accounts
-- ============================================================
-- (Simplified: difference between sell proceeds and buy cost)
SELECT
    a.name AS asset_name,
    ac.name AS account_name,
    SUM(CASE WHEN t.type = 'sell' THEN t.quantity * t.price ELSE 0 END)
    - SUM(CASE WHEN t.type = 'buy' THEN t.quantity * t.price ELSE 0 END)
    AS realized_pnl
FROM Transaction t
JOIN Asset a ON a.id = t.asset_id
JOIN Account ac ON ac.id = a.account_id
WHERE ac.account_type = 'administered'
GROUP BY a.name, ac.name;

-- ============================================================
-- 4. Exposure by Asset Type
-- ============================================================
SELECT
    a.type AS asset_type,
    SUM(t.quantity * ph.close_price) AS total_value_eur
FROM Transaction t
JOIN Asset a ON a.id = t.asset_id
JOIN PriceHistory ph ON ph.asset_id = a.id
JOIN Account ac ON ac.id = a.account_id
JOIN Currency c ON a.currency_code = c.code
WHERE ph.date = (SELECT MAX(date) FROM PriceHistory ph2 WHERE ph2.asset_id = a.id)
GROUP BY a.type
ORDER BY total_value_eur DESC;

-- ============================================================
-- 5. Dividend Income (YTD)
-- ============================================================
SELECT
    a.name AS asset_name,
    ac.name AS account_name,
    SUM(t.quantity * t.price) AS total_dividends
FROM Transaction t
JOIN Asset a ON a.id = t.asset_id
JOIN Account ac ON ac.id = a.account_id
WHERE t.type = 'dividend'
  AND strftime('%Y', t.date) = '2025'
GROUP BY a.name, ac.name;

-- ============================================================
-- 6. Declarative vs Administered Exposure
-- ============================================================
SELECT
    ac.account_type,
    SUM(t.quantity * ph.close_price) AS total_value
FROM Transaction t
JOIN Asset a ON a.id = t.asset_id
JOIN Account ac ON ac.id = a.account_id
JOIN PriceHistory ph ON ph.asset_id = a.id
WHERE ph.date = (SELECT MAX(date) FROM PriceHistory ph2 WHERE ph2.asset_id = a.id)
GROUP BY ac.account_type;

-- ============================================================
-- END OF TEST QUERIES
-- ============================================================
