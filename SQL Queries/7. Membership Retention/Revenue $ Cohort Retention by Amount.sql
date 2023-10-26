WITH AllYears AS (
    SELECT `Table`.`Join Date` AS year
    FROM `Table`
    UNION
    SELECT `Table`.`Leave Date` AS year
    FROM `Table`
    WHERE `Table`.`Leave Date` IS NOT NULL
),

YearAmounts AS (
    SELECT
        year,
        `Table`.`Join Date` AS JoinYear,
        `Table`.`Amount` AS Amount,
        SUM(CASE WHEN `Table`.`Join Date` = year THEN `Table`.`Amount` ELSE 0 END) AS yearly_join_amount,
        SUM(CASE WHEN `Table`.`Leave Date` = year THEN `Table`.`Amount` ELSE 0 END) AS yearly_leave_amount
    FROM
        AllYears
    LEFT JOIN `Table`
    ON year = `Table`.`Join Date` OR year = `Table`.`Leave Date`
    GROUP BY
        year, `Table`.`Amount`, `Table`.`Join Date`
),

AgeCalculated AS (
    SELECT 
        (year - JoinYear) AS age,
        Amount,
        SUM(yearly_join_amount - yearly_leave_amount) AS yearly_net_amount
    FROM 
        YearAmounts
    GROUP BY 
        Amount, age
),

CumulativeTotals AS (
    SELECT 
        a1.age,
        a1.Amount,
        SUM(a2.yearly_net_amount) AS total
    FROM 
        AgeCalculated a1
    JOIN 
        AgeCalculated a2 ON a1.Amount = a2.Amount AND a1.age >= a2.age
    GROUP BY 
        a1.Amount, a1.age
)

, SimpleAverages AS (
    SELECT
        age,
        'average' AS Amount,
        AVG(total) AS total
    FROM
        CumulativeTotals
    GROUP BY
        age
)

SELECT *
FROM 
    CumulativeTotals
UNION ALL
SELECT * FROM SimpleAverages
ORDER BY 
    Amount, age;

