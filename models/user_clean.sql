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
FROM `ApexBank.users` u
left join `ApexBank.country_code` c
ON u.country=c.code