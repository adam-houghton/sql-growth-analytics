SELECT
  `Table`.`Join Date` AS `Join Date`,
  SUM(`Table`.`Amount`) AS `sum`
FROM
  `Table`
WHERE
  (`Table`.`Join Date` > 0)
 
   AND (`Table`.`Leave Date` IS NOT NULL)
GROUP BY
  `Table`.`Join Date`
ORDER BY
  `Table`.`Join Date` ASC