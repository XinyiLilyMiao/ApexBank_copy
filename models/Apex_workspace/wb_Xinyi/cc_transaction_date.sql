WITH t AS(SELECT 
Cast(created_date as string) as created FROM `ApexBank.users` 
)
SELECT
*
FROM t
WHERE created not LIKE("%+00")