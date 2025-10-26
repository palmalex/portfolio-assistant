# Portfolio Assistant – Data Model Documentation

## Overview
The Portfolio Assistant data model is designed to support multi‑asset portfolio management with a focus on:
- **Modularity**: extensible entities and CRUD wrappers
- **Auditability**: explicit logging of all operations
- **Rollback**: soft recovery mechanisms for failed or partial transactions

## ER Diagram (ASCII)

```ascii
+---------+        1 ──── *        +------------+
|  User   |------------------------| Portfolio  |
+---------+                        +------------+
     |                                   |
     |                                   | 1 ──── *
     |                                   v
     |                             +-----------+
     |                             |   Asset   |
     |                             +-----------+
     |                                   |
     |                                   | 1 ──── *
     |                                   v
     |                             +---------------+
     |                             |  Transaction  |
     |                             +---------------+
     |                                   |
     |                                   | 1 ──── *
     |                                   v
     |                             +------------+
     +---------------------------->|  AuditLog  |
                                   +------------+
```

Legend:
- 1 ──── * : one-to-many relationship
- Every entity can generate multiple AuditLog entries
---

## Main Entities

### User
- **Fields**: `user_id` (string, PK), `email`, `preferences`, `created_at`
- **Notes**: Credentials stored securely via Secret Manager

### Portfolio
- **Fields**: `portfolio_id` (string, PK), `user_id` (FK), `name`, `created_at`
- **Notes**: Each user can own multiple portfolios

### Asset
- **Fields**: `asset_id` (string, PK), `portfolio_id` (FK), `symbol`, `type` (stock, bond, crypto, etc.), `metadata`
- **Notes**: Assets are always linked to a portfolio

### Transaction
- **Fields**: `transaction_id` (string, PK), `portfolio_id` (FK), `asset_id` (FK), `type` (buy/sell), `quantity`, `price`, `timestamp`, `status`
- **Notes**: Transactions are atomic; failures trigger rollback and audit logging

### AuditLog
- **Fields**: `log_id` (string, PK), `entity_type`, `entity_id`, `action`, `timestamp`, `details`
- **Notes**: Supports soft rollback and manual recovery

---

## Relationships
- A **User** → many **Portfolios**
- A **Portfolio** → many **Assets**
- A **Portfolio** → many **Transactions**
- A **Transaction** → one **Asset**
- All entities → many **AuditLog** entries

---

## Firestore Schema Notes
- **Collections**: `users`, `portfolios`, `assets`, `transactions`, `audit_logs`
- **Subcollections**: `assets` and `transactions` may be nested under `portfolios`
- **Indexes**: composite indexes on `(portfolio_id, asset_id)` and `(portfolio_id, timestamp)` for fast queries

---

## Test Isolation Strategies
- Use **MemoryStorage** with TinyDB for local prototypes
- Each test run initializes a fresh in‑memory DB
- Guarantees no cross‑test contamination or file conflicts

---

## Future Extensions
- Stateless caching for performance optimization
- Advanced trading optimization models (dynamic programming, greedy strategies)
- Extended audit trail with automated anomaly detection

