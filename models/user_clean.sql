SELECT 
SUBSTR(user_id, 
(STRPOS(user_id, '_') + 1), 
(LENGTH(user_id) - STRPOS(user_id, '_'))
) AS user_id
,birth_year
,2019-birth_year AS age
,c.country AS country
,CASE
 WHEN REGEXP_CONTAINS(LOWER(city),'london') THEN 'London'
 WHEN REGEXP_CONTAINS(LOWER(city),'warszawa OR warsaw') THEN 'Warszawa'
 WHEN REGEXP_CONTAINS(LOWER(city),'paris') THEN 'Paris'
 WHEN REGEXP_CONTAINS(LOWER(city),'dublin') THEN 'Dublin'
 WHEN REGEXP_CONTAINS(LOWER(city),'vilnius') THEN 'Vilnius'
ELSE "other"
END AS top_city
,Extract(DATE FROM created_date) AS member_at
,Extract(YEAR FROM created_date) AS year
,Extract(MONTH FROM created_date) AS month
,Extract(DAY FROM created_date) AS day 
FROM `ApexBank.users` u
left join `ApexBank.country_code` c
ON u.country=c.code_2
