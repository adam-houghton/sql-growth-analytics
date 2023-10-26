SELECT
  `Table`.`Amount`, 
  AVG(`Table`.`Leave Date` - `Table`.`Join Date`) AS `avg`,
  COUNT(*) AS `total_records`
FROM
  `Table`
WHERE
  `Table`.`Leave Date` IS NOT NULL
GROUP BY `Table`.`Amount`
HAVING COUNT(*) >= 5
ORDER BY `Table`.`Amount`
