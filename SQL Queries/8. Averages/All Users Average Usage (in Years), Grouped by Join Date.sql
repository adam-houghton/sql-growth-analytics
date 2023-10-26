SELECT
  `Table`.`Join Date`, 
  AVG(COALESCE(`Table`.`Leave Date`, CURDATE()) - `Table`.`Join Date`) AS `avg`,
  COUNT(*) AS `total_records`
FROM
  `Table`
WHERE
  `Table`.`Join Date` > 0
GROUP BY `Table`.`Join Date`
ORDER BY `Table`.`Join Date`
