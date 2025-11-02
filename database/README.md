# 📊 Portfolio Assistant – Database Guide

_Version 1.2 — November 2025_  
_Prepared by Laura (Senior Data Model Analyst)_

---

## Overview

This folder contains all the database assets for the **Portfolio Assistant** prototype.  
The prototype uses **SQLite 3** as its local persistence layer for simplicity and portability.

SQLite was selected because it:
- Requires **no setup or server**.
- Works seamlessly with **Python**.
- Is fully compatible with the future migration path to PostgreSQL or MySQL.

---

## Folder Contents

| File | Description |
|------|--------------|
| `schema.sql` | Defines the entire database structure (tables, constraints, indexes). |
| `sample_data.sql` | Inserts example users, portfolios, accounts, assets, and transactions. |
| `test_queries.sql` | Provides validation queries for functional verification. |
| `../scripts/init_database.sh` | Script that initializes the database automatically. |
| `portfolio_assistant.db` | The generated SQLite database file (excluded from Git). |

---

## 🧱 Initialize the Database

Run the following commands from the project root:

```bash
chmod +x scripts/init_database.sh
./scripts/init_database.sh
