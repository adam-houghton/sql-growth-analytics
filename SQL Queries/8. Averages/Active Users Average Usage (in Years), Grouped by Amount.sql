SELECT
  `Table`.`Amount`, 
  AVG(year(CURDATE()) - `Table`.`Join Date`) AS `avg`,
  COUNT(*) AS `total_records`
FROM
  `Table`
WHERE
  `Table`.`Leave Date` IS NULL AND `Table`.`Join Date` > 0
GROUP BY `Table`.`Amount`
HAVING COUNT(*) >= 5
ORDER BY `Table`.`Amount`
