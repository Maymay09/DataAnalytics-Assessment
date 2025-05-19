

WITH savings AS (
    SELECT owner_id, SUM(confirmed_amount) AS total_savings
    FROM savings_savingsaccount
    WHERE status = 'funded' AND is_regular_savings = 1
    GROUP BY owner_id
),
investments AS (
    SELECT owner_id, SUM(confirmed_amount) AS total_investments
    FROM plans_plan
    WHERE status = 'funded' AND is_a_fund = 1
    GROUP BY owner_id
)
SELECT
    u.id AS owner_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    1 AS savings_count,
    1 AS investment_count,
    ROUND((COALESCE(s.total_savings, 0) + COALESCE(i.total_investments, 0)) / 100.0, 2) AS total_deposits
FROM users_customuser u
JOIN savings s ON u.id = s.owner_id
JOIN investments i ON u.id = i.owner_id
ORDER BY total_deposits DESC;
