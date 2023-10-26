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
        `Table`.`Join Date` AS JoinYear,
        SUM(`Table`.`Amount`) AS active_revenue
    FROM
        AllYears
    LEFT JOIN `Table`
    ON `Table`.`Join Date` <= AllYears.year AND (AllYears.year < `Table`.`Leave Date` OR `Table`.`Leave Date` IS NULL)
    GROUP BY
        AllYears.year, `Table`.`Join Date`
),

CumulativeRevenueData AS (
    SELECT
        year - JoinYear AS age_in_years,
        CAST(JoinYear AS CHAR) AS JoinYear,
        SUM(active_revenue) OVER (PARTITION BY JoinYear ORDER BY year ASC) AS cumulative_revenue
    FROM
        YearlyActiveRevenue
)

SELECT age_in_years, JoinYear, cumulative_revenue
FROM CumulativeRevenueData
ORDER BY JoinYear, age_in_years;
