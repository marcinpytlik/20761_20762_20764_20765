/*
    SQLManiak – 20761 Demo
    Moduł 1: Wprowadzenie do SQL Server, obiekty, metadane
*/

USE master;
GO

-- 1. Podstawowe informacje o instancji
SELECT
    @@SERVERNAME     AS ServerName,
    @@VERSION        AS SqlVersion,
    SERVERPROPERTY('ProductLevel') AS ProductLevel,
    SERVERPROPERTY('Edition')      AS Edition;
GO

-- 2. Bazy danych na instancji
SELECT
    name,
    database_id,
    state_desc,
    recovery_model_desc
FROM sys.databases
ORDER BY name;
GO

-- 3. Systemowe bazy danych
SELECT name, database_id, state_desc, recovery_model_desc
FROM sys.databases
WHERE database_id <= 4
ORDER BY database_id;
GO

-- 4. Przykład wejścia do bazy AdventureWorks2022
USE AdventureWorks2022;
GO

-- 5. Obiekty w schemacie Person
SELECT
    o.object_id,
    o.name,
    o.type,
    o.type_desc
FROM sys.objects AS o
WHERE o.schema_id = SCHEMA_ID('Person')
ORDER BY o.type_desc, o.name;
GO

-- 6. Kolumny w tabeli Person.Person
SELECT
    c.name       AS ColumnName,
    t.name       AS DataType,
    c.max_length,
    c.is_nullable
FROM sys.columns AS c
JOIN sys.types   AS t ON c.user_type_id = t.user_type_id
WHERE c.object_id = OBJECT_ID('Person.Person')
ORDER BY c.column_id;
GO
