/* ============================================================
   File: 6_kpi_summary.sql
   Project: Sales Data Analysis & MIS Dashboard

   Description:
   This script creates KPI summary views for reporting
   and dashboard integration (Power BI / Excel).

   Instead of writing repeated queries,
   we create reusable Views.

   Business Focus:
   - Revenue
   - Profit
   - Growth
   - Product Performance
   - Inventory Alerts
   ============================================================ */

USE SalesAnalyticsDB;
GO


/* ============================================================
   1️⃣ Total Revenue KPI
   Business Question:
   What is the total revenue generated?
   ============================================================ */

CREATE OR ALTER VIEW vw_TotalRevenue AS
SELECT 
    SUM(Quantity * SellingPrice) AS TotalRevenue
FROM Sales;
GO



/* ============================================================
   2️⃣ Total Profit KPI
   Business Question:
   What is total profit generated?
   Profit = (SellingPrice - CostPrice) * Quantity
   ============================================================ */

CREATE OR ALTER VIEW vw_TotalProfit AS
SELECT 
    SUM((s.SellingPrice - p.CostPrice) * s.Quantity) AS TotalProfit
FROM Sales s
JOIN Products p ON s.ProductID = p.ProductID;
GO



/* ============================================================
   3️⃣ Profit Margin Percentage KPI
   Business Question:
   What percentage of revenue is profit?
   Used to measure business efficiency.
   ============================================================ */

CREATE OR ALTER VIEW vw_ProfitMargin AS
SELECT 
    SUM((s.SellingPrice - p.CostPrice) * s.Quantity) * 100.0
        / SUM(s.Quantity * s.SellingPrice) AS ProfitMarginPercent
FROM Sales s
JOIN Products p ON s.ProductID = p.ProductID;
GO



/* ============================================================
   4️⃣ Monthly Revenue Trend
   Business Question:
   How is revenue changing month over month?
   Used for trend and seasonality analysis.
   ============================================================ */

CREATE OR ALTER VIEW vw_MonthlyRevenue AS
SELECT 
    YEAR(OrderDate) AS SalesYear,
    MONTH(OrderDate) AS SalesMonth,
    SUM(Quantity * SellingPrice) AS MonthlyRevenue
FROM Sales
GROUP BY YEAR(OrderDate), MONTH(OrderDate);
GO



/* ============================================================
   5️⃣ Product Performance Summary
   Business Question:
   Which products are top performers?
   Used for category and SKU-level analysis.
   ============================================================ */

CREATE OR ALTER VIEW vw_ProductPerformance AS
SELECT 
    p.ProductName,
    SUM(s.Quantity) AS UnitsSold,
    SUM(s.Quantity * s.SellingPrice) AS Revenue,
    SUM((s.SellingPrice - p.CostPrice) * s.Quantity) AS Profit
FROM Sales s
JOIN Products p ON s.ProductID = p.ProductID
GROUP BY p.ProductName;
GO



/* ============================================================
   6️⃣ Regional Performance Summary
   Business Question:
   Which regions contribute most to revenue?
   ============================================================ */

CREATE OR ALTER VIEW vw_RegionalPerformance AS
SELECT 
    st.Region,
    SUM(s.Quantity * s.SellingPrice) AS Revenue
FROM Sales s
JOIN Stores st ON s.StoreID = st.StoreID
GROUP BY st.Region;
GO



/* ============================================================
   7️⃣ Low Stock Alert KPI
   Business Question:
   Which products need restocking?
   Condition: CurrentStock < ReorderLevel
   ============================================================ */

CREATE OR ALTER VIEW vw_LowStockAlert AS
SELECT 
    ProductID,
    StoreID,
    CurrentStock,
    ReorderLevel
FROM Inventory
WHERE CurrentStock < ReorderLevel;
GO



/* ============================================================
   How to Use These Views:

   Example:
   SELECT * FROM vw_TotalRevenue;
   SELECT * FROM vw_ProductPerformance;
   SELECT * FROM vw_MonthlyRevenue;

   These views can be directly connected to Power BI
   or used in Excel Pivot reports.
   ============================================================ */
