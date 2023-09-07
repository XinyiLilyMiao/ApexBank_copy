SELECT d.string_field_0 AS device
,CAST(SUBSTR(d.string_field_1, (STRPOS(d.string_field_1, '_') + 1), (LENGTH(d.string_field_1) - STRPOS(d.string_field_1, '_'))) AS INT64) AS user_id 
FROM `ApexBank.devices` AS d