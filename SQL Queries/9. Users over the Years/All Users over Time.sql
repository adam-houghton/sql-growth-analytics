WITH DateCounts AS (
    SELECT
        `Table`.`Join Date` AS `Join Date`,
        COUNT(ID) as join_count
    FROM
        `Table`
    WHERE `Join Date` >0
    GROUP BY
        `Join Date`
)

SELECT
    `Join Date`,
    SUM(join_count) OVER (ORDER BY `Join Date` ASC) AS cumulative_join_count
FROM
    DateCounts
ORDER BY
    `Join Date`;
