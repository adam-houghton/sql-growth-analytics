WITH AllDates AS (
    SELECT `Table`.`Join Date` AS date
    FROM `Table`
    WHERE `Table`.`Join Date` > 0
    UNION
    SELECT `Table`.`Leave Date` AS date
    FROM `Table`
    WHERE `Table`.`Leave Date` IS NOT NULL
),

DateCounts AS (
    SELECT
        date,
        SUM(CASE WHEN `Table`.`Join Date` = date THEN 1 ELSE 0 END) AS join_count,
        SUM(CASE WHEN `Table`.`Leave Date` = date THEN 1 ELSE 0 END) AS leave_count
    FROM
        AllDates
    LEFT JOIN `Table`
    ON date = `Table`.`Join Date` OR date = `Table`.`Leave Date`
    GROUP BY
        date
)

SELECT
    date,
    SUM(join_count - leave_count) OVER (ORDER BY date ASC) AS active_members_over_time,
    join_count,
    leave_count * -1
FROM
    DateCounts
WHERE date <2024
ORDER BY
    date;
