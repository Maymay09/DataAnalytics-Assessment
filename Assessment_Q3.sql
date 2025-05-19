

WITH combined_accounts AS (
    SELECT
        id AS plan_id,
        owner_id,
        'Savings' AS type,
        last_transaction_date
    FROM savings_savingsaccount
    WHERE status = 'active' AND is_regular_savings = 1

    UNION ALL

    SELECT
        id AS plan_id,
        owner_id,
        'Investment' AS type,
        last_transaction_date
    FROM plans_plan
    WHERE status = 'active' AND is_a_fund = 1
),
inactive_accounts AS (
    SELECT
        plan_id,
        owner_id,
        type,
        last_transaction_date,
        DATE_PART('day', CURRENT_DATE - last_transaction_date) AS inactivity_days
    FROM combined_accounts
    WHERE last_transaction_date <= CURRENT_DATE - INTERVAL '365 days'
)
SELECT *
FROM inactive_accounts
ORDER BY inactivity_days DESC;
