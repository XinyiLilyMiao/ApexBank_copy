SELECT 
user_id
,birth_year
,country
,city
,created_date
,FROM `ApexBank.users` 
WHERE user_id IS NULL
OR birth_year IS NULL
OR country IS NULL
OR city IS NULL
