-- ============================================================
-- Portfolio Assistant - Sample Data for Prototype
-- Version: 1.2 (November 2025)
-- Author: Laura (Senior Data Model Analyst)
-- ============================================================

PRAGMA foreign_keys = ON;

-- ============================================================
-- 1. CURRENCY
-- ============================================================
INSERT INTO Currency (code, name, fx_to_eur, updated_at) VALUES
('EUR', 'Euro', 1.0, DATE('now')),
('USD', 'US Dollar', 0.93, DATE('now')),
('GBP', 'British Pound', 1.15, DATE('now'));

-- ============================================================
-- 2. USER
-- ============================================================
INSERT INTO User (name, role, created_at) VALUES
('Alessio', 'admin', DATE('now')),
('Maria', 'viewer', DATE('now'));

-- ============================================================
-- 3. PORTFOLIO
-- ============================================================
INSERT INTO Portfolio (user_id, name, description, created_at) VALUES
(1, 'Family Portfolio', 'Consolidated investment portfolio', DATE('now'));

-- ============================================================
-- 4. ACCOUNT
-- ============================================================
INSERT INTO Account (portfolio_id, name, institution, account_type, base_currency, taxation_mode, created_at, is_active) VALUES
(1, 'Fineco Administered', 'Fineco Bank', 'administered', 'EUR', 'withholding', DATE('now'), 1),
(1, 'Degiro Declarative', 'Degiro', 'declarative', 'EUR', 'annual tax report', DATE('now'), 1);

-- ============================================================
-- 5. ASSET
-- ============================================================
INSERT INTO Asset (account_id, name, type, currency_code, isin, category, region, created_at) VALUES
(1, 'MSFT', 'stock', 'USD', 'US5949181045', 'Equity', 'USA', DATE('now')),
(1, 'ENEL', 'stock', 'EUR', 'IT0003128367', 'Equity', 'Europe', DATE('now')),
(2, 'iShares MSCI World', 'etf', 'USD', 'IE00B4L5Y983', 'ETF', 'Global', DATE('now')),
(2, 'EUR Cash', 'cash', 'EUR', NULL, 'Cash', 'Europe', DATE('now'));

-- ============================================================
-- 6. TRANSACTION
-- ============================================================
-- Administered account (Fineco)
INSERT INTO Transaction (asset_id, date, type, quantity, price, fees, taxes, currency_code, notes) VALUES
(1, '2025-01-10', 'buy', 10, 320.00, 2.00, 0.00, 'USD', 'Initial purchase MSFT'),
(1, '2025-03-15', 'dividend', 10, 1.50, 0.00, 2.25, 'USD', 'Quarterly dividend with tax withheld'),
(2, '2025-02-12', 'buy', 100, 6.20, 1.50, 0.00, 'EUR', 'ENEL shares purchase');

-- Declarative account (Degiro)
INSERT INTO Transaction (asset_id, date, type, quantity, price, fees, taxes, currency_code, notes) VALUES
(3, '2025-01-05', 'buy', 5, 105.00, 1.00, 0.00, 'USD', 'ETF purchase - taxes deferred'),
(3, '2025-03-20', 'dividend', 5, 0.75, 0.00, 0.00, 'USD', 'ETF dividend - declarative account'),
(4, '2025-03-01', 'deposit', 1, 10000.00, 0.00, 0.00, 'EUR', 'Cash deposit');

-- ============================================================
-- 7. PRICE HISTORY
-- ============================================================
INSERT INTO PriceHistory (asset_id, date, close_price, source) VALUES
(1, '2025-03-31', 330.50, 'Yahoo'),
(2, '2025-03-31', 6.45, 'Borsa Italiana'),
(3, '2025-03-31', 110.00, 'Morningstar');

-- ============================================================
-- END OF SAMPLE DATA
-- ============================================================
