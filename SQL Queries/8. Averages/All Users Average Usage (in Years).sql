SELECT
  AVG(COALESCE(`Table`.`Leave Date`, CURDATE()) - `Table`.`Join Date`) AS `avg`
FROM
  `Table`
WHERE `Table`.`Join Date` > 0