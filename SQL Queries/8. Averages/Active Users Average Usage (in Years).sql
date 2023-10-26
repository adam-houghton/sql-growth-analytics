SELECT
  AVG(year(CURDATE()) - `Table`.`Join Date`) AS `avg`
FROM
  `Table`
WHERE
  `Table`.`Leave Date` IS NULL AND `Table`.`Join Date` > 0