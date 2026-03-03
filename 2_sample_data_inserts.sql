/* ============================================================
   Project: Sales Data Analysis & MIS Dashboard
   Description:
   This script inserts sample master data and 
   transactional data for analysis purposes.
   ============================================================ */

USE SalesAnalyticsDB;
GO

/* ============================================================
   Insert Master Data: Products
   ============================================================ */

INSERT INTO Products VALUES
(1,'Laptop','Electronics',40000),
(2,'Mobile','Electronics',15000),
(3,'Chair','Furniture',1500),
(4,'Desk','Furniture',5000),
(5,'Headphones','Accessories',800),
(6,'Monitor','Electronics',7000),
(7,'Keyboard','Accessories',500),
(8,'Printer','Electronics',9000);


/* ============================================================
   Insert Master Data: Stores
   ============================================================ */

INSERT INTO Stores VALUES
(1,'Hyderabad Store','South'),
(2,'Mumbai Store','West'),
(3,'Delhi Store','North'),
(4,'Chennai Store','South'),
(5,'Kolkata Store','East');


/* ============================================================
   Insert 100 Sales Records (Generated Pattern)
   ============================================================ */

DECLARE @i INT = 1;

WHILE @i <= 100
BEGIN
    INSERT INTO Sales (
        OrderID,
        OrderDate,
        StoreID,
        ProductID,
        Quantity,
        SellingPrice
    )
    VALUES (
        @i,
        DATEADD(DAY, @i, '2025-01-01'),
        ((@i % 5) + 1),
        ((@i % 8) + 1),
        ((@i % 10) + 1),
        1000 + (@i * 50)
    );

    SET @i = @i + 1;
END;


/* ============================================================
   Insert Inventory Records
   ============================================================ */

INSERT INTO Inventory VALUES
(1,1,1,100,20,80,'2025-03-01','ABC Suppliers',5),
(2,2,2,200,50,150,'2025-03-02','XYZ Traders',7),
(3,3,3,150,30,120,'2025-03-03','Global Supplies',4),
(4,4,4,120,40,80,'2025-03-04','Prime Distributors',6),
(5,5,5,180,60,120,'2025-03-05','City Traders',3);
