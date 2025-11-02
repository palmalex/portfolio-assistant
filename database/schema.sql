-- ============================================================
-- Portfolio Assistant - SQLite Schema
-- Version: 1.2 (November 2025)
-- Author: Laura (Senior Data Model Analyst)
-- ============================================================

PRAGMA foreign_keys = ON;

-- ============================================================
-- 1. USER
-- ============================================================
CREATE TABLE User (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    name            TEXT NOT NULL,
    role            TEXT NOT NULL CHECK(role IN ('admin', 'viewer')),
    created_at      DATE DEFAULT (DATE('now'))
);

-- ============================================================
-- 2. PORTFOLIO
-- ============================================================
CREATE TABLE Portfolio (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id         INTEGER NOT NULL,
    name            TEXT NOT NULL,
    description     TEXT,
    created_at      DATE DEFAULT (DATE('now')),
    FOREIGN KEY (user_id)
        REFERENCES User(id)
        ON DELETE CASCADE
);

-- ============================================================
-- 3. CURRENCY
-- ============================================================
CREATE TABLE Currency (
    code            TEXT PRIMARY KEY,
    name            TEXT NOT NULL,
    fx_to_eur       REAL NOT NULL DEFAULT 1.0,
    updated_at      DATE DEFAULT (DATE('now'))
);

-- ============================================================
-- 4. ACCOUNT
-- ============================================================
CREATE TABLE Account (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    portfolio_id    INTEGER NOT NULL,
    name            TEXT NOT NULL,
    institution     TEXT,
    account_type    TEXT NOT NULL CHECK(account_type IN ('administered', 'declarative')),
    base_currency   TEXT NOT NULL,
    taxation_mode   TEXT,
    created_at      DATE DEFAULT (DATE('now')),
    is_active       INTEGER DEFAULT 1 CHECK(is_active IN (0, 1)),
    FOREIGN KEY (portfolio_id)
        REFERENCES Portfolio(id)
        ON DELETE CASCADE,
    FOREIGN KEY (base_currency)
        REFERENCES Currency(code)
        ON DELETE RESTRICT
);

CREATE INDEX idx_account_portfolio ON Account (portfolio_id);

-- ============================================================
-- 5. ASSET
-- ============================================================
CREATE TABLE Asset (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    account_id      INTEGER NOT NULL,
    name            TEXT NOT NULL,
    type            TEXT NOT NULL CHECK(type IN ('stock','bond','etf','fund','crypto','cash')),
    currency_code   TEXT NOT NULL,
    isin            TEXT,
    category        TEXT,
    region          TEXT,
    created_at      DATE DEFAULT (DATE('now')),
    FOREIGN KEY (account_id)
        REFERENCES Account(id)
        ON DELETE CASCADE,
    FOREIGN KEY (currency_code)
        REFERENCES Currency(code)
        ON DELETE RESTRICT
);

CREATE INDEX idx_asset_account ON Asset (account_id);

-- ============================================================
-- 6. TRANSACTION
-- ============================================================
CREATE TABLE Transaction (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    asset_id        INTEGER NOT NULL,
    date            DATE NOT NULL,
    type            TEXT NOT NULL CHECK(type IN ('buy','sell','dividend','deposit','withdrawal')),
    quantity        REAL NOT NULL DEFAULT 0,
    price           REAL NOT NULL DEFAULT 0,
    fees            REAL DEFAULT 0,
    taxes           REAL DEFAULT 0,
    currency_code   TEXT NOT NULL,
    notes           TEXT,
    FOREIGN KEY (asset_id)
        REFERENCES Asset(id)
        ON DELETE CASCADE,
    FOREIGN KEY (currency_code)
        REFERENCES Currency(code)
        ON DELETE RESTRICT
);

CREATE INDEX idx_transaction_asset_date ON Transaction (asset_id, date);

-- ============================================================
-- 7. PRICE HISTORY
-- ============================================================
CREATE TABLE PriceHistory (
    asset_id        INTEGER NOT NULL,
    date            DATE NOT NULL,
    close_price     REAL NOT NULL,
    source          TEXT,
    PRIMARY KEY (asset_id, date),
    FOREIGN KEY (asset_id)
        REFERENCES Asset(id)
        ON DELETE CASCADE
);

-- ============================================================
-- END OF SCHEMA
-- ============================================================
