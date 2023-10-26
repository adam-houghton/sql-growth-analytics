SELECT
  `Table`.`Leave Date` AS `Leave Date`,
  SUM(`Table`.`Amount`) AS `sum`
FROM
  `Table`
WHERE
  `Table`.`Leave Date` IS NOT NULL
GROUP BY
  `Table`.`Leave Date`
ORDER BY
  `Table`.`Leave Date` ASC