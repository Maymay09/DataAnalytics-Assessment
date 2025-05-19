

WITH transactions AS (
    SELECT
        owner_id,
        DATE_TRUNC('month', transaction_date) AS txn_month,
        COUNT(*) AS monthly_txn_count
    FROM savings_savingsaccount
    WHERE is_regular_savings = 1
    GROUP BY owner_id, DATE_TRUNC('month', transaction_date)
),
avg_txn_per_user AS (
    SELECT
        owner_id,
        AVG(monthly_txn_count) AS avg_transactions_per_month
    FROM transactions
    GROUP BY owner_id
),
categorized AS (
    SELECT
        CASE
            WHEN avg_transactions_per_month >= 10 THEN 'High Frequency'
            WHEN avg_transactions_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category,
        avg_transactions_per_month
    FROM avg_txn_per_user
)
SELECT
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_transactions_per_month), 1) AS avg_transactions_per_month
FROM categorized
GROUP BY frequency_category
ORDER BY
    CASE frequency_category
        WHEN 'High Frequency' THEN 1
        WHEN 'Medium Frequency' THEN 2
        ELSE 3
    END;
