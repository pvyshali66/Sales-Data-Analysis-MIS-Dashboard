/* ============================================================
   File: 03_data_cleaning.sql
   Project: Sales Data Analysis & MIS Dashboard

   Description:
   This script performs basic data validation and cleaning
   to ensure data quality before analysis.
   ============================================================ */

USE Dataware_house;
GO

/* ------------------------------------------------------------
1. Check duplicate sales transactions
If duplicates exist, they can affect revenue calculations.
------------------------------------------------------------ */

SELECT ProductID, StoreID, Date, COUNT(*) AS DuplicateCount
FROM [dbo].[Sales csv]
GROUP BY ProductID, StoreID, Date
HAVING COUNT(*) > 1;



/* ------------------------------------------------------------
2. Check for NULL values in critical columns
These fields should not be empty.
------------------------------------------------------------ */

SELECT *
FROM [dbo].[Sales csv]
WHERE Date IS NULL
   OR Quantity IS NULL
   OR Discount IS NULL;



/* ------------------------------------------------------------
3. Fix negative quantity values
Quantity should always be positive.
------------------------------------------------------------ */

UPDATE [dbo].[Sales csv]
SET Quantity = ABS(Quantity)
WHERE Quantity < 0;



/* ------------------------------------------------------------
4. Standardize product names (remove extra spaces)
------------------------------------------------------------ */

UPDATE [dbo].[Products csv]
SET ProductName = LTRIM(RTRIM(ProductName));



/* ------------------------------------------------------------
5. Validate inventory values
CurrentStock should never be negative.
------------------------------------------------------------ */

UPDATE [dbo].[Inventory csv] 
SET CurrentStock = 0
WHERE CurrentStock < 0;



/* ------------------------------------------------------------
6. Check for products in sales that don't exist in Products table
This identifies data integrity issues.
------------------------------------------------------------ */

SELECT DISTINCT s.ProductID
FROM  [dbo].[Sales csv] s
LEFT JOIN [dbo].[Products csv] p
ON s.ProductID = p.ProductID
WHERE p.ProductID IS NULL;
