SELECT * 
,DATE_DIFF('2019-05-16', u.member_at, DAY) as days_joined
FROM {{ref('users_cleaned')}} as u



