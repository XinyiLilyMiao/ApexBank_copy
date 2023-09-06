CREATE TABLE `iconic-iridium-393108.ApexBank.notifications_with_formatted_date`
AS
SELECT
  reason,
  channel,
  status,
  user_id,
  created_date,
  FORMAT_TIMESTAMP('%Y-%m-%d', created_date) AS formatted_date
FROM
   `iconic-iridium-393108.ApexBank.notifications`;