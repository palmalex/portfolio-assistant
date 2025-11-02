# Portfolio Assistant – Data Model Documentation
_Version 1.2 — November 2025_  
_Prepared by Laura (Senior Data Model Analyst)_

---

## Overview

The **Portfolio Assistant** data model defines the structure for tracking and analyzing portfolios, accounts, assets, and transactions.  
The **prototype implementation uses SQLite** as the persistence engine for its simplicity, portability, and zero-configuration setup.

SQLite is sufficient for early development and small deployments.  
Future versions can migrate to PostgreSQL or MySQL with minimal changes.

---

## Database Engine and Conventions

### **Engine**
- **SQLite 3** (local file database)
- File name convention: `portfolio_assistant.db`

### **Key Notes for SQLite**
| Topic | Description |
|-------|--------------|
| **Data types** | SQLite uses dynamic typing; fields use `INTEGER`, `REAL`, `TEXT`, `DATE`, and `BOOLEAN` (as integer 0/1). |
| **Foreign keys** | Must enable with `PRAGMA foreign_keys = ON;` |
| **Enumerations** | Simulated via `CHECK` constraints. |
| **Cascade delete** | Supported and used to maintain referential integrity. |
| **Indexes** | Recommended on foreign keys and date columns for performance. |

---

## Entity–Relationship Overview

User ───< Portfolio ───< Account ───< Asset ───< Transaction
│
└──< PriceHistory
Account ───< Currency


---

## Entities

### 1. **User**
Represents a system user (admin or read-only family member).

| Field | Type | Description |
|--------|------|-------------|
| `id` | INTEGER (PK) | Unique user identifier |
| `name` | TEXT | Full name of the user |
| `role` | TEXT | CHECK(`role` IN ('admin','viewer')) |
| `created_at` | DATE | Creation timestamp |

---

### 2. **Portfolio**
Top-level container of investment data for a given user or family group.

| Field | Type | Description |
|--------|------|-------------|
| `id` | INTEGER (PK) | Unique portfolio identifier |
| `user_id` | INTEGER (FK → User.id) | Portfolio owner |
| `name` | TEXT | Portfolio name |
| `description` | TEXT | Optional notes |
| `created_at` | DATE | Creation date |

**Notes**
- A user can own multiple portfolios.  
- Deleting a user cascades all associated portfolios.

---

### 3. **Account**
Represents a financial account (bank, broker, or platform) containing assets.  
Each account defines its **base currency** and **taxation mode**.

| Field | Type | Description |
|--------|------|-------------|
| `id` | INTEGER (PK) | Unique account identifier |
| `portfolio_id` | INTEGER (FK → Portfolio.id) | Parent portfolio |
| `name` | TEXT | Account name (e.g., “Fineco Administered”) |
| `institution` | TEXT | Bank or broker name |
| `account_type` | TEXT | CHECK(`account_type` IN ('administered','declarative')) |
| `base_currency` | TEXT (FK → Currency.code) | Account reference currency |
| `taxation_mode` | TEXT | Descriptive label or rule identifier |
| `created_at` | DATE | Account creation timestamp |
| `is_active` | BOOLEAN | Active/inactive flag |

**Behavior**
- **Administered** → taxes applied per transaction.  
- **Declarative** → taxes deferred to reporting phase.

---

### 4. **Asset**
Represents a single investment instrument held within an account.

| Field | Type | Description |
|--------|------|-------------|
| `id` | INTEGER (PK) | Unique asset identifier |
| `account_id` | INTEGER (FK → Account.id) | Account owning the asset |
| `name` | TEXT | Asset name (e.g., “MSFT”, “iShares MSCI World”) |
| `type` | TEXT | CHECK(`type` IN ('stock','bond','etf','fund','crypto','cash')) |
| `currency_code` | TEXT (FK → Currency.code) | Trading currency |
| `isin` | TEXT | International identifier (optional) |
| `category` | TEXT | Classification (e.g., Equity, Fixed Income) |
| `region` | TEXT | Geographic exposure |
| `created_at` | DATE | Creation timestamp |

---

### 5. **Transaction**
Represents an operation affecting portfolio value.

| Field | Type | Description |
|--------|------|-------------|
| `id` | INTEGER (PK) | Unique transaction ID |
| `asset_id` | INTEGER (FK → Asset.id) | Associated asset |
| `date` | DATE | Transaction date |
| `type` | TEXT | CHECK(`type` IN ('buy','sell','dividend','deposit','withdrawal')) |
| `quantity` | REAL | Quantity of asset |
| `price` | REAL | Unit price |
| `fees` | REAL | Transaction fees |
| `taxes` | REAL | Tax amount applied (administered accounts only) |
| `currency_code` | TEXT (FK → Currency.code) | Transaction currency |
| `notes` | TEXT | Optional notes |

**Behavior**
- Declarative accounts → `taxes` = 0 (deferred).  
- Administered accounts → `taxes` applied per transaction.

---

### 6. **PriceHistory**
Historical valuation data for each asset.

| Field | Type | Description |
|--------|------|-------------|
| `asset_id` | INTEGER (FK → Asset.id) | Related asset |
| `date` | DATE | Date of valuation |
| `close_price` | REAL | End-of-day price |
| `source` | TEXT | Data provider |

**Primary Key:** (`asset_id`, `date`)

---

### 7. **Currency**
Reference table for currency data and exchange rates (relative to EUR).

| Field | Type | Description |
|--------|------|-------------|
| `code` | TEXT (PK) | ISO currency code (e.g., EUR, USD) |
| `name` | TEXT | Currency name |
| `fx_to_eur` | REAL | Conversion rate to EUR |
| `updated_at` | DATE | Last update timestamp |

---

## Referential Integrity Rules

| Relationship | Constraint |
|---------------|------------|
| `Portfolio.user_id` → `User.id` | ON DELETE CASCADE |
| `Account.portfolio_id` → `Portfolio.id` | ON DELETE CASCADE |
| `Asset.account_id` → `Account.id` | ON DELETE CASCADE |
| `Transaction.asset_id` → `Asset.id` | ON DELETE CASCADE |
| `Asset.currency_code`, `Transaction.currency_code`, `Account.base_currency` → `Currency.code` | ON DELETE RESTRICT |

---

## Indexing Recommendations
- `CREATE INDEX idx_transaction_asset_date ON Transaction(asset_id, date);`  
- `CREATE INDEX idx_asset_account ON Asset(account_id);`  
- `CREATE INDEX idx_account_portfolio ON Account(portfolio_id);`

---

## Enumerations (via CHECK constraints)

| Field | Allowed Values |
|--------|----------------|
| `User.role` | `'admin'`, `'viewer'` |
| `Account.account_type` | `'administered'`, `'declarative'` |
| `Asset.type` | `'stock'`, `'bond'`, `'etf'`, `'fund'`, `'crypto'`, `'cash'` |
| `Transaction.type` | `'buy'`, `'sell'`, `'dividend'`, `'deposit'`, `'withdrawal'` |

---

## Future Extensions

| Area | Possible Entities | Purpose |
|-------|-------------------|----------|
| Tax Reporting | `TaxEvent`, `TaxRule` | Manage deferred taxation for declarative accounts |
| Benchmarks | `Index`, `BenchmarkAllocation` | Compare portfolio vs. benchmark |
| Integration | `DataSource` | Track and validate external price data |

---

## Summary

This SQLite-based schema provides a **portable and normalized foundation** for:
- Multi-account portfolio management  
- Consistent tax treatment by account type  
- Efficient analytical queries (allocation, PnL, valuation)  
- Easy migration to full RDBMS in future releases  

---

_Last updated: November 2025_
