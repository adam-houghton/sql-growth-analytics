SELECT 
    `Table`.`Amount`,
    COUNT(DISTINCT `Table`.`ID`) AS individual_customer_count,
    SUM(`Table`.`Amount`) AS individual_revenue_amount,
    (@cumulative_count := @cumulative_count + COUNT(DISTINCT `Table`.`ID`)) AS cumulative_customer_count,
    (@cumulative_revenue := @cumulative_revenue + SUM(`Table`.`Amount`)) AS cumulative_revenue_amount,
    (@cumulative_count / 
        (SELECT COUNT(DISTINCT `ID`) FROM `Table` WHERE `Leave Date` IS NULL) * 100
    ) AS cumulative_customer_percentage,
    (@cumulative_revenue / 
        (SELECT SUM(`Amount`) FROM `Table` WHERE `Leave Date` IS NULL) * 100
    ) AS cumulative_revenue_percentage
FROM 
    `Table`,
    (SELECT @cumulative_count := 0, @cumulative_revenue := 0.0) AS initializers
WHERE
    `Table`.`Leave Date` IS NULL
GROUP BY 
    `Table`.`Amount`
ORDER BY 
    `Table`.`Amount`;
