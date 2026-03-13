/* ============================================================
   File: 03_data_cleaning.sql
   Project: Sales Data Analysis & MIS Dashboard

   Description:
   Performs data validation and cleaning before analysis.
   Ensures sales, product, and inventory data are consistent.
   ============================================================ */

USE SalesAnalyticsDB;
GO


/* ------------------------------------------------------------
1. Check duplicate sales transactions
If duplicates exist, they can affect revenue calculations.
------------------------------------------------------------ */

SELECT ProductID, StoreID, OrderDate, COUNT(*) AS DuplicateCount
FROM Sales
GROUP BY ProductID, StoreID, OrderDate
HAVING COUNT(*) > 1;



/* ------------------------------------------------------------
2. Check for NULL values in critical columns
These fields should not be empty.
------------------------------------------------------------ */

SELECT *
FROM Sales
WHERE OrderDate IS NULL
   OR Quantity IS NULL
   OR SellingPrice IS NULL;



/* ------------------------------------------------------------
3. Fix negative quantity values
Quantity should always be positive.
------------------------------------------------------------ */

UPDATE Sales
SET Quantity = ABS(Quantity)
WHERE Quantity < 0;



/* ------------------------------------------------------------
4. Standardize product names (remove extra spaces)
------------------------------------------------------------ */

UPDATE Products
SET ProductName = LTRIM(RTRIM(ProductName));



/* ------------------------------------------------------------
5. Validate inventory values
CurrentStock should never be negative.
------------------------------------------------------------ */

UPDATE Inventory
SET CurrentStock = 0
WHERE CurrentStock < 0;



/* ------------------------------------------------------------
6. Check for products in sales that don't exist in Products table
This identifies data integrity issues.
------------------------------------------------------------ */

SELECT DISTINCT s.ProductID
FROM Sales s
LEFT JOIN Products p
ON s.ProductID = p.ProductID
WHERE p.ProductID IS NULL;
