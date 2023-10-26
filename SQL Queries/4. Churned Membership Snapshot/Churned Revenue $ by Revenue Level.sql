SELECT
  `Table`.`Amount` AS `Amount`,
  SUM(`Table`.`Amount`) AS `sum`
FROM
  `Table`
WHERE
  `Table`.`Leave Date` IS NOT NULL
GROUP BY
  `Table`.`Amount`
ORDER BY
  `sum` ASC,
  `Table`.`Amount` ASC