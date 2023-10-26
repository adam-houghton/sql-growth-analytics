SELECT
  `Table`.`Leave Date` AS `Leave Date`,
  `Table`.`Amount` AS `Amount`,
  COUNT(*) AS `count`
FROM
  `Table`
WHERE
  (`Table`.`Join Date` > 0)
 
   AND (`Table`.`Leave Date` IS NOT NULL)
GROUP BY
  `Table`.`Leave Date`,
  `Table`.`Amount`
ORDER BY
  `Table`.`Leave Date` ASC,
  `Table`.`Amount` ASC