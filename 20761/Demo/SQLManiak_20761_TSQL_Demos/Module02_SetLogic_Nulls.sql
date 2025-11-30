/*
    SQLManiak – 20761 Demo
    Moduł 2: Logika setowa i NULL
*/

USE AdventureWorks2022;
GO

-- 1. Set-based vs proceduralne myślenie (prosty przykład)
-- Zliczamy ilu pracowników pracuje w każdym dziale

SELECT
    d.DepartmentID,
    d.Name       AS DepartmentName,
    COUNT(*)     AS EmployeesCount
FROM HumanResources.EmployeeDepartmentHistory AS edh
JOIN HumanResources.Department AS d
    ON edh.DepartmentID = d.DepartmentID
GROUP BY d.DepartmentID, d.Name
ORDER BY EmployeesCount DESC;
GO

-- 2. NULL w porównaniach – różnice
SELECT
    p.BusinessEntityID,
    p.FirstName,
    p.MiddleName,
    p.LastName
FROM Person.Person AS p
WHERE p.MiddleName = 'A';           -- ścisłe porównanie
GO

-- porównanie z IS NULL
SELECT
    p.BusinessEntityID,
    p.FirstName,
    p.MiddleName,
    p.LastName
FROM Person.Person AS p
WHERE p.MiddleName IS NULL;         -- NULL wymaga IS NULL
GO

-- 3. Logika trójwartościowa – UNKNOWN
-- Pokaż osoby, których MiddleName nie jest 'A' – uwaga na NULL!
SELECT
    p.BusinessEntityID,
    p.FirstName,
    p.MiddleName,
    p.LastName
FROM Person.Person AS p
WHERE p.MiddleName <> 'A';          -- NULL nie spełnia ani TRUE, ani FALSE
GO

-- Bezpieczniejsza wersja:
SELECT
    p.BusinessEntityID,
    p.FirstName,
    p.MiddleName,
    p.LastName
FROM Person.Person AS p
WHERE p.MiddleName IS NOT NULL
  AND p.MiddleName <> 'A';
GO
