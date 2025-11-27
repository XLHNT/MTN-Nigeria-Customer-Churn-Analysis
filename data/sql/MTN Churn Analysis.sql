SELECT *
FROM [MTN Nigeria Customer Churn].dbo.['MTN Nigeria Customer Churn$']




 --1.          CHURN RATE BY DEMOGRAPHICS


 --1.1    Churn Rate by State, Age Group, and Gender

 SELECT 
    State,
    CASE
        WHEN Age BETWEEN 16 AND 25 THEN '16-25'
        WHEN Age BETWEEN 26 AND 35 THEN '26-35'
        WHEN Age BETWEEN 36 AND 45 THEN '36-45'
        WHEN Age BETWEEN 46 AND 55 THEN '46-55'
        WHEN Age BETWEEN 56 AND 65 THEN '56-65'
        ELSE '66+'
    END AS Age_Group,
    Gender,
    COUNT(*) AS Total_Customers,
    SUM(CASE WHEN [Customer Churn Status] = 'Yes' THEN 1 ELSE 0 END) AS Churned_Customers,
    CAST(SUM(CASE WHEN [Customer Churn Status] = 'Yes' THEN 1 ELSE 0 END) AS FLOAT) * 100.0 / COUNT(*) AS Churn_Rate_Percentage
FROM [MTN Nigeria Customer Churn].dbo.['MTN Nigeria Customer Churn$']
GROUP BY
    State,
    CASE
        WHEN Age BETWEEN 16 AND 25 THEN '16-25'
        WHEN Age BETWEEN 26 AND 35 THEN '26-35'
        WHEN Age BETWEEN 36 AND 45 THEN '36-45'
        WHEN Age BETWEEN 46 AND 55 THEN '46-55'
        WHEN Age BETWEEN 56 AND 65 THEN '56-65'
        ELSE '66+'
    END,
    Gender
ORDER BY Churn_Rate_Percentage DESC, Total_Customers DESC;



--1.2      State-wise Churn Rate Summary

SELECT 
    State,
    COUNT(*) AS Total_Customers,
    SUM(CASE WHEN [Customer Churn Status] = 'Yes' THEN 1 ELSE 0 END) AS Churned_Customers,
    CAST(SUM(CASE WHEN [Customer Churn Status] = 'Yes' THEN 1 ELSE 0 END) AS FLOAT) * 100.0 / COUNT(*) AS Churn_Rate_Percentage
FROM [MTN Nigeria Customer Churn].dbo.['MTN Nigeria Customer Churn$']
GROUP BY State
ORDER BY Churn_Rate_Percentage DESC;



--1.3      Age Group Analysis

SELECT 
    CASE
        WHEN Age BETWEEN 16 AND 25 THEN '16-25'
        WHEN Age BETWEEN 26 AND 35 THEN '26-35'
        WHEN Age BETWEEN 36 AND 45 THEN '36-45'
        WHEN Age BETWEEN 46 AND 55 THEN '46-55'
        WHEN Age BETWEEN 56 AND 65 THEN '56-65'
        ELSE '66+'
    END AS Age_Group,
    COUNT(*) AS Total_Customers,
    SUM(CASE WHEN [Customer Churn Status] = 'Yes' THEN 1 ELSE 0 END) AS Churned_Customers,
    CAST(SUM(CASE WHEN [Customer Churn Status] = 'Yes' THEN 1 ELSE 0 END) AS FLOAT) * 100.0 / COUNT(*) AS Churn_Rate_Percentage
FROM [MTN Nigeria Customer Churn].dbo.['MTN Nigeria Customer Churn$']
GROUP BY
    CASE
        WHEN Age BETWEEN 16 AND 25 THEN '16-25'
        WHEN Age BETWEEN 26 AND 35 THEN '26-35'
        WHEN Age BETWEEN 36 AND 45 THEN '36-45'
        WHEN Age BETWEEN 46 AND 55 THEN '46-55'
        WHEN Age BETWEEN 56 AND 65 THEN '56-65'
        ELSE '66+'
    END
ORDER BY Churn_Rate_Percentage DESC;




  --2.          IMPACT OF SUBSCRIPTION PLAN AND DEVICE ON CHURN 


 --2.1    Churn Rate by Subscription Plan

SELECT 
    [Subscription Plan],
    COUNT(*) AS Total_Customers,
    SUM(CASE WHEN [Customer Churn Status] = 'Yes' THEN 1 ELSE 0 END) AS Churned_Customers,
    CAST(SUM(CASE WHEN [Customer Churn Status] = 'Yes' THEN 1 ELSE 0 END) AS FLOAT) * 100.0 / COUNT(*) AS Churn_Rate_Percentage
FROM [MTN Nigeria Customer Churn].dbo.['MTN Nigeria Customer Churn$']
GROUP BY [Subscription Plan]
ORDER BY Churn_Rate_Percentage DESC;



--2.2     Churn Rate by MTN Device

SELECT 
    [MTN Device],
    COUNT(*) AS Total_Customers,
    SUM(CASE WHEN [Customer Churn Status] = 'Yes' THEN 1 ELSE 0 END) AS Churned_Customers,
    CAST(SUM(CASE WHEN [Customer Churn Status] = 'Yes' THEN 1 ELSE 0 END) AS FLOAT) * 100.0 / COUNT(*) AS Churn_Rate_Percentage
FROM [MTN Nigeria Customer Churn].dbo.['MTN Nigeria Customer Churn$']
GROUP BY [MTN Device]
ORDER BY Churn_Rate_Percentage DESC;



--2.3    Combined Plan and Device Analysis

SELECT 
    [Subscription Plan],
    [MTN Device],
    COUNT(*) AS Total_Customers,
    SUM(CASE WHEN [Customer Churn Status] = 'Yes' THEN 1 ELSE 0 END) AS Churned_Customers,
    CAST(SUM(CASE WHEN [Customer Churn Status] = 'Yes' THEN 1 ELSE 0 END) AS FLOAT) * 100.0 / COUNT(*) AS Churn_Rate_Percentage
FROM [MTN Nigeria Customer Churn].dbo.['MTN Nigeria Customer Churn$']
GROUP BY [Subscription Plan], [MTN Device]
HAVING COUNT(*) >= 5                 /*Only show combinations with at least 5 customers*/
ORDER BY Churn_Rate_Percentage DESC;





 --3.           REVENUE VS. CHURN STATUS 


--3.1      Revenue and Data Usage Comparison

SELECT 
    [Customer Churn Status],
    COUNT(*) AS Customer_Count,
    AVG([Total Revenue]) AS Avg_Total_Revenue,
    AVG([Data Usage]) AS Avg_Data_Usage,
    MIN([Total Revenue]) AS Min_Revenue,
    MAX([Total Revenue]) AS Max_Revenue,
    STDEV([Total Revenue]) AS StdDev_Revenue,
    MIN([Data Usage]) AS Min_Data_Usage,
    MAX([Data Usage]) AS Max_Data_Usage,
    STDEV([Data Usage]) AS StdDev_Data_Usage
FROM [MTN Nigeria Customer Churn].dbo.['MTN Nigeria Customer Churn$']
GROUP BY [Customer Churn Status]
ORDER BY [Customer Churn Status];



--3.2       /*Revenue Distribution Analysis*/

SELECT 
    [Customer Churn Status],
    CASE 
        WHEN [Total Revenue] < 10000 THEN 'Low (< 10k)'
        WHEN [Total Revenue] BETWEEN 10000 AND 50000 THEN 'Medium (10k-50k)'
        WHEN [Total Revenue] BETWEEN 50001 AND 100000 THEN 'High (50k-100k)'
        ELSE 'Very High (> 100k)'
    END AS Revenue_Bracket,
    COUNT(*) AS Customer_Count,
    CAST(COUNT(*) AS FLOAT) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY [Customer Churn Status]) AS Percentage_Within_Status
FROM [MTN Nigeria Customer Churn].dbo.['MTN Nigeria Customer Churn$']
GROUP BY 
    [Customer Churn Status],
    CASE 
        WHEN [Total Revenue] < 10000 THEN 'Low (< 10k)'
        WHEN [Total Revenue] BETWEEN 10000 AND 50000 THEN 'Medium (10k-50k)'
        WHEN [Total Revenue] BETWEEN 50001 AND 100000 THEN 'High (50k-100k)'
        ELSE 'Very High (> 100k)'
    END
ORDER BY [Customer Churn Status], Revenue_Bracket;





--4.          CUSTOMER TENURE AND SATISFACTION 


--4.1   Tenure vs Satisfaction vs Churn Analysis

SELECT 
    CASE 
        WHEN [Customer Tenure in months] <= 6 THEN '0-6 months'
        WHEN [Customer Tenure in months] <= 12 THEN '7-12 months'
        WHEN [Customer Tenure in months] <= 24 THEN '13-24 months'
        WHEN [Customer Tenure in months] <= 36 THEN '25-36 months'
        ELSE '37+ months'
    END AS Tenure_Group,
    AVG([Satisfaction Rate]) AS Avg_Satisfaction_Rate,
    COUNT(*) AS Total_Customers,
    SUM(CASE WHEN [Customer Churn Status] = 'Yes' THEN 1 ELSE 0 END) AS Churned_Customers,
    CAST(SUM(CASE WHEN [Customer Churn Status] = 'Yes' THEN 1 ELSE 0 END) AS FLOAT) * 100.0 / COUNT(*) AS Churn_Rate_Percentage
FROM [MTN Nigeria Customer Churn].dbo.['MTN Nigeria Customer Churn$']
GROUP BY 
    CASE 
        WHEN [Customer Tenure in months] <= 6 THEN '0-6 months'
        WHEN [Customer Tenure in months] <= 12 THEN '7-12 months'
        WHEN [Customer Tenure in months] <= 24 THEN '13-24 months'
        WHEN [Customer Tenure in months] <= 36 THEN '25-36 months'
        ELSE '37+ months'
    END
ORDER BY 
    MIN(CASE 
        WHEN [Customer Tenure in months] <= 6 THEN 1
        WHEN [Customer Tenure in months] <= 12 THEN 2
        WHEN [Customer Tenure in months] <= 24 THEN 3
        WHEN [Customer Tenure in months] <= 36 THEN 4
        ELSE 5
    END);


--4.2     Satisfaction Rate Impact on Churn

SELECT 
    [Satisfaction Rate],
    COUNT(*) AS Total_Customers,
    SUM(CASE WHEN [Customer Churn Status] = 'Yes' THEN 1 ELSE 0 END) AS Churned_Customers,
    CAST(SUM(CASE WHEN [Customer Churn Status] = 'Yes' THEN 1 ELSE 0 END) AS FLOAT) * 100.0 / COUNT(*) AS Churn_Rate_Percentage,
    AVG([Customer Tenure in months]) AS Avg_Tenure_Months
FROM [MTN Nigeria Customer Churn].dbo.['MTN Nigeria Customer Churn$']
GROUP BY [Satisfaction Rate]
ORDER BY [Satisfaction Rate];





--5.           MOST COMMON REASONS FOR CHURN 


--5.1     Top Reasons for Churn

SELECT 
    [Reasons for Churn],
    COUNT(*) AS Churn_Count,
    CAST(COUNT(*) AS FLOAT) * 100.0 / (SELECT COUNT(*) FROM [MTN Nigeria Customer Churn].dbo.['MTN Nigeria Customer Churn$'] WHERE [Customer Churn Status] = 'Yes') AS Percentage_of_Churned_Customers
FROM [MTN Nigeria Customer Churn].dbo.['MTN Nigeria Customer Churn$']
WHERE [Customer Churn Status] = 'Yes' 
    AND [Reasons for Churn] IS NOT NULL
GROUP BY [Reasons for Churn]
ORDER BY Churn_Count DESC;



--5.2       Churn Reasons by Demographics  

SELECT 
    [Reasons for Churn],
    State,
    Gender,
    COUNT(*) AS Churn_Count
FROM [MTN Nigeria Customer Churn].dbo.['MTN Nigeria Customer Churn$']
WHERE [Customer Churn Status] = 'Yes' 
    AND [Reasons for Churn] IS NOT NULL
GROUP BY [Reasons for Churn], State, Gender
HAVING COUNT(*) >= 2                 /* Only show combinations with at least 2 occurrences*/
ORDER BY [Reasons for Churn], Churn_Count DESC;





--6.           PURCHASE FREQUENCY AND CHURN


--6.1         Purchase Frequency Impact on Churn

SELECT 
    CASE 
        WHEN [Number of Times Purchased] <= 5 THEN '1-5 purchases'
        WHEN [Number of Times Purchased] <= 10 THEN '6-10 purchases'
        WHEN [Number of Times Purchased] <= 15 THEN '11-15 purchases'
        WHEN [Number of Times Purchased] <= 20 THEN '16-20 purchases'
        ELSE '21+ purchases'
    END AS Purchase_Frequency_Group,
    COUNT(*) AS Total_Customers,
    SUM(CASE WHEN [Customer Churn Status] = 'Yes' THEN 1 ELSE 0 END) AS Churned_Customers,
    CAST(SUM(CASE WHEN [Customer Churn Status] = 'Yes' THEN 1 ELSE 0 END) AS FLOAT) * 100.0 / COUNT(*) AS Churn_Rate_Percentage,
    AVG([Number of Times Purchased]) AS Avg_Purchase_Count,
    AVG([Total Revenue]) AS Avg_Total_Revenue
FROM [MTN Nigeria Customer Churn].dbo.['MTN Nigeria Customer Churn$']
GROUP BY 
    CASE 
        WHEN [Number of Times Purchased] <= 5 THEN '1-5 purchases'
        WHEN [Number of Times Purchased] <= 10 THEN '6-10 purchases'
        WHEN [Number of Times Purchased] <= 15 THEN '11-15 purchases'
        WHEN [Number of Times Purchased] <= 20 THEN '16-20 purchases'
        ELSE '21+ purchases'
    END
ORDER BY Avg_Purchase_Count;



--6.2       Detailed Purchase Frequency Analysis
SELECT 
    [Customer Churn Status],
    AVG([Number of Times Purchased]) AS Avg_Purchase_Count,
    MIN([Number of Times Purchased]) AS Min_Purchase_Count,
    MAX([Number of Times Purchased]) AS Max_Purchase_Count,
    STDEV([Number of Times Purchased]) AS StdDev_Purchase_Count
FROM [MTN Nigeria Customer Churn].dbo.['MTN Nigeria Customer Churn$']
GROUP BY [Customer Churn Status]
ORDER BY [Customer Churn Status];





--7.          PRICE SENSITIVITY AND CHURN 


--7.1        Unit Price Analysis by Churn Status

SELECT 
    [Customer Churn Status],
    [Subscription Plan],
    COUNT(*) AS Customer_Count,
    AVG([Unit Price]) AS Avg_Unit_Price,
    MIN([Unit Price]) AS Min_Unit_Price,
    MAX([Unit Price]) AS Max_Unit_Price,
    STDEV([Unit Price]) AS StdDev_Unit_Price
FROM [MTN Nigeria Customer Churn].dbo.['MTN Nigeria Customer Churn$']
GROUP BY [Customer Churn Status], [Subscription Plan]
HAVING COUNT(*) >= 5          -- Only show plans with at least 5 customers
ORDER BY [Subscription Plan], [Customer Churn Status];



--7.2       Price Sensitivity by Plan Category

WITH PriceSensitivity AS (
    SELECT 
        [Subscription Plan],
        AVG(CASE WHEN [Customer Churn Status] = 'Yes' THEN [Unit Price] END) AS Avg_Price_Churned,
        AVG(CASE WHEN [Customer Churn Status] = 'No' THEN [Unit Price] END) AS Avg_Price_Active,
        COUNT(CASE WHEN [Customer Churn Status] = 'Yes' THEN 1 END) AS Churned_Count,
        COUNT(CASE WHEN [Customer Churn Status] = 'No' THEN 1 END) AS Active_Count,
        CAST(COUNT(CASE WHEN [Customer Churn Status] = 'Yes' THEN 1 END) AS FLOAT) * 100.0 / COUNT(*) AS Churn_Rate_Percentage
    FROM [MTN Nigeria Customer Churn].dbo.['MTN Nigeria Customer Churn$']
    GROUP BY [Subscription Plan]
    HAVING COUNT(*) >= 10           --Only analyze plans with sufficient data
)
SELECT 
    [Subscription Plan],
    Avg_Price_Churned,
    Avg_Price_Active,
    (Avg_Price_Churned - Avg_Price_Active) AS Price_Difference,
    Churn_Rate_Percentage,
    Churned_Count,
    Active_Count
FROM PriceSensitivity
ORDER BY Price_Difference DESC;





--8.          COMPREHENSIVE SUMMARY DASHBOARD QUERY 


--8.1       Executive Summary
SELECT 
    'Overall Metrics' AS Category,
    'Total Customers' AS Metric,
    CAST(COUNT(*) AS VARCHAR(20)) AS Value
FROM [MTN Nigeria Customer Churn].dbo.['MTN Nigeria Customer Churn$']

UNION ALL

SELECT 
    'Overall Metrics' AS Category,
    'Churned Customers' AS Metric,
    CAST(SUM(CASE WHEN [Customer Churn Status] = 'Yes' THEN 1 ELSE 0 END) AS VARCHAR(20)) AS Value
FROM [MTN Nigeria Customer Churn].dbo.['MTN Nigeria Customer Churn$']

UNION ALL

SELECT 
    'Overall Metrics' AS Category,
    'Overall Churn Rate (%)' AS Metric,
    CAST(ROUND(CAST(SUM(CASE WHEN [Customer Churn Status] = 'Yes' THEN 1 ELSE 0 END) AS FLOAT) * 100.0 / COUNT(*), 2) AS VARCHAR(20)) AS Value
FROM [MTN Nigeria Customer Churn].dbo.['MTN Nigeria Customer Churn$']

UNION ALL

SELECT 
    'Revenue Metrics' AS Category,
    'Avg Revenue - Churned' AS Metric,
    CAST(ROUND(AVG(CASE WHEN [Customer Churn Status] = 'Yes' THEN [Total Revenue] END), 2) AS VARCHAR(20)) AS Value
FROM [MTN Nigeria Customer Churn].dbo.['MTN Nigeria Customer Churn$']

UNION ALL

SELECT 
    'Revenue Metrics' AS Category,
    'Avg Revenue - Active' AS Metric,
    CAST(ROUND(AVG(CASE WHEN [Customer Churn Status] = 'No' THEN [Total Revenue] END), 2) AS VARCHAR(20)) AS Value
FROM [MTN Nigeria Customer Churn].dbo.['MTN Nigeria Customer Churn$']

ORDER BY Category, Metric;