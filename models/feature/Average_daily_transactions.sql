WITH DateRange AS (
  SELECT
    user_id,
    MAX(date_date) AS max_date,
    MIN(date_date) AS min_date
  FROM {{ref('transactions_cleaned')}} 
  WHERE transactions_state = "COMPLETED"
  GROUP BY user_id
),
TransactionCount AS (
  SELECT
    user_id,
    COUNT(transaction_id) AS total_transactions
  FROM {{ref('transactions_cleaned')}} 
  WHERE transactions_state = "COMPLETED"
  GROUP BY user_id
)
SELECT
  t.user_id,
  CASE
    WHEN DATE_DIFF(d.max_date, d.min_date, DAY) = 0 THEN 1.000 ##We set 1.000 for those cases where there is no difference between the first and last transaction, meaning that 
    ELSE ROUND(t.total_transactions / DATE_DIFF(d.max_date, d.min_date, DAY), 2)
  END AS transaction_frequency
FROM TransactionCount t
JOIN DateRange d ON t.user_id = d.user_id