SELECT
  `Table`.`Join Date`, 
  AVG(`Table`.`Leave Date` - `Table`.`Join Date`) AS `avg`,
  COUNT(*) AS `total_records`
FROM
  `Table`
WHERE
  `Table`.`Leave Date` IS NOT NULL
GROUP BY `Table`.`Join Date`
ORDER BY `Table`.`Join Date`
