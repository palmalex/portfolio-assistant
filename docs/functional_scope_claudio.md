# Functional Definition – Portfolio Assistant (Prepared by Claudio)

## Purpose and Users
The **Portfolio Assistant** is an internal tool designed for Alessio’s family to monitor and manage investment portfolios.  
- **Admin user (Alessio):** Full control (create, edit, delete, and manage all data).  
- **Family members:** Read-only access to reports and summaries.

The system provides consolidated portfolio analytics, enabling Alessio to understand the overall allocation, performance, and next investment steps based on targets.

---

## Functional Scope – Release 1

### Core Functions
1. **Portfolio Management**
   - Register all investment actions (buy/sell, dividends, deposits, withdrawals).
   - Maintain records of assets (up to ~100).
   - Compute performance metrics (PnL, FX impact, returns).

2. **Reporting and Analytics**
   - Display current portfolio value.
   - Report realized/unrealized profits and losses.
   - Show exposure by:
     - Asset class
     - Geographic region
     - Currency
   - Export to Excel (nice-to-have feature).

3. **Interaction**
   - Main interface: Telegram chatbot.
   - Conversational commands for portfolio insights (e.g., “What’s my total exposure in USD?”).
   - GenAI-based language understanding for flexible natural queries.

4. **Integration**
   - GitHub for code and documentation storage.
   - GenAI API integration for natural language processing (future versions may include OpenAI or local LLM endpoints).

---

## Non-Functional Requirements
- Data persistence with referential integrity.
- Secure authentication for admin operations.
- Optimized for lightweight operation (local or small cloud footprint).
- Modularity for future expansion (e.g., tax reporting, advanced analytics).

---

## Expected Outputs
- Current portfolio valuation
- Profit/Loss (including FX effects)
- Asset allocation reports (by geography and category)
- Readable report summaries (via Telegram)
- Optional Excel export for offline analysis

---

## Future Extensions
- Tax report generation
- Goal-based investment tracking
- Multi-user write access
- Advanced GenAI-based portfolio recommendations

---

## User Story Examples
1. **As Alessio**, I want to add a new asset purchase via Telegram so that I can keep my portfolio updated without using a spreadsheet.  
   **Acceptance Criteria:**
   - Telegram message parsed correctly.
   - Data stored and confirmed in the database.
   - Updated portfolio summary visible on request.

2. **As a family member**, I want to view the latest asset allocation summary so that I can understand our portfolio distribution.  
   **Acceptance Criteria:**
   - Read-only Telegram command available.
   - Portfolio chart and metrics displayed clearly.

---

_Last updated: November 2025_
