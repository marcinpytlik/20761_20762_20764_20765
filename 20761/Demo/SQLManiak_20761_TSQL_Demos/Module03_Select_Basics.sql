/*
    SQLManiak – 20761 Demo
    Moduł 3: SELECT, aliasy, DISTINCT, CASE
*/

USE AdventureWorks2022;
GO

-- 1. Podstawowy SELECT z aliasami
SELECT
    p.BusinessEntityID AS Id,
    p.FirstName        AS Imie,
    p.LastName         AS Nazwisko
FROM Person.Person AS p;
GO

-- 2. DISTINCT – różne miasta klientów
SELECT DISTINCT
    a.City
FROM Person.Address AS a
ORDER BY a.City;
GO

-- 3. CASE – klasyfikacja wartości sprzedaży
SELECT
    soh.SalesOrderID,
    soh.TotalDue,
    CASE
        WHEN soh.TotalDue < 1000     THEN 'Małe zamówienie'
        WHEN soh.TotalDue < 10000    THEN 'Średnie zamówienie'
        ELSE 'Duże zamówienie'
    END AS OrderSize
FROM Sales.SalesOrderHeader AS soh;
GO

-- 4. Funkcje tekstowe – przygotowanie pełnego imienia
SELECT
    p.BusinessEntityID,
    CONCAT(p.FirstName, ' ', ISNULL(p.MiddleName + ' ', ''), p.LastName) AS FullName
FROM Person.Person AS p;
GO
