/* ============================================================
   File: 04_reporting_views.sql
   Project: Sales Data Analysis & MIS Dashboard

   Description:
   This script creates reporting views used for dashboards
   and MIS reports. Views simplify complex analysis queries
   and provide reusable datasets for Power BI or Excel.

   Tables Used:
   - Sales csv
   - Products csv
   - Stores csv
   - Inventory csv
   ============================================================ */

USE Dataware_house;
GO


/* ============================================================
   1. KPI Summary View
   Business Purpose:
   Provides key business metrics for dashboard KPI cards.

   Metrics Included:
   - Total Revenue
   - Total Profit
   - Total Units Sold

   Revenue = Quantity × SellingPrice
   Profit = (SellingPrice − CostPrice) × Quantity
   ============================================================ */

CREATE VIEW vw_KPI_Summary AS
SELECT
    SUM(
        CAST(s.Quantity AS INT) *
        CAST(p.SellingPrice AS DECIMAL(10,2))
    ) AS Total_Revenue,

    SUM(
        (CAST(p.SellingPrice AS DECIMAL(10,2)) -
         CAST(p.CostPrice AS DECIMAL(10,2)))
        * CAST(s.Quantity AS INT)
    ) AS Total_Profit,

    SUM(CAST(s.Quantity AS INT)) AS Total_Units_Sold

FROM [dbo].[Sales csv] s
JOIN [dbo].[Products csv] p
ON s.ProductID = p.ProductID;



/* ============================================================
   2. Revenue by Region View
   Business Purpose:
   Helps compare sales performance across different regions.

   Used in dashboard visualizations such as:
   - Bar charts
   - Regional performance reports
   ============================================================ */

CREATE VIEW vw_Revenue_By_Region AS
SELECT
    st.Region,
    SUM(
        CAST(s.Quantity AS INT) *
        CAST(p.SellingPrice AS DECIMAL(10,2))
    ) AS Revenue
FROM [dbo].[Sales csv] s
JOIN [dbo].[Stores csv] st
ON s.StoreID = st.StoreID
JOIN [dbo].[Products csv] p
ON s.ProductID = p.ProductID
GROUP BY st.Region;



/* ============================================================
   3. Monthly Sales Trend View
   Business Purpose:
   Tracks how revenue changes month-to-month.

   Used for:
   - Sales trend analysis
   - Seasonality detection
   ============================================================ */

CREATE VIEW vw_Monthly_Sales AS
SELECT
    YEAR(CAST(s.Date AS DATE)) AS Sales_Year,
    MONTH(CAST(s.Date AS DATE)) AS Sales_Month,
    SUM(
        CAST(s.Quantity AS INT) *
        CAST(p.SellingPrice AS DECIMAL(10,2))
    ) AS Revenue
FROM [dbo].[Sales csv] s
JOIN [dbo].[Products csv] p
ON s.ProductID = p.ProductID
GROUP BY
    YEAR(CAST(s.Date AS DATE)),
    MONTH(CAST(s.Date AS DATE));



/* ============================================================
   4. Product Performance View
   Business Purpose:
   Identifies products generating the highest revenue.

   Used for:
   - Product ranking
   - Sales contribution analysis
   ============================================================ */

CREATE VIEW vw_Product_Revenue AS
SELECT
    p.ProductName,
    SUM(
        CAST(s.Quantity AS INT) *
        CAST(p.SellingPrice AS DECIMAL(10,2))
    ) AS Revenue
FROM [dbo].[Sales csv] s
JOIN [dbo].[Products csv] p
ON s.ProductID = p.ProductID
GROUP BY p.ProductName;



/* ============================================================
   5. Low Stock Alert View
   Business Purpose:
   Identifies products that need restocking.

   Condition:
   CurrentStock < ReorderLevel

   Used for:
   - Inventory monitoring
   - Supply chain management
   ============================================================ */

CREATE VIEW vw_Low_Stock AS
SELECT
    p.ProductName,
    i.StoreID,
    i.CurrentStock,
    p.ReorderLevel
FROM [dbo].[Products csv] p
JOIN [dbo].[Inventory csv] i
ON p.ProductID = i.ProductID
WHERE i.CurrentStock < p.ReorderLevel;
