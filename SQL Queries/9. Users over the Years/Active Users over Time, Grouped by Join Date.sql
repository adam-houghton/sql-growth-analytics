WITH AllDates AS (
    SELECT `Table`.`Join Date` AS date
    FROM `Table`
    WHERE `Table`.`Join Date` > 0
    UNION
    SELECT `Table`.`Leave Date` AS date
    FROM `Table`
    WHERE `Table`.`Leave Date` IS NOT NULL
),

DistinctJoinDates AS (
    SELECT DISTINCT `Join Date` FROM `Table`
),

AllDateJoinDateCombos AS (
    SELECT date, `Join Date`
    FROM AllDates
    CROSS JOIN DistinctJoinDates
),

DateAmounts AS (
    SELECT
        date,
        `Table`.`Join Date`,
        `Table`.`Amount`,
        SUM(CASE WHEN `Table`.`Join Date` = date THEN 1 ELSE 0 END) AS join_amount,
        SUM(CASE WHEN `Table`.`Leave Date` = date THEN 1 ELSE 0 END) AS leave_amount
    FROM
        AllDates
    LEFT JOIN `Table`
    ON date = `Table`.`Join Date` OR date = `Table`.`Leave Date`
    GROUP BY
        date, `Table`.`Join Date`
)

SELECT
    da.date,
    da.`Join Date`,
    COALESCE(SUM(dam.join_amount - dam.leave_amount) OVER (
        PARTITION BY da.`Join Date` 
        ORDER BY da.date ASC
    ), 0) AS cumulative_subscription_amount_per_join_date
FROM
    AllDateJoinDateCombos da
LEFT JOIN DateAmounts dam
ON da.date = dam.date AND da.`Join Date` = dam.`Join Date`
WHERE da.date < '2024-01-01'
ORDER BY
    da.date, da.`Join Date`;
