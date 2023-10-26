WITH DateCounts AS (
    SELECT
        `Table`.`Leave Date` AS `Leave Date`,
        COUNT(ID) as leave_count
    FROM
        `Table`
    WHERE
        `Leave Date` IS NOT NULL
    GROUP BY
        `Leave Date`
)

SELECT
    `Leave Date`,
    SUM(leave_count) OVER (ORDER BY `Leave Date` ASC) AS cumulative_leave_count
FROM
    DateCounts
WHERE
    `Leave Date` <2024
ORDER BY
    `Leave Date`;
