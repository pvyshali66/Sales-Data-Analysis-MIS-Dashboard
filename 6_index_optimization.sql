/* ============================================================
   File: 5_index_optimization.sql
   Project: Sales Data Analysis & MIS Dashboard

   Description:
   This script improves query performance by creating
   indexes on frequently filtered and joined columns.

   Why indexing?
   Without indexes, SQL Server scans entire tables.
   With indexes, SQL Server seeks specific rows faster.
   ============================================================ */

USE SalesAnalyticsDB;
GO


/* ============================================================
   1️. Index on Sales.StoreID
   Why?
   - Frequently used in JOIN with Stores table
   - Used in region-based analysis queries
   ============================================================ */

CREATE INDEX IX_Sales_StoreID
ON Sales(StoreID);



/* ============================================================
   2️. Index on Sales.ProductID
   Why?
   - Used in JOIN with Products table
   - Used in Top Product analysis
   ============================================================ */

CREATE INDEX IX_Sales_ProductID
ON Sales(ProductID);



/* ============================================================
   3️. Index on Sales.OrderDate
   Why?
   - Used in Monthly and Yearly trend analysis
   - Improves GROUP BY and date filtering performance
   ============================================================ */

CREATE INDEX IX_Sales_OrderDate
ON Sales(OrderDate);



/* ============================================================
   4️. Composite Index on Sales (StoreID, OrderDate)
   Why?
   - Many real-world reports filter by store and date
   - Composite index improves multi-column filtering
   ============================================================ */

CREATE INDEX IX_Sales_Store_Date
ON Sales(StoreID, OrderDate);



/* ============================================================
   5️. Index on Inventory.ProductID
   Why?
   - Used in restocking queries
   - Improves low stock alert performance
   ============================================================ */

CREATE INDEX IX_Inventory_ProductID
ON Inventory(ProductID);



/* ============================================================
   6️. Index on Inventory.CurrentStock
   Why?
   - Used in WHERE CurrentStock < ReorderLevel
   - Helps fast detection of low stock items
   ============================================================ */

CREATE INDEX IX_Inventory_CurrentStock
ON Inventory(CurrentStock);



/* ============================================================
   7️. Checking Execution Plan (Manual Step)
   How to verify improvement:

   In SSMS:
   - Click "Include Actual Execution Plan"
   - Run analysis query
   - Check if it uses INDEX SEEK instead of TABLE SCAN

   INDEX SEEK = Optimized
   TABLE SCAN = Slow
   ============================================================ */
