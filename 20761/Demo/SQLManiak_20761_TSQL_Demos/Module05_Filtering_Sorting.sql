/*
    SQLManiak – 20761 Demo
    Moduł 5: Sortowanie, filtrowanie, paginacja
*/

USE AdventureWorks2022;
GO

-- 1. ORDER BY na wielu kolumnach
SELECT TOP (50)
    p.ProductID,
    p.Name,
    p.ListPrice
FROM Production.Product AS p
ORDER BY p.ListPrice DESC, p.Name ASC;
GO

-- 2. WHERE z IN, BETWEEN, LIKE
SELECT
    p.ProductID,
    p.Name,
    p.ListPrice
FROM Production.Product AS p
WHERE p.ListPrice BETWEEN 100 AND 500
  AND p.Color IN ('Black', 'Red')
  AND p.Name LIKE 'A%';
GO

-- 3. Paginacja: OFFSET/FETCH
SELECT
    p.ProductID,
    p.Name,
    p.ListPrice
FROM Production.Product AS p
ORDER BY p.ProductID
OFFSET 50 ROWS        -- pomiń pierwsze 50
FETCH NEXT 25 ROWS ONLY;
GO

-- 4. Praca z NULL – adresy bez regionu
SELECT TOP (50)
    a.AddressID,
    a.City,
    a.StateProvinceID
FROM Person.Address AS a
WHERE a.StateProvinceID IS NULL;
GO
