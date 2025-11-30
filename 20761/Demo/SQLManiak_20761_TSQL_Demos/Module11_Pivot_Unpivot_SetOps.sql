/*
    SQLManiak – 20761 Demo
    Moduł 11: PIVOT/UNPIVOT oraz operatory zbiorów
*/

USE AdventureWorks2022;
GO

-- 1. PIVOT – sprzedaż per rok (upraszczamy na potrzeby demo)
WITH SalesByYear AS
(
    SELECT
        YEAR(soh.OrderDate) AS OrderYear,
        soh.SubTotal         AS Amount
    FROM Sales.SalesOrderHeader AS soh
)
SELECT
    ISNULL([2011], 0) AS Sales2011,
    ISNULL([2012], 0) AS Sales2012,
    ISNULL([2013], 0) AS Sales2013
FROM SalesByYear
PIVOT
(
    SUM(Amount) FOR OrderYear IN ([2011],[2012],[2013])
) AS p;
GO

-- 2. UNION vs UNION ALL
SELECT TOP (5) FirstName, LastName
FROM Person.Person
WHERE Title = 'Mr.'
UNION
SELECT TOP (5) FirstName, LastName
FROM Person.Person
WHERE Title = 'Ms.';
GO

SELECT TOP (5) FirstName, LastName
FROM Person.Person
WHERE Title = 'Mr.'
UNION ALL
SELECT TOP (5) FirstName, LastName
FROM Person.Person
WHERE Title = 'Ms.';
GO

-- 3. INTERSECT – osoby z dwóch kryteriów
SELECT BusinessEntityID
FROM HumanResources.Employee
INTERSECT
SELECT BusinessEntityID
FROM Person.Person;
GO

-- 4. EXCEPT – pracownicy bez adresu
SELECT e.BusinessEntityID
FROM HumanResources.Employee AS e
EXCEPT
SELECT a.BusinessEntityID
FROM Person.BusinessEntityAddress AS a;
GO
