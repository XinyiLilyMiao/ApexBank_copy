WITH users AS (
    SELECT * FROM {{ref('users_cleaned')}}
    ),

transaction AS (
    SELECT * FROM {{ref('transaction_cleaned')}}
    )


