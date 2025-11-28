# SQLManiak – T-SQL Patterns dla kursu 20761

Ten plik zawiera zestaw wzorców (patterns), które możesz wykorzystywać na kursie **MOC 20761 – Querying Data with Transact-SQL** w wersji SQLManiak_Labs / SQL Server 2022.

---

## 0. Zasada główna – „czytelny T-SQL”

1. Zawsze aliasuj tabele.
2. Unikaj `SELECT *` – wypisuj konkretne kolumny.
3. Utrzymuj stałą kolejność klauzul:

```sql
SELECT      -- co chcę zobaczyć
FROM        -- skąd
JOIN        -- z czym łączę
WHERE       -- które wiersze
GROUP BY    -- grupowanie (jeśli jest)
HAVING      -- filtrowanie grup
ORDER BY    -- w jakiej kolejności
```

---

## 1. Pattern: prosty SELECT + aliasy

```sql
SELECT 
    c.CustomerId,
    c.FirstName,
    c.LastName,
    c.Email
FROM Person.Customer AS c;
```

---

## 2. Pattern: SELECT z filtrem i sortowaniem

```sql
SELECT
    p.ProductId,
    p.Name,
    p.ListPrice
FROM Product.Product AS p
WHERE p.ListPrice BETWEEN 100 AND 500
ORDER BY p.ListPrice DESC;
```

---

## 3. Pattern: JOIN 2–4 tabel

```sql
SELECT
    oh.OrderId,
    oh.OrderDate,
    c.CustomerId,
    c.FirstName + ' ' + c.LastName AS CustomerFullName,
    p.Name AS ProductName,
    ol.Quantity,
    ol.LineAmount
FROM Sales.OrderHeader AS oh
JOIN Person.Customer AS c
    ON oh.CustomerId = c.CustomerId
JOIN Sales.OrderLine AS ol
    ON oh.OrderId = ol.OrderId
JOIN Product.Product AS p
    ON ol.ProductId = p.ProductId;
```

---

## 4. Pattern: filtr na dacie – bez funkcji na kolumnie

❌ Zły wzorzec:

```sql
WHERE YEAR(oh.OrderDate) = 2023;
```

✅ Dobry wzorzec:

```sql
WHERE oh.OrderDate >= '20230101'
  AND oh.OrderDate <  '20240101';
```

---

## 5. Pattern: GROUP BY + agregaty

```sql
SELECT
    c.CustomerId,
    c.FirstName + ' ' + c.LastName AS CustomerFullName,
    COUNT(*)            AS OrdersCount,
    SUM(oh.TotalAmount) AS TotalSales
FROM Sales.OrderHeader AS oh
JOIN Person.Customer AS c
    ON oh.CustomerId = c.CustomerId
GROUP BY
    c.CustomerId,
    c.FirstName,
    c.LastName
HAVING
    SUM(oh.TotalAmount) > 10000
ORDER BY
    TotalSales DESC;
```

---

## 6. Pattern: agregacja z CASE (pseudo-PIVOT)

```sql
SELECT
    c.CustomerId,
    c.FirstName + ' ' + c.LastName AS CustomerFullName,
    SUM(CASE WHEN oh.Status = 'New'       THEN oh.TotalAmount ELSE 0 END) AS AmtNew,
    SUM(CASE WHEN oh.Status = 'Paid'      THEN oh.TotalAmount ELSE 0 END) AS AmtPaid,
    SUM(CASE WHEN oh.Status = 'Shipped'   THEN oh.TotalAmount ELSE 0 END) AS AmtShipped,
    SUM(CASE WHEN oh.Status = 'Cancelled' THEN oh.TotalAmount ELSE 0 END) AS AmtCancelled
FROM Sales.OrderHeader AS oh
JOIN Person.Customer AS c
    ON oh.CustomerId = c.CustomerId
GROUP BY
    c.CustomerId,
    c.FirstName,
    c.LastName;
```

---

## 7. Pattern: funkcje okienkowe – running total

```sql
SELECT
    oh.OrderId,
    oh.OrderDate,
    oh.TotalAmount,
    SUM(oh.TotalAmount) OVER (
        PARTITION BY YEAR(oh.OrderDate)
        ORDER BY oh.OrderDate, oh.OrderId
    ) AS RunningTotalYear
FROM Sales.OrderHeader AS oh
ORDER BY
    oh.OrderDate,
    oh.OrderId;
```

---

## 8. Pattern: funkcje okienkowe – ranking + procent udziału

```sql
WITH SalesPerCustomer AS (
    SELECT
        c.CustomerId,
        c.FirstName + ' ' + c.LastName AS CustomerFullName,
        SUM(oh.TotalAmount) AS TotalSales
    FROM Sales.OrderHeader AS oh
    JOIN Person.Customer AS c
        ON oh.CustomerId = c.CustomerId
    GROUP BY
        c.CustomerId,
        c.FirstName,
        c.LastName
)
SELECT
    CustomerId,
    CustomerFullName,
    TotalSales,
    RANK() OVER (ORDER BY TotalSales DESC) AS SalesRank,
    100.0 * TotalSales
        / SUM(TotalSales) OVER ()        AS PercentOfAll
FROM SalesPerCustomer
ORDER BY SalesRank;
```

---

## 9. Pattern: CTE jako „nazwany SELECT”

```sql
WITH CustomerOrders AS (
    SELECT
        oh.OrderId,
        oh.OrderDate,
        oh.TotalAmount,
        oh.CustomerId
    FROM Sales.OrderHeader AS oh
)
SELECT
    co.CustomerId,
    COUNT(*)             AS OrdersCount,
    SUM(co.TotalAmount)  AS TotalSales
FROM CustomerOrders AS co
GROUP BY co.CustomerId;
```

---

## 10. Pattern: podzapytanie korelowane – największe zamówienie klienta

```sql
SELECT
    oh.CustomerId,
    oh.OrderId,
    oh.TotalAmount
FROM Sales.OrderHeader AS oh
WHERE oh.TotalAmount = (
    SELECT MAX(oh2.TotalAmount)
    FROM Sales.OrderHeader AS oh2
    WHERE oh2.CustomerId = oh.CustomerId
);
```

---

## 11. Pattern: PIVOT na statusach zamówień

```sql
WITH SalesStatus AS (
    SELECT
        YEAR(oh.OrderDate) AS OrderYear,
        oh.Status,
        oh.TotalAmount
    FROM Sales.OrderHeader AS oh
)
SELECT
    OrderYear,
    ISNULL([New],       0) AS AmountNew,
    ISNULL([Paid],      0) AS AmountPaid,
    ISNULL([Shipped],   0) AS AmountShipped,
    ISNULL([Cancelled], 0) AS AmountCancelled
FROM SalesStatus
PIVOT (
    SUM(TotalAmount)
    FOR Status IN ([New], [Paid], [Shipped], [Cancelled])
) AS p
ORDER BY OrderYear;
```

---

## 12. Pattern: podstawowy DML (INSERT / UPDATE / DELETE)

```sql
-- INSERT
INSERT INTO Product.Product (CategoryId, Name, Code, ListPrice)
VALUES (1, 'Kubek SQLManiak', 'ACC-MUG', 49.99);

-- UPDATE
UPDATE p
SET p.ListPrice = p.ListPrice * 1.10
FROM Product.Product AS p
WHERE p.CategoryId = 1;

-- DELETE
DELETE FROM Product.Product
WHERE ProductId = 123;
```

Przy DELETE zawsze ucz kursantów, żeby testowali warunek:

```sql
BEGIN TRAN;

DELETE FROM Product.Product
WHERE ProductId = 123;

-- SELECT kontrolny
SELECT * FROM Product.Product WHERE ProductId = 123;

ROLLBACK TRAN;  -- lub COMMIT TRAN
```

---

## 13. Pattern: UPSERT (UPDATE + IF @@ROWCOUNT = 0 INSERT)

```sql
DECLARE
    @Code      NVARCHAR(30)  = 'ACC-MUG',
    @Name      NVARCHAR(100) = 'Kubek SQLManiak',
    @NewPrice  DECIMAL(18,2) = 49.99;

UPDATE p
SET 
    p.ListPrice   = @NewPrice
FROM Product.Product AS p
WHERE p.Code = @Code;

IF @@ROWCOUNT = 0
BEGIN
    INSERT INTO Product.Product (CategoryId, Name, Code, ListPrice)
    VALUES (1, @Name, @Code, @NewPrice);
END;
```

---

## 14. Sugestia użycia na kursie

- Możesz wydrukować ten plik jako „SQLManiak Patterns – 20761” i dawać jako ściągę.
- Możesz też odwoływać się w materiałach:
  - „Tutaj używamy patternu *Join 3–4 tabel*”
  - „To jest pattern *CTE + okienka*”
  - „Tu stosujemy pattern *filtr daty bez funkcji*”.

Dzięki temu uczestnicy uczą się nie tylko składni, ale **stylu pisania T-SQL**.
