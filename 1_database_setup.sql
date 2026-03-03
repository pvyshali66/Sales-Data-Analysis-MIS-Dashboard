/* ============================================================
   Project: Sales Data Analysis & MIS Dashboard
   Author: Vyshali
   Description:
   This script creates the database and core tables required 
   for performing sales analytics and business intelligence reporting.
   ============================================================ */

-- Step 1: Create Database
CREATE DATABASE SalesAnalyticsDB;
GO

-- Step 2: Use the Created Database
USE SalesAnalyticsDB;
GO


/* ============================================================
   Table 1: Products
   Stores product-level information including cost price 
   and category classification.
   ============================================================ */
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,              -- Unique Product Identifier
    ProductName VARCHAR(100) NOT NULL,      -- Name of the Product
    Category VARCHAR(50) NOT NULL,          -- Product Category (Electronics, Furniture, etc.)
    CostPrice DECIMAL(10,2) NOT NULL        -- Cost Price per Unit
);


/* ============================================================
   Table 2: Stores
   Contains store location and region data for regional analysis.
   ============================================================ */
CREATE TABLE Stores (
    StoreID INT PRIMARY KEY,                -- Unique Store Identifier
    StoreName VARCHAR(100) NOT NULL,        -- Store Name
    Region VARCHAR(50) NOT NULL             -- Region (North, South, East, West)
);


/* ============================================================
   Table 3: Sales
   Stores transactional sales data.
   Foreign keys ensure relational integrity.
   ============================================================ */
CREATE TABLE Sales (
    OrderID INT PRIMARY KEY,                -- Unique Order Identifier
    OrderDate DATE NOT NULL,                -- Date of Transaction
    StoreID INT NOT NULL,                   -- Store where sale occurred
    ProductID INT NOT NULL,                 -- Product sold
    Quantity INT NOT NULL,                  -- Units sold
    SellingPrice DECIMAL(10,2) NOT NULL,    -- Selling price per unit

    -- Foreign Key Constraints
    FOREIGN KEY (StoreID) REFERENCES Stores(StoreID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);


/* ============================================================
   Table 4: Inventory
   Tracks stock movement and supplier information.
   Used for inventory risk and stock analysis.
   ============================================================ */
CREATE TABLE Inventory (
    InventoryID INT PRIMARY KEY,            -- Unique Inventory Record ID
    ProductID INT NOT NULL,                 -- Product reference
    StoreID INT NOT NULL,                   -- Store reference
    StockIn INT NOT NULL,                   -- Stock received
    StockOut INT NOT NULL,                  -- Stock sold/removed
    CurrentStock INT NOT NULL,              -- Available stock
    LastUpdated DATE NOT NULL,              -- Last stock update date
    Supplier VARCHAR(100),                  -- Supplier Name
    LeadTimeDays INT,                       -- Supplier lead time in days

    -- Foreign Key Constraints
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    FOREIGN KEY (StoreID) REFERENCES Stores(StoreID)
);


/* ============================================================
   Optional Performance Optimization
   Creating indexes to improve query performance on 
   frequently filtered columns.
   ============================================================ */

CREATE INDEX idx_sales_orderdate ON Sales(OrderDate);
CREATE INDEX idx_sales_productid ON Sales(ProductID);
CREATE INDEX idx_sales_storeid ON Sales(StoreID);
