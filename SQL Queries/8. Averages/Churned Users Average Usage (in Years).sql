SELECT
  AVG(`Table`.`Leave Date` - `Table`.`Join Date`) AS `avg`
FROM
  `Table`
WHERE
  `Table`.`Leave Date` IS NOT NULL