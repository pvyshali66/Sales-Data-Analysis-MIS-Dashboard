/* ============================================================
   File: 03_data_cleaning.sql
   Project: Sales Data Analysis & MIS Dashboard

   Description:
   This script performs basic data validation and cleaning
   to ensure data quality before analysis.
   ============================================================ */

USE SalesAnalyticsDB;
GO


/* ------------------------------------------------------------
1. Remove duplicate sales records
Duplicates may occur during data import.
------------------------------------------------------------ */

WITH DuplicateSales AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY OrderID
               ORDER BY OrderID
           ) AS rn
    FROM Sales
)
DELETE FROM DuplicateSales
WHERE rn > 1;



/* ------------------------------------------------------------
2. Check for NULL values in critical columns
These fields must not be empty.
------------------------------------------------------------ */

SELECT *
FROM Sales
WHERE OrderDate IS NULL
   OR Quantity IS NULL
   OR SellingPrice IS NULL;



/* ------------------------------------------------------------
3. Fix negative or incorrect quantity values
Sales quantity should always be positive.
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
WHERE CurrentStock < 0
