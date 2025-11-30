/*
    SQLManiak – 20761 Demo
    Moduł 8: Widoki i funkcje tabelaryczne
*/

USE AdventureWorks2022;
GO

-- 1. Prosty widok łączący dane klientów i zamówień
IF OBJECT_ID('Sales.vTopCustomers', 'V') IS NOT NULL
    DROP VIEW Sales.vTopCustomers;
GO

CREATE VIEW Sales.vTopCustomers
AS
SELECT
    c.CustomerID,
    p.FirstName,
    p.LastName,
    COUNT(soh.SalesOrderID)        AS OrdersCount,
    SUM(soh.TotalDue)              AS TotalSales
FROM Sales.Customer AS c
JOIN Person.Person AS p
    ON c.PersonID = p.BusinessEntityID
JOIN Sales.SalesOrderHeader AS soh
    ON c.CustomerID = soh.CustomerID
GROUP BY c.CustomerID, p.FirstName, p.LastName;
GO

SELECT TOP (10) *
FROM Sales.vTopCustomers
ORDER BY TotalSales DESC;
GO

-- 2. Inline TVF – zamówienia klienta
IF OBJECT_ID('Sales.ufn_GetOrdersByCustomer', 'IF') IS NOT NULL
    DROP FUNCTION Sales.ufn_GetOrdersByCustomer;
GO

CREATE FUNCTION Sales.ufn_GetOrdersByCustomer
(
    @CustomerID INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        soh.SalesOrderID,
        soh.OrderDate,
        soh.Status,
        soh.TotalDue
    FROM Sales.SalesOrderHeader AS soh
    WHERE soh.CustomerID = @CustomerID
);
GO

SELECT *
FROM Sales.ufn_GetOrdersByCustomer(11000);
GO
