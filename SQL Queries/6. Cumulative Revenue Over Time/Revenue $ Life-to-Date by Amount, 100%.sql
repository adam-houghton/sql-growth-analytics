WITH AllYears AS (
    SELECT DISTINCT `Table`.`Join Date` AS year
    FROM `Table`
    UNION
    SELECT DISTINCT year FROM (
        SELECT DATE_ADD(`Table`.`Join Date`, INTERVAL n.year YEAR) AS year
        FROM `Table`, (SELECT 0 AS year UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) AS n
        WHERE DATE_ADD(`Table`.`Join Date`, INTERVAL n.year YEAR) <= COALESCE(`Table`.`Leave Date`, CURDATE())
    ) AS Derived
),

YearlyActiveRevenue AS (
    SELECT
        AllYears.year,
        `Table`.`Amount` AS Amount,
        `Table`.`Join Date` AS JoinYear,
        sum(`Table`.`Amount`) AS active_revenue
    FROM
        AllYears
    LEFT JOIN `Table`
    ON `Table`.`Join Date` <= AllYears.year AND (AllYears.year < `Table`.`Leave Date` OR `Table`.`Leave Date` IS NULL)
    GROUP BY
        AllYears.year, `Table`.`Join Date`,`Table`.`Amount`
),

AgeCalculated AS (
    SELECT 
        (year - JoinYear) AS age,
        Amount,
        sum(active_revenue) AS yearly_net_amount
    FROM 
        YearlyActiveRevenue
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
),

NormalizationFactor AS (
    SELECT
        Amount,
        total AS normalization_factor
    FROM
        CumulativeTotals
    WHERE
        age = 0
),

NormalizedData AS (
    SELECT
        c.age,
        c.Amount,
        (c.total / n.normalization_factor) * 100 AS normalized_cumulative_revenue
    FROM
        CumulativeTotals c
    JOIN
        NormalizationFactor n
    ON
        c.Amount = n.Amount
)

SELECT age, Amount, normalized_cumulative_revenue
FROM NormalizedData
ORDER BY Amount, age;
