/* ============================================================
   File: 3_analysis_queries.sql
   Project: Sales Data Analysis & MIS Dashboard
   Description:
   This script contains business analysis queries
   to extract insights from sales and inventory data.
   ============================================================ */

USE SalesAnalyticsDB;
GO


/* ============================================================
   1️. Total Revenue Generated
   Business Question:
   How much total revenue did the company generate?
   ============================================================ */

SELECT 
    SUM(Quantity * SellingPrice) AS Total_Revenue
FROM Sales;



/* ============================================================
   2️. Revenue by Region
   Business Question:
   Which region generates the highest revenue?
   Used for regional performance analysis.
   ============================================================ */

SELECT 
    st.Region,
    SUM(s.Quantity * s.SellingPrice) AS Revenue
FROM Sales s
JOIN Stores st ON s.StoreID = st.StoreID
GROUP BY st.Region
ORDER BY Revenue DESC;



/* ============================================================
   3️. Top 5 Products by Revenue
   Business Question:
   Which products contribute most to sales?
   Used for product performance evaluation.
   ============================================================ */

SELECT TOP 5
    p.ProductName,
    SUM(s.Quantity * s.SellingPrice) AS Revenue
FROM Sales s
JOIN Products p ON s.ProductID = p.ProductID
GROUP BY p.ProductName
ORDER BY Revenue DESC;



/* ============================================================
   4️. Monthly Sales Trend
   Business Question:
   How is revenue changing month over month?
   Used for trend analysis and seasonality detection.
   ============================================================ */

SELECT 
    FORMAT(OrderDate, 'yyyy-MM') AS Sales_Month,
    SUM(Quantity * SellingPrice) AS Monthly_Revenue
FROM Sales
GROUP BY FORMAT(OrderDate, 'yyyy-MM')
ORDER BY Sales_Month;



/* ============================================================
   5️. Year-over-Year Growth
   Business Question:
   Is business growing compared to last year?
   ============================================================ */

SELECT 
    YEAR(OrderDate) AS Sales_Year,
    SUM(Quantity * SellingPrice) AS Revenue
FROM Sales
GROUP BY YEAR(OrderDate)
ORDER BY Sales_Year;



/* ============================================================
   6️. Profit Calculation
   Business Question:
   What is total profit?
   Profit = (SellingPrice - CostPrice) * Quantity
   ============================================================ */

SELECT 
    SUM((s.SellingPrice - p.CostPrice) * s.Quantity) AS Total_Profit
FROM Sales s
JOIN Products p ON s.ProductID = p.ProductID;



/* ============================================================
   7️. Profit Margin Percentage
   Business Question:
   What percentage of revenue is profit?
   Used to measure business efficiency.
   ============================================================ */

SELECT 
    SUM((s.SellingPrice - p.CostPrice) * s.Quantity) * 100.0
        / SUM(s.Quantity * s.SellingPrice) AS Profit_Margin_Percentage
FROM Sales s
JOIN Products p ON s.ProductID = p.ProductID;



/* ============================================================
   8️. Low Stock Alert
   Business Question:
   Which products need restocking?
   Condition: CurrentStock < ReorderLevel
   ============================================================ */

SELECT 
    ProductID,
    StoreID,
    CurrentStock,
    ReorderLevel
FROM Inventory
WHERE CurrentStock < ReorderLevel;



/* ============================================================
   9️. Top 3 Products Per Region (Using RANK)
   Business Question:
   Which products perform best in each region?
   Demonstrates window function usage.
   ============================================================ */

WITH ProductRevenue AS (
    SELECT 
        st.Region,
        p.ProductName,
        SUM(s.Quantity * s.SellingPrice) AS Revenue,
        RANK() OVER (PARTITION BY st.Region 
                     ORDER BY SUM(s.Quantity * s.SellingPrice) DESC) AS RankPosition
    FROM Sales s
    JOIN Products p ON s.ProductID = p.ProductID
    JOIN Stores st ON s.StoreID = st.StoreID
    GROUP BY st.Region, p.ProductName
)

SELECT *
FROM ProductRevenue
WHERE RankPosition <= 3;



/* ============================================================
   10️. Store-wise Performance Summary
   Business Question:
   Compare performance across stores.
   ============================================================ */

SELECT 
    st.StoreName,
    SUM(s.Quantity) AS Total_Units_Sold,
    SUM(s.Quantity * s.SellingPrice) AS Revenue
FROM Sales s
JOIN Stores st ON s.StoreID = st.StoreID
GROUP BY st.StoreName
ORDER BY Revenue DESC;
