WITH AllDates AS (
    SELECT `Table`.`Join Date` AS date
    FROM `Table`
    WHERE `Table`.`Join Date` > 0
    UNION
    SELECT `Table`.`Leave Date` AS date
    FROM `Table`
    WHERE `Table`.`Leave Date` IS NOT NULL
),

DistinctAmounts AS (
    SELECT DISTINCT `Amount` FROM `Table`
),

AllDateAmountCombos AS (
    SELECT date, `Amount`
    FROM AllDates
    CROSS JOIN DistinctAmounts
),

DateAmounts AS (
    SELECT
        date,
        `Table`.`Amount`,
        SUM(CASE WHEN `Table`.`Join Date` = date THEN `Table`.`Amount` ELSE 0 END) AS join_amount,
        SUM(CASE WHEN `Table`.`Leave Date` = date THEN `Table`.`Amount` ELSE 0 END) AS leave_amount
    FROM
        AllDates
    LEFT JOIN `Table`
    ON date = `Table`.`Join Date` OR date = `Table`.`Leave Date`
    GROUP BY
        date, `Table`.`Amount`
)

SELECT
    da.date,
    da.`Amount`,
    COALESCE(SUM(dam.join_amount - dam.leave_amount) OVER (
        PARTITION BY da.`Amount` 
        ORDER BY da.date ASC
    ), 0) AS cumulative_subscription_amount_per_group
FROM
    AllDateAmountCombos da
LEFT JOIN DateAmounts dam
ON da.date = dam.date AND da.`Amount` = dam.`Amount`
WHERE da.date < '2024-01-01'
ORDER BY
    da.date, da.`Amount`;
