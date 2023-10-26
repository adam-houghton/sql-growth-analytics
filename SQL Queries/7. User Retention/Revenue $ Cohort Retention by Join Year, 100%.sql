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
        SUM(CASE WHEN `Table`.`Join Date` = year THEN `Table`.`Amount` ELSE 0 END) AS yearly_join_amount,
        SUM(CASE WHEN `Table`.`Leave Date` = year THEN `Table`.`Amount` ELSE 0 END) AS yearly_leave_amount
    FROM
        AllYears
    LEFT JOIN `Table`
    ON year = `Table`.`Join Date` OR year = `Table`.`Leave Date`
    GROUP BY
        year, `Table`.`Join Date`
),

CumulativeData AS (
    SELECT
        year - JoinYear AS age_in_years,
        CAST(JoinYear AS CHAR) AS JoinYear,
        SUM(yearly_join_amount - yearly_leave_amount) OVER (PARTITION BY JoinYear ORDER BY year ASC) AS cumulative_subscription_amount
    FROM
        YearAmounts
)

, NormalizationFactor AS (
    SELECT
        JoinYear,
        cumulative_subscription_amount AS normalization_factor
    FROM
        CumulativeData
    WHERE
        age_in_years = 0
)

, NormalizedData AS (
    SELECT
        c.age_in_years,
        c.JoinYear,
        (c.cumulative_subscription_amount / n.normalization_factor) * 100 AS normalized_cumulative_subscription_amount
    FROM
        CumulativeData c
    JOIN
        NormalizationFactor n
    ON
        c.JoinYear = n.JoinYear
)

, SimpleAverages AS (
    SELECT
        age_in_years,
        'average' AS JoinYear,
        AVG(normalized_cumulative_subscription_amount) AS normalized_cumulative_subscription_amount
    FROM
        NormalizedData
    GROUP BY
        age_in_years
)

SELECT * FROM NormalizedData
UNION ALL
SELECT * FROM SimpleAverages
ORDER BY JoinYear, age_in_years;
