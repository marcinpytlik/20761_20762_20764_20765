/*
    SQLManiak – 20761 Demo
    Moduł 14: Programowanie T-SQL – zmienne, procedury, TRY/CATCH, transakcje
*/

USE tempdb;
GO

IF OBJECT_ID('dbo.DemoAccount', 'U') IS NOT NULL
    DROP TABLE dbo.DemoAccount;
GO

CREATE TABLE dbo.DemoAccount
(
    AccountID INT IDENTITY PRIMARY KEY,
    Name      NVARCHAR(100),
    Balance   DECIMAL(18,2)
);
GO

INSERT INTO dbo.DemoAccount (Name, Balance)
VALUES ('Konto A', 1000.00),
       ('Konto B', 500.00);
GO

-- 1. Prosta transakcja z przeniesieniem środków
BEGIN TRAN;

UPDATE dbo.DemoAccount
SET Balance = Balance - 100
WHERE Name = 'Konto A';

UPDATE dbo.DemoAccount
SET Balance = Balance + 100
WHERE Name = 'Konto B';

SELECT * FROM dbo.DemoAccount;

ROLLBACK TRAN;
GO

SELECT * FROM dbo.DemoAccount;
GO

-- 2. Procedura z TRY/CATCH i transakcją
IF OBJECT_ID('dbo.usp_TransferMoney', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_TransferMoney;
GO

CREATE PROCEDURE dbo.usp_TransferMoney
    @FromAccountID INT,
    @ToAccountID   INT,
    @Amount        DECIMAL(18,2)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRAN;

        UPDATE dbo.DemoAccount
        SET Balance = Balance - @Amount
        WHERE AccountID = @FromAccountID;

        IF @@ROWCOUNT = 0
            THROW 50001, 'Nie znaleziono konta źródłowego.', 1;

        UPDATE dbo.DemoAccount
        SET Balance = Balance + @Amount
        WHERE AccountID = @ToAccountID;

        IF @@ROWCOUNT = 0
            THROW 50002, 'Nie znaleziono konta docelowego.', 1;

        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRAN;

        DECLARE
            @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE(),
            @ErrorNumber  INT            = ERROR_NUMBER();

        RAISERROR('Błąd %d: %s', 16, 1, @ErrorNumber, @ErrorMessage);
    END CATCH;
END;
GO

-- 3. Test procedury
EXEC dbo.usp_TransferMoney
    @FromAccountID = 1,
    @ToAccountID   = 2,
    @Amount        = 150.00;
GO

SELECT * FROM dbo.DemoAccount;
GO
