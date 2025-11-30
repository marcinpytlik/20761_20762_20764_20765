/*
    SQLManiak – 20761 Demo
    Moduł 9: Agregacje – GROUP BY, HAVING
*/

USE AdventureWorks2022;
GO

-- 1. SUM, COUNT – sprzedaż wg roku
SELECT
    YEAR(soh.OrderDate)            AS OrderYear,
    COUNT(*)                       AS OrdersCount,
    SUM(soh.TotalDue)              AS TotalSales
FROM Sales.SalesOrderHeader AS soh
GROUP BY YEAR(soh.OrderDate)
ORDER BY OrderYear;
GO

-- 2. HAVING – tylko lata z dużą sprzedażą
SELECT
    YEAR(soh.OrderDate)            AS OrderYear,
    COUNT(*)                       AS OrdersCount,
    SUM(soh.TotalDue)              AS TotalSales
FROM Sales.SalesOrderHeader AS soh
GROUP BY YEAR(soh.OrderDate)
HAVING SUM(soh.TotalDue) > 5000000
ORDER BY OrderYear;
GO

-- 3. Grupowanie po kliencie
SELECT TOP (20)
    c.CustomerID,
    COUNT(*)                       AS OrdersCount,
    SUM(soh.TotalDue)              AS TotalSales
FROM Sales.SalesOrderHeader AS soh
JOIN Sales.Customer AS c
    ON soh.CustomerID = c.CustomerID
GROUP BY c.CustomerID
ORDER BY TotalSales DESC;
GO
