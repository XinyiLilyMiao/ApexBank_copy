WITH u AS (
    SELECT 
        * 
    FROM {{ref('users_cleaned')}}
),

t AS (
    SELECT 
        user_id
        ,date_date
        ,transactions_type
        ,sum(amount_usd) AS amount_usd
    FROM {{ref('transactions_cleaned')}} 
    group by user_id,date_date,transactions_type
    order by user_id
),

d AS (
    SELECT 
        * 
    FROM {{ref('devices_cleaned')}}
),

activity AS (
    SELECT
        user_id
        ,ROUND((DATE_DIFF(max(date_date), min(date_date),DAY)/COUNT(DISTINCT date_date)),0) AS avg_days_inactivity
    FROM t
    group by user_id
    order by avg_days_inactivity
),

 notifications_filled AS (
    SELECT 
        DISTINCT user_id
        ,1 AS attributes_notifications_marketing_push_filled
        ,1 AS attributes_notifications_marketing_email_filled
    FROM {{ref("notifications_cleaned")}}
    WHERE reason_category LIKE ("Pro%")
),

users_filled AS (
    SELECT
        u.user_id
        -- Returns 1 if user gave consent to be notified or received a notification, else returns 0
        ,COALESCE(u.old_notifications_push_enabled, n.attributes_notifications_marketing_push_filled, 0) AS attributes_notifications_marketing_push_filled
        ,COALESCE(u.old_notifications_email_enabled, n.attributes_notifications_marketing_email_filled, 0) AS attributes_notifications_marketing_email_filled
    FROM {{ref('users_cleaned')}} AS u
    LEFT JOIN notifications_filled AS n
    ON u.user_id = n.user_id
),

transaction_dates AS (
    SELECT 
        user_id
        ,MAX(DATE(date_date)) AS last_transaction_date
        ,MIN(DATE(date_date)) AS first_transaction_date
    FROM {{ref('transactions_cleaned')}} 
    GROUP BY user_id
),
avg AS (
    SELECT
        user_id
        ,nb_transactions_day
    FROM {{ref('Average_daily_transactions')}}
)

SELECT 
    u.*
    ,d.device
    ,COALESCE(activity.avg_days_inactivity, DATE_DIFF('2019-05-16', u.member_at, DAY)) AS avg_days_inactivity
    ,COALESCE(avg.nb_transactions_day, 0) AS nb_transactions_day
        -- If the user has not made any transactions, we set the first and last transaction date equal to the date the account was created
    ,COALESCE(l.first_transaction_date, u.member_at) AS first_transaction_date
    ,COALESCE(l.last_transaction_date, u.member_at) AS last_transaction_date
    ,uf.attributes_notifications_marketing_push_filled AS notifications_push_enabled
    ,uf.attributes_notifications_marketing_email_filled AS notifications_email_enabled
    --
    ,DATE_DIFF(l.first_transaction_date, u.member_at, DAY) AS days_to_first_transaction
    ,DATE_DIFF(DATE '2019-05-16', l.last_transaction_date, DAY) AS days_since_last_transaction
    ,IF(DATE_DIFF(DATE '2019-05-16', l.last_transaction_date, DAY) >= 90, 1, 0) AS churned
FROM u
LEFT JOIN activity on u.user_id=activity.user_id
LEFT JOIN avg on u.user_id=avg.user_id
LEFT JOIN d on u.user_id=d.user_id
LEFT JOIN users_filled AS uf ON u.user_id = uf.user_id
LEFT JOIN transaction_dates AS l ON u.user_id = l.user_id