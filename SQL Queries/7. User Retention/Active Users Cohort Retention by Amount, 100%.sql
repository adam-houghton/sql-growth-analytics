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
        SUM(CASE WHEN `Table`.`Join Date` = year THEN 1 ELSE 0 END) AS yearly_join_amount,
        SUM(CASE WHEN `Table`.`Leave Date` = year THEN 1 ELSE 0 END) AS yearly_leave_amount
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

, NormalizationFactor AS (
    SELECT
        Amount,
        total AS normalization_factor
    FROM
        CumulativeTotals
    WHERE
        age = 0
)

, NormalizedData AS (
    SELECT
        c.age,
        c.Amount,
        (c.total / n.normalization_factor) * 100 AS normalized_cumulative_subscription_count
    FROM
        CumulativeTotals c
    JOIN
        NormalizationFactor n
    ON
        c.Amount = n.Amount
)

, SimpleAverages AS (
    SELECT
        age,
        'average' AS Amount,
        AVG(normalized_cumulative_subscription_count) AS normalized_cumulative_subscription_count
    FROM
        NormalizedData
    GROUP BY
        age
)

SELECT * FROM NormalizedData
UNION ALL
SELECT * FROM SimpleAverages
ORDER BY 
    Amount, age;

