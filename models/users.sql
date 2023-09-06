<<<<<<< HEAD
WITH users AS (
    SELECT * FROM {{ref('users_cleaned')}}
    ),

transaction AS (
    SELECT * FROM {{ ref('transactions_cleaned') }}
=======
WITH u AS (
    SELECT * 
    ,DATE_DIFF('2019-05-16', member_at, DAY) as days_joined
    FROM {{ref('users_cleaned')}}
),
t AS (
    SELECT * FROM {{ref('transactions_cleaned')}}
>>>>>>> c72a078eba43861cfe869a25f45305d356cec056
    )




