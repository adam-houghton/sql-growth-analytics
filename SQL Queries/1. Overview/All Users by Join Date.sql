SELECT
  `Table`.`Join Date` AS `Join Date`,
  COUNT(*) AS `count`
FROM
  `Table`
WHERE
  `Table`.`Join Date` > 0
GROUP BY
  `Table`.`Join Date`
ORDER BY
  `Table`.`Join Date` ASC