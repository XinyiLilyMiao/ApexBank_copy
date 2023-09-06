WITH u AS (
    SELECT * 
    ,DATE_DIFF('2019-05-16', member_at, DAY) as days_joined
    FROM {{ref('users_cleaned')}}
),
t AS (
    SELECT * FROM {{ref('transactions_cleaned')}}
    )




