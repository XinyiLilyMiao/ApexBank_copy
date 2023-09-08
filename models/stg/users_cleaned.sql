WITH notifications_filled AS (
    SELECT 
        DISTINCT user_id
        ,1 AS attributes_notifications_marketing_push_filled
        ,1 AS attributes_notifications_marketing_email_filled
    FROM `iconic-iridium-393108.ApexBank.notifications`
),

users_filled AS (
    SELECT
        u.user_id
        ,Extract(DATE FROM u.created_date) AS member_at
        -- Returns 1 if user gave consent to be notified or received a notification, else returns 0
        ,COALESCE(u.attributes_notifications_marketing_push, n.attributes_notifications_marketing_push_filled, 0) AS attributes_notifications_marketing_push_filled
        ,COALESCE(u.attributes_notifications_marketing_email, n.attributes_notifications_marketing_email_filled, 0) AS attributes_notifications_marketing_email_filled
    FROM `iconic-iridium-393108.ApexBank.users` AS u
    LEFT JOIN notifications_filled AS n
    ON u.user_id = n.user_id
),

transaction_dates AS (
    SELECT 
        user_id
        ,MAX(DATE(created_date)) AS last_transaction_date
        ,MIN(DATE(created_date)) AS first_transaction_date
    FROM `iconic-iridium-393108.ApexBank.transactions`
    GROUP BY user_id
)

SELECT 
    CAST(SUBSTR(u.user_id, (STRPOS(u.user_id, '_') + 1), (LENGTH(u.user_id) - STRPOS(u.user_id, '_'))) AS INT64) AS user_id
    ,u.birth_year AS birth_year
    ,2019 - u.birth_year AS age
    ,cc.country AS country
    ,CASE
        WHEN REGEXP_CONTAINS(LOWER(city),'london') THEN 'London'
        WHEN REGEXP_CONTAINS(LOWER(city),'warszawa OR warsaw') THEN 'Warszawa'
        WHEN REGEXP_CONTAINS(LOWER(city),'paris') THEN 'Paris'
        WHEN REGEXP_CONTAINS(LOWER(city),'dublin') THEN 'Dublin'
        WHEN REGEXP_CONTAINS(LOWER(city),'vilnius') THEN 'Vilnius'
        ELSE "other"
    END AS top_city
    ,uf.member_at AS member_at
    ,Extract(YEAR FROM u.created_date) AS year
    ,Extract(MONTH FROM u.created_date) AS month
    ,Extract(DAY FROM u.created_date) AS day 
    ,DATE_DIFF('2019-05-16', uf.member_at, DAY) as days_joined
    ,CAST(u.user_settings_crypto_unlocked AS INT64) AS crypto_unlocked
    ,u.plan AS plan
    ,CAST(uf.attributes_notifications_marketing_push_filled AS INT64) AS notifications_push_enabled
    ,CAST(uf.attributes_notifications_marketing_email_filled AS INT64) AS notifications_email_enabled
    ,u.num_contacts AS num_contacts
    -- If the user has not made any transactions, we set the first and last transaction date equal to the date the account was created
    ,COALESCE(l.first_transaction_date, uf.member_at) AS first_transaction_date
    ,COALESCE(l.last_transaction_date, uf.member_at) AS last_transaction_date
    --
    ,DATE_DIFF(l.first_transaction_date, uf.member_at, DAY) AS days_to_first_transaction
    ,DATE_DIFF(DATE '2019-05-16', l.last_transaction_date, DAY) AS days_since_last_transaction
    ,IF(DATE_DIFF(DATE '2019-05-16', l.last_transaction_date, DAY) >= 90, 1, 0) AS churned
FROM `iconic-iridium-393108.ApexBank.users` AS u
LEFT JOIN `iconic-iridium-393108.ApexBank.country_code` AS cc ON u.country = cc.code_2
LEFT JOIN users_filled AS uf ON u.user_id = uf.user_id
LEFT JOIN transaction_dates AS l ON u.user_id = l.user_id