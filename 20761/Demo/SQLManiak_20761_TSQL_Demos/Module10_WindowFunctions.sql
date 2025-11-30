/*
    SQLManiak – 20761 Demo
    Moduł 10: Funkcje okienkowe
*/

USE AdventureWorks2022;
GO

-- 1. ROW_NUMBER – ranking zamówień klienta
SELECT TOP (50)
    soh.CustomerID,
    soh.SalesOrderID,
    soh.OrderDate,
    soh.TotalDue,
    ROW_NUMBER() OVER (
        PARTITION BY soh.CustomerID
        ORDER BY soh.OrderDate DESC
    ) AS OrderRank
FROM Sales.SalesOrderHeader AS soh
ORDER BY soh.CustomerID, OrderRank;
GO

-- 2. LAG/LEAD – różnica między kolejnymi zamówieniami
SELECT TOP (50)
    soh.CustomerID,
    soh.SalesOrderID,
    soh.OrderDate,
    soh.TotalDue,
    LAG(soh.TotalDue) OVER (
        PARTITION BY soh.CustomerID
        ORDER BY soh.OrderDate
    ) AS PrevAmount,
    soh.TotalDue
      - LAG(soh.TotalDue) OVER (
            PARTITION BY soh.CustomerID
            ORDER BY soh.OrderDate
        ) AS DiffFromPrev
FROM Sales.SalesOrderHeader AS soh
ORDER BY soh.CustomerID, soh.OrderDate;
GO
