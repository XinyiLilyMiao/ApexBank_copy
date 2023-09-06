WITH u AS (
    SELECT 
    * 
    ,DATE_DIFF('2019-05-16', member_at, DAY) as days_joined
    FROM {{ref('users_cleaned')}}
),

 t AS(SELECT 
    user_id
    ,date_date
    ,transactions_type
    ,sum(amount_usd) AS amount_usd
    FROM {{ref('transactions_cleaned')}} 
    group by user_id,date_date,transactions_type
    order by user_id
),
activity AS(SELECT
    user_id
    ,ROUND((DATE_DIFF(max(date_date), min(date_date),DAY)/COUNT(DISTINCT date_date)),0) AS avg_days_inactivity
    FROM t
    group by user_id
    order by avg_days_inactivity
),
avg AS(SELECT
    user_id
    ,nb_transactions_day
    FROM {{ref('Average_daily_transactions')}}
)

SELECT 
u.*
,activity.avg_days_inactivity
,avg.nb_transactions_day
FROM u
LEFT JOIN activity on u.user_id=activity.user_id
LEFT JOIN avg on u.user_id=avg.user_id




