/*
    SQLManiak – 20761 Demo
    Moduł 13: Operatory zbiorów – UNION, INTERSECT, EXCEPT
*/

USE AdventureWorks2022;
GO

-- 1. UNION – lista miast klientów i dostawców
SELECT DISTINCT a.City
FROM Person.Address AS a
JOIN Person.BusinessEntityAddress AS bea
    ON a.AddressID = bea.AddressID
UNION
SELECT DISTINCT a2.City
FROM Purchasing.Vendor AS v
JOIN Person.BusinessEntityAddress AS bea2
    ON v.BusinessEntityID = bea2.BusinessEntityID
JOIN Person.Address AS a2
    ON bea2.AddressID = a2.AddressID;
GO

-- 2. INTERSECT – miasta wspólne dla obu grup
SELECT DISTINCT a.City
FROM Person.Address AS a
JOIN Person.BusinessEntityAddress AS bea
    ON a.AddressID = bea.AddressID
INTERSECT
SELECT DISTINCT a2.City
FROM Purchasing.Vendor AS v
JOIN Person.BusinessEntityAddress AS bea2
    ON v.BusinessEntityID = bea2.BusinessEntityID
JOIN Person.Address AS a2
    ON bea2.AddressID = a2.AddressID;
GO

-- 3. EXCEPT – klienci, którzy nie mają zamówień
SELECT c.CustomerID
FROM Sales.Customer AS c
EXCEPT
SELECT DISTINCT soh.CustomerID
FROM Sales.SalesOrderHeader AS soh;
GO
