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
    ,Extract(DATE FROM u.created_date) AS member_at
    ,Extract(YEAR FROM u.created_date) AS year
    ,Extract(MONTH FROM u.created_date) AS month
    ,Extract(DAY FROM u.created_date) AS day 
    ,DATE_DIFF('2019-05-16', Extract(DATE FROM u.created_date), DAY) as days_joined
    ,CAST(u.user_settings_crypto_unlocked AS INT64) AS crypto_unlocked
    ,u.plan AS plan
    ,CAST(u.attributes_notifications_marketing_push AS INT64) AS old_notifications_push_enabled
    ,CAST(u.attributes_notifications_marketing_email AS INT64) AS old_notifications_email_enabled
    ,u.num_contacts AS num_contacts
FROM `iconic-iridium-393108.ApexBank.users` AS u
LEFT JOIN `iconic-iridium-393108.ApexBank.country_code` AS cc ON u.country = cc.code_2
