SELECT
  `Table`.`Join Date` AS `Join Date`,
  `Table`.`Amount` AS `Amount`,
  COUNT(*) AS `count`
FROM
  `Table`
WHERE
  (`Table`.`Join Date` > 0)
 
   AND (`Table`.`Leave Date` IS NOT NULL)
GROUP BY
  `Table`.`Join Date`,
  `Table`.`Amount`
ORDER BY
  `Table`.`Join Date` ASC,
  `Table`.`Amount` ASC