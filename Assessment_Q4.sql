

WITH transactions AS (
    SELECT
        owner_id,
        COUNT(*) AS total_transactions,
        AVG(confirmed_amount * 0.001) / 100.0 AS avg_profit_per_transaction_naira
    FROM savings_savingsaccount
    WHERE is_regular_savings = 1
    GROUP BY owner_id
),
tenure AS (
    SELECT
        id AS customer_id,
        CONCAT(first_name, ' ', last_name) AS name,
        DATE_PART('month', AGE(CURRENT_DATE, date_joined)) AS tenure_months
    FROM users_customuser
),
clv_calc AS (
    SELECT
        t.customer_id,
        t.name,
        t.tenure_months,
        tx.total_transactions,
        ROUND((tx.total_transactions::decimal / NULLIF(t.tenure_months, 0)) * 12 * tx.avg_profit_per_transaction_naira, 2) AS estimated_clv
    FROM tenure t
    JOIN transactions tx ON t.customer_id = tx.owner_id
)
SELECT *
FROM clv_calc
ORDER BY estimated_clv DESC;
