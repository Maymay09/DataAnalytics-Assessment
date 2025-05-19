
# DataAnalytics-Assessment

This repository contains SQL solutions to a series of analytical business questions. The focus is on transaction behavior, customer segmentation, and value estimation using structured queries.

---

## ✅ Assumptions & Notes

- `owner_id` is a foreign key to the `users_customuser.id`.
- `plan_id` references the `plans_plan.id`.
- `is_regular_savings = 1` → savings plan.
- `is_a_fund = 1` → investment plan.
- `confirmed_amount` is used for inflow values.
- `amount_withdrawn` is used for outflows (not applicable in all questions).
- All monetary fields (`confirmed_amount`, etc.) are in **kobo**, converted to **naira** using `amount / 100`.

---

## Question 1: High-Value Customers with Multiple Products

**Scenario**:  
The business wants to identify customers who have both a savings and an investment plan to target for cross-selling.

**Approach**:
- Selected customers who have at least one **funded savings plan** (`is_regular_savings = 1`) and one **funded investment plan** (`is_a_fund = 1`).
- Summed up `confirmed_amount` from both sources, converted from kobo to naira.
- Returned customer ID, full name, savings count, investment count, and total deposit value.

**Challenges**:
- Needed to avoid double-counting or missing customers without both plan types.
- Converted all amount fields from kobo to naira (`amount / 100.0`).

---

## Question 2: Transaction Frequency Analysis

**Scenario**:  
The finance team wants to segment users by how frequently they transact.

**Approach**:
- Counted transactions per user per month from savings accounts (`is_regular_savings = 1`).
- Averaged monthly transaction counts across users.
- Categorized users:
  - **High Frequency**: ≥10 transactions/month
  - **Medium Frequency**: 3–9/month
  - **Low Frequency**: ≤2/month

**Challenges**:
- Needed to truncate dates to monthly granularity.
- Ensured correct grouping and averaging across months.

---

## Question 3: Account Inactivity Alert

**Scenario**:  
Operations wants to flag accounts that have not received any inflow in over 1 year.

**Approach**:
- Selected **active** savings and investment plans using flags and `status = 'active'`.
- Checked `last_transaction_date` against current date.
- Filtered out accounts with no transactions in the last 365 days.
- Calculated number of inactive days.

**Challenges**:
- Ensured accurate join between tables with consistent columns.
- Needed to handle date differences in days accurately.

---

## Question 4: Customer Lifetime Value (CLV) Estimation

**Scenario**:  
Marketing wants to estimate CLV using tenure and transaction volume.

**Approach**:
- Tenure calculated as months since `date_joined` from `users_customuser`.
- Transactions and profit estimated from `savings_savingsaccount`:
  - `profit_per_transaction = confirmed_amount * 0.1%`
- Applied CLV formula:
