SELECT
  ,reason
  ,channel
  ,status
  ,CAST(SUBSTR(u.user_id, (STRPOS(u.user_id, '_') + 1), (LENGTH(u.user_id) - STRPOS(u.user_id, '_'))) AS INT64) AS user_id
  ,created_date
  ,Extract(DATE FROM created_date) AS notification_date
  ,CASE
    WHEN reason IN ('BLACK_FRIDAY','FIFTH_PAYMENT_PROMO') THEN 'Promotions'
    WHEN reason IN ('LOST_CARD_ORDER', 'NO_INITIAL_FREE_PROMOPAGE_CARD_ORDER') THEN 'Card'
    WHEN reason IN ('REENGAGEMENT_ACTIVE_FUNDS', 'PUMPKIN_PAYMENT_NOTIFICATION', 'PREMIUM_ENGAGEMENT_FEES_SAVED', 'ONBOARDING_TIPS_ACTIVATED_USERS', 'PREMIUM_ENGAGEMENT_INACTIVE_CARD', 'NO_INITIAL_CARD_USE', 'NO_INITIAL_CARD_ORDER') THEN 'Information'
    WHEN reason IN ('WELCOME_HOME', 'METAL_GAME_START', 'METAL_RESERVE_PLAN', 'JOINING_ANNIVERSARY') THEN 'Engagement'
    WHEN reason IN ('ENGAGEMENT_SPLIT_BILL_RESTAURANT', 'MADE_MONEY_REQUEST_NOT_SPLIT_BILL') THEN 'Transactions'
  END AS reason_category
FROM 
`iconic-iridium-393108.ApexBank.notifications`
