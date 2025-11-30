/*
    SQLManiak – 20761 Demo
    Moduł 6: Typy danych i konwersje
*/

USE AdventureWorks2022;
GO

-- 1. Rzutowanie daty na różne formaty
SELECT TOP (10)
    soh.SalesOrderID,
    soh.OrderDate,
    CAST(soh.OrderDate AS DATE)      AS OrderDateOnly,
    CONVERT(CHAR(10), soh.OrderDate, 104) AS OrderDate_DE      -- dd.mm.yyyy
FROM Sales.SalesOrderHeader AS soh;
GO

-- 2. Niejawne konwersje – potencjalne problemy
-- Porównanie tekstu z liczbą
SELECT
    CASE WHEN '100' = 100 THEN 1 ELSE 0 END AS CompareResult;
GO

-- 3. Różne długości i tnęcie danych
DECLARE @Short VARCHAR(5) = 'ABCDEFG';
SELECT @Short AS ValueCut;    -- zostanie ucięte do 5 znaków
GO

-- 4. Przykład pracy z nvarchar / varchar
SELECT TOP (20)
    p.Name,
    p.ProductNumber,
    DATALENGTH(p.Name)        AS NameBytes,
    LEN(p.Name)               AS NameChars
FROM Production.Product AS p;
GO
