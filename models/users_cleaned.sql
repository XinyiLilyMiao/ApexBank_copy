WITH notifications_filled AS (
    SELECT 
        DISTINCT user_id,
        1 AS attributes_notifications_marketing_push_filled,
        1 AS attributes_notifications_marketing_email_filled
    FROM notifications
),
users_filled AS (
    SELECT
        COALESCE(users.attributes_notifications_marketing_push, notifications_filled.attributes_notifications_marketing_push_filled) AS attributes_notifications_marketing_push_filled,
        COALESCE(users.attributes_notifications_marketing_email, notifications_filled.attributes_notifications_marketing_email_filled) AS attributes_notifications_marketing_email_filled
    FROM users
    LEFT JOIN notifications_filled
    ON users.user_id = notifications_filled.user_id
)
--SELECT * FROM users_filled;

SELECT 
SUBSTR(user_id, 
(STRPOS(user_id, '_') + 1), 
(LENGTH(user_id) - STRPOS(user_id, '_'))
) AS user_id
,birth_year
,2019-birth_year AS age
,c.country AS country
,city
,created_date as member_at
,Extract(DATE FROM created_date) AS date
,Extract(YEAR FROM created_date) AS year
,Extract(MONTH FROM created_date) AS month
,Extract(DAY FROM created_date) AS day
,CAST(user_settings_crypto_unlocked AS BOOLEAN) AS crypto_unlocked
,plan
,CAST(users_filled.attributes_notifications_marketing_push_filled AS BOOLEAN) AS notifications_push_enabled
,CAST(users_filled.attributes_notifications_marketing_email_filled AS BOOLEAN) AS notifications_email_enabled
,num_contacts
FROM `ApexBank.users` AS u
LEFT JOIN `ApexBank.country_code` AS c ON u.country=c.code