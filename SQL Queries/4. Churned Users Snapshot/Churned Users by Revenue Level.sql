SELECT
  `Table`.`Amount` AS `Amount`,
  COUNT(*) AS `count`
FROM
  `Table`
WHERE
  `Table`.`Leave Date` IS NOT NULL
GROUP BY
  `Table`.`Amount`
ORDER BY
  `count` ASC,
  `Table`.`Amount` ASC