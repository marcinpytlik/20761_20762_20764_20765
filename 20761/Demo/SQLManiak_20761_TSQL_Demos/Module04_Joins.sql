/*
    SQLManiak – 20761 Demo
    Moduł 4: JOIN – łączenie tabel
*/

USE AdventureWorks2022;
GO

-- 1. INNER JOIN – zamówienia + klienci
SELECT TOP (20)
    soh.SalesOrderID,
    soh.OrderDate,
    p.FirstName,
    p.LastName,
    soh.TotalDue
FROM Sales.SalesOrderHeader AS soh
JOIN Sales.Customer AS c
    ON soh.CustomerID = c.CustomerID
JOIN Person.Person AS p
    ON c.PersonID = p.BusinessEntityID
ORDER BY soh.OrderDate DESC;
GO

-- 2. LEFT JOIN – pracownicy i ich telefony (nie każdy musi mieć)
SELECT TOP (20)
    e.BusinessEntityID,
    p.FirstName,
    p.LastName,
    pph.PhoneNumber
FROM HumanResources.Employee AS e
JOIN Person.Person AS p
    ON e.BusinessEntityID = p.BusinessEntityID
LEFT JOIN Person.PersonPhone AS pph
    ON p.BusinessEntityID = pph.BusinessEntityID
ORDER BY e.BusinessEntityID;
GO

-- 3. CROSS JOIN – kombinacja kolorów i rozmiarów (uwaga na liczbę wierszy)
SELECT TOP (50)
    c.ColorName,
    s.SizeName
FROM (VALUES ('Red'), ('Blue'), ('Green')) AS c(ColorName)
CROSS JOIN (VALUES ('S'), ('M'), ('L'), ('XL')) AS s(SizeName);
GO

-- 4. SELF JOIN – menedżer i podwładny
SELECT TOP (20)
    e.BusinessEntityID       AS EmployeeId,
    pe.FirstName             AS EmployeeFirstName,
    pe.LastName              AS EmployeeLastName,
    m.BusinessEntityID       AS ManagerId,
    pm.FirstName             AS ManagerFirstName,
    pm.LastName              AS ManagerLastName
FROM HumanResources.Employee AS e
LEFT JOIN HumanResources.Employee AS m
    ON e.OrganizationNode.GetAncestor(1) = m.OrganizationNode
JOIN Person.Person AS pe
    ON e.BusinessEntityID = pe.BusinessEntityID
LEFT JOIN Person.Person AS pm
    ON m.BusinessEntityID = pm.BusinessEntityID;
GO
