SELECT
  `Table`.`Leave Date` AS `Leave Date`,
  COUNT(*) AS `count`
FROM
  `Table`
WHERE
  (`Table`.`Join Date` > 0)
 
   AND (`Table`.`Leave Date` IS NOT NULL)
GROUP BY
  `Table`.`Leave Date`
ORDER BY
  `Table`.`Leave Date` ASC