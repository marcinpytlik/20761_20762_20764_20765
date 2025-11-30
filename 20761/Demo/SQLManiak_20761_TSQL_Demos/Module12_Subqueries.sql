/*
    SQLManiak – 20761 Demo
    Moduł 12: Podzapytania – IN, EXISTS, podzapytania skorelowane
*/

USE AdventureWorks2022;
GO

-- 1. Podzapytanie w IN
SELECT
    p.ProductID,
    p.Name,
    p.ListPrice
FROM Production.Product AS p
WHERE p.ProductID IN
(
    SELECT sod.ProductID
    FROM Sales.SalesOrderDetail AS sod
);
GO

-- 2. EXISTS vs IN – klienci z zamówieniami
SELECT DISTINCT
    c.CustomerID
FROM Sales.Customer AS c
WHERE EXISTS
(
    SELECT 1
    FROM Sales.SalesOrderHeader AS soh
    WHERE soh.CustomerID = c.CustomerID
);
GO

-- 3. Podzapytanie skorelowane – ostatnie zamówienie klienta
SELECT
    soh.CustomerID,
    soh.SalesOrderID,
    soh.OrderDate,
    soh.TotalDue
FROM Sales.SalesOrderHeader AS soh
WHERE soh.OrderDate = (
    SELECT MAX(soh2.OrderDate)
    FROM Sales.SalesOrderHeader AS soh2
    WHERE soh2.CustomerID = soh.CustomerID
);
GO
