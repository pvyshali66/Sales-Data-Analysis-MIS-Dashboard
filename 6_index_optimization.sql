/* ============================================================
   File: 05_index_optimization.sql
   Project: Sales Data Analysis & MIS Dashboard

   Description:
   This script creates indexes to improve SQL query performance.
   The dataset was imported from CSV files where many columns
   were stored as VARCHAR(MAX). Since SQL Server cannot create
   indexes directly on VARCHAR(MAX), computed columns are
   created with appropriate data types and indexed instead.

   Indexing improves:
   - Join performance
   - Filtering speed
   - Aggregation queries

   Tables Optimized:
   - Sales csv
   - Products csv
   - Inventory csv
   ============================================================ */

USE Dataware_house;
GO


/* ============================================================
   1. Index on Sales ProductID

   Purpose:
   Speeds up joins between Sales and Products tables.

   Why Computed Column?
   ProductID was imported as VARCHAR(MAX), which cannot
   be indexed directly. A computed column is created with
   VARCHAR(50) so it can be indexed.

   Queries Improved:
   - Revenue calculation
   - Profit calculation
   - Product performance analysis
   ============================================================ */

ALTER TABLE [dbo].[Sales csv]
ADD ProductID_Index AS CAST(ProductID AS VARCHAR(50));

CREATE INDEX idx_sales_productid
ON [dbo].[Sales csv](ProductID_Index);



/* ============================================================
   2. Index on Sales StoreID

   Purpose:
   Improves performance of joins between Sales and Stores
   tables when analyzing regional or store-based sales.

   Why Computed Column?
   StoreID exists as VARCHAR(MAX) in the imported dataset.
   It is converted to INT in a computed column for indexing.

   Queries Improved:
   - Revenue by Region
   - Store Performance Analysis
   ============================================================ */

ALTER TABLE [dbo].[Sales csv]
ADD StoreID_Index AS CAST(StoreID AS INT);

CREATE INDEX idx_sales_storeid
ON [dbo].[Sales csv](StoreID_Index);



/* ============================================================
   3. Index on Sales Date

   Purpose:
   Improves performance of time-based queries such as
   monthly or yearly sales trend analysis.

   Data Type Fix:
   The Date column is converted to DATE so SQL Server
   can perform efficient filtering and indexing.

   Queries Improved:
   - Monthly Sales Trend
   - Yearly Revenue Analysis
   ============================================================ */

ALTER TABLE [dbo].[Sales csv]
ALTER COLUMN Date DATE;

CREATE INDEX idx_sales_date
ON [dbo].[Sales csv](Date);



/* ============================================================
   4. Index on Products ProductID

   Purpose:
   Speeds up joins between Products and Sales tables.

   Why Computed Column?
   ProductID was imported as text, so a computed column
   converts it to INT for indexing.

   Queries Improved:
   - Product revenue calculations
   - Profit analysis
   ============================================================ */

ALTER TABLE [dbo].[Products csv]
ADD ProductID_Index AS CAST(ProductID AS INT);

CREATE INDEX idx_products_productid
ON [dbo].[Products csv](ProductID_Index);



/* ============================================================
   5. Index on Inventory ProductID

   Purpose:
   Improves joins between Inventory and Products tables
   for inventory monitoring queries.

   Queries Improved:
   - Low stock alert detection
   - Inventory status analysis
   ============================================================ */

ALTER TABLE [dbo].[Inventory csv]
ADD ProductID_Index AS CAST(ProductID AS INT);

CREATE INDEX idx_inventory_productid
ON [dbo].[Inventory csv](ProductID_Index);



/* ============================================================
   6. Index on Inventory StoreID

   Purpose:
   Improves queries analyzing inventory levels per store.

   Queries Improved:
   - Store-level inventory monitoring
   - Supply chain analysis
   ============================================================ */

ALTER TABLE [dbo].[Inventory csv]
ADD StoreID_Index AS CAST(StoreID AS INT);

CREATE INDEX idx_inventory_storeid
ON [dbo].[Inventory csv](StoreID_Index);
