SELECT 
    RIGHT(user_id, LENGTH(user_id) - 5) AS user_id 
    ,RIGHT(transaction_id, LENGTH(transaction_id) - 12) AS transaction_id 
    ,created_date
    ,DATE(created_date) AS date_date
    ,transactions_type
    ,direction  
    ,transactions_currency 
    ,amount_usd 
    ,transactions_state 
    ,IFNULL(ea_cardholderpresence, "FALSE") AS cardholder_presence 
    ,CAST(ea_merchant_mcc AS INT64) AS merchant_mcc 
    ,ea_merchant_city AS merchant_city 
    ,ea_merchant_country AS merchant_country_code
    ,cc.country AS merchant_country_name
    ,CASE
        WHEN transactions_currency IN ("BCH", "BTC", "ETH", "LTC", "XRP") THEN 1
            ELSE 0
    END AS cryptocurrency
    ,ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY created_date DESC) AS transactions_rank
    ,CASE WHEN ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY created_date DESC) = 1 THEN 1 ELSE 0 END AS last_transaction
FROM `iconic-iridium-393108.ApexBank.transactions` AS t
LEFT JOIN `iconic-iridium-393108.ApexBank.country_code` AS cc
ON cc.code_3 = t.ea_merchant_country
