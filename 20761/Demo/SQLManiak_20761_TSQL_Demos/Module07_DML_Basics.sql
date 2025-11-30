/*
    SQLManiak – 20761 Demo
    Moduł 7: DML – INSERT, UPDATE, DELETE
    UWAGA: używamy tabel tymczasowych, aby nie niszczyć danych AdventureWorks2022.
*/

USE tempdb;
GO

IF OBJECT_ID('dbo.DemoProduct', 'U') IS NOT NULL
    DROP TABLE dbo.DemoProduct;
GO

CREATE TABLE dbo.DemoProduct
(
    ProductID   INT IDENTITY PRIMARY KEY,
    Name        NVARCHAR(100),
    ListPrice   DECIMAL(10,2)
);
GO

-- 1. INSERT – pojedynczy i wiele wierszy
INSERT INTO dbo.DemoProduct (Name, ListPrice)
VALUES ('Kubek SQLManiak', 49.99);

INSERT INTO dbo.DemoProduct (Name, ListPrice)
VALUES 
('Plakat Wait Stats', 39.00),
('Książka Inside SQL Server', 129.00);
GO

SELECT * FROM dbo.DemoProduct;
GO

-- 2. UPDATE – z filtrem
UPDATE dbo.DemoProduct
SET ListPrice = ListPrice * 1.10
WHERE Name LIKE 'Kubek%';
GO

SELECT * FROM dbo.DemoProduct;
GO

-- 3. DELETE – zawsze z WHERE
DELETE FROM dbo.DemoProduct
WHERE Name LIKE 'Plakat%';
GO

SELECT * FROM dbo.DemoProduct;
GO
