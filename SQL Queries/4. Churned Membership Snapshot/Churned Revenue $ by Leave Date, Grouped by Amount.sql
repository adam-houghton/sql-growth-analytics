SELECT
  `Table`.`Leave Date` AS `Leave Date`,
  `Table`.`Amount` AS `Amount`,
  SUM(`Table`.`Amount`) AS `sum`
FROM
  `Table`
WHERE
  `Table`.`Leave Date` IS NOT NULL
GROUP BY
  `Table`.`Leave Date`,
  `Table`.`Amount`
ORDER BY
  `Table`.`Leave Date` ASC,
  `Table`.`Amount` ASC