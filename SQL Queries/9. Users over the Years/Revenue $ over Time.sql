WITH AllDates AS (
    SELECT `Table`.`Join Date` AS date
    FROM `Table`
    WHERE `Table`.`Join Date` > 0
    UNION
    SELECT `Table`.`Leave Date` AS date
    FROM `Table`
    WHERE `Table`.`Leave Date` IS NOT NULL
),

DateAmounts AS (
    SELECT
        date,
        SUM(CASE WHEN `Table`.`Join Date` = date THEN `Table`.`Amount` ELSE 0 END) AS join_amount,
        SUM(CASE WHEN `Table`.`Leave Date` = date THEN `Table`.`Amount` ELSE 0 END) AS leave_amount
    FROM
        AllDates
    LEFT JOIN `Table`
    ON date = `Table`.`Join Date` OR date = `Table`.`Leave Date`
    GROUP BY
        date
)

SELECT
    date,
    SUM(join_amount - leave_amount) OVER (ORDER BY date ASC) AS cumulative_subscription_amount
FROM
    DateAmounts
WHERE date < '2024-01-01'
ORDER BY
    date;
