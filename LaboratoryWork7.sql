USE [library];
GO

/* 
	������������ ������: 

	������� �������� ���������, �������:
		a.	��������� ������ ����� ��� ��������� �����;
		b.	�������� ����������� ��������, ���� � �������� ������ ���� �� ���� �������� 
		    ������� ����������� ������� � ���� ������������ �������� ������-���� ����� �������
			�m2m_books_genres� (�.�. � ����� ����� ��� ��� ����� ����).

	���������� �����: 1

*/
CREATE OR ALTER PROCEDURE GET_ERROR_MESSAGE
AS
	SELECT ERROR_NUMBER() AS ErrorNumber,
		   ERROR_SEVERITY() AS ErrorSeverity,
		   ERROR_STATE() AS ErrorState,
		   ERROR_PROCEDURE() AS ErrorProcedure,
		   ERROR_LINE() AS ErrorLine,
		   ERROR_MESSAGE() AS ErrorMessage
GO

CREATE OR ALTER PROCEDURE TWO_RANDOM_GENRES
AS
BEGIN 
	DECLARE @b_id_value INT;
	DECLARE @g_id_value INT;
	
	DECLARE books_cursor CURSOR LOCAL FAST_FORWARD FOR
		SELECT [b_id]
		FROM [books];

	DECLARE genres_cursor CURSOR LOCAL FAST_FORWARD FOR
		SELECT TOP 3 [g_id]
		FROM [genres]
		ORDER BY NEWID();

	DECLARE @fetch_books_cursor INT;
	DECLARE @fetch_genres_cursor INT;

	PRINT 'Starting transaction...';
	BEGIN TRANSACTION;

	OPEN books_cursor
	FETCH NEXT FROM books_cursor INTO @b_id_value;
	SET @fetch_books_cursor = @@FETCH_STATUS;

	SET XACT_ABORT ON;

	WHILE @fetch_books_cursor = 0
	BEGIN
		OPEN genres_cursor;
		FETCH NEXT FROM genres_cursor INTO @g_id_value;
		SET @fetch_genres_cursor = @@FETCH_STATUS;
		
		WHILE @fetch_genres_cursor = 0
		BEGIN
			BEGIN TRY
				INSERT INTO [m2m_books_genres]
							([b_id],
							[g_id])
				VALUES		(@b_id_value,
							 @g_id_value);
			END TRY
			BEGIN CATCH
				IF (XACT_STATE()) = -1
				BEGIN
					PRINT N'The transaction is in an uncommitable state. Rolling back...';
					ROLLBACK TRANSACTION;
					RETURN;
				END;
			END CATCH

			FETCH NEXT FROM genres_cursor INTO @g_id_value;
			SET @fetch_genres_cursor = @@FETCH_STATUS;
		END;
		CLOSE genres_cursor;

		FETCH NEXT FROM books_cursor INTO @b_id_value;
		SET @fetch_books_cursor = @@FETCH_STATUS;
	END;

	CLOSE books_cursor;
	DEALLOCATE books_cursor;
	DEALLOCATE genres_cursor;

	PRINT 'Commiting transaction...';
	COMMIT TRANSACTION;
END;
GO

EXEC TWO_RANDOM_GENRES;
SELECT * FROM [m2m_books_genres];
GO

/* 
	������������ ������: 

	������� �������� ���������, �������:
		a.	����������� �������� ���� �b_quantity� ��� ���� ���� � ��� ����;
		b.	�������� ����������� ��������, ���� �� ����� ���������� �������� 
		������� ���������� ����������� ���� �������� �������� 50.

	���������� �����: 2

*/
CREATE OR ALTER PROCEDURE DOUBLE_QUANTITY
AS
	DECLARE @b_id_value INT;
	DECLARE books_cursor CURSOR LOCAL FAST_FORWARD FOR
		SELECT [b_id]
		FROM [books];

	DECLARE @fetch_books_cursor INT;

	PRINT 'Starting transaction...';
	BEGIN TRANSACTION;

	OPEN books_cursor;
	FETCH NEXT FROM books_cursor INTO @b_id_value;
	SET @fetch_books_cursor = @@FETCH_STATUS;

	WHILE @fetch_books_cursor = 0
	BEGIN
		UPDATE [books] 
		SET [b_quantity] = [b_quantity] * 2
		WHERE [b_id] = @b_id_value;

		FETCH NEXT FROM books_cursor INTO @b_id_value;
		SET @fetch_books_cursor = @@FETCH_STATUS;
	END;

	CLOSE books_cursor;
	DEALLOCATE books_cursor;

	IF (SELECT AVG([b_quantity]) 
		FROM [books]) > 50
	BEGIN
		PRINT 'Rolling transaction back';
		ROLLBACK TRANSACTION;
	END
	ELSE
	BEGIN
		PRINT 'Commiting transaction';
		COMMIT TRANSACTION;
	END;
GO

EXECUTE DOUBLE_QUANTITY;
SELECT * FROM [books];
GO

/*
	������������ ������:

	�������� �������, �������, ������ ������������ �����������, ������������ �� ��������� ������:
	a.	������ ������ ������ ������� ���������� �������� �� ���� � ���������-��� 
		� ���������� ���� � �� �������� �� �������� �� ���������� ������� �subscriptions� (�� ����� �� ����������);
	b.	������ ������ ������ ������������� �������� ���� �sb_is_active� ������� 
		subscriptions � �Y� �� �N� � �������� � �� �������� �� ������� ������� (�� ����� ��� ����������).

	���������� �����: 3
*/
SELECT @@SPID AS [SPID];
SET IMPLICIT_TRANSACTIONS ON;
BEGIN TRANSACTION
	-- Given books
	SELECT COUNT([sb_id]) AS [given]
	FROM [subscriptions]
	WHERE [sb_is_active] = 'Y';

	-- Taken books
	SELECT COUNT([sb_id]) AS [returned]
	FROM [subscriptions]
	WHERE [sb_is_active] = 'N';
COMMIT TRANSACTION;

SELECT @@SPID AS [SPID];
SET IMPLICIT_TRANSACTIONS ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN TRANSACTION;
	UPDATE [subscriptions]
	SET [sb_is_active] = CASE WHEN [sb_is_active] = 'Y' THEN 'N' ELSE 'Y' END;

COMMIT TRANSACTION;

SELECT * FROM [subscriptions];

/* 
	������������ ������: 

	�������� �������, �������, ������ ������������ �����������, ������������ �� ��������� ������:
	a.	������ ������ ������ ������� ���������� �������� �� ���� � ���������-��� � ���������� ����;
	b.	������ ������ ������ ������������� �������� ���� �sb_is_active� ������� �subscriptions� � 
	�Y� �� �N� � �������� ��� ��������� � ��������� ������-����������, ����� ���� ������ ����� � 
	������ ������ � �������� ������ ��-������� (�������� ����������).

	���������� �����: 4
*/
SELECT @@SPID AS [SPID]
SET IMPLICIT_TRANSACTIONS ON;

BEGIN TRANSACTION;

-- The number of taken books
SELECT COUNT([sb_id]) AS [taken]
FROM [subscriptions]
WHERE [sb_is_active] = 'Y';

-- The number of returned books
SELECT COUNT([sb_id]) AS [returned]
FROM [subscriptions]
WHERE [sb_is_active] = 'N';

-- Commiting transaction
COMMIT TRANSACTION;
PRINT N'First transaction is commited...';

SELECT @@SPID AS [SPID]
SET IMPLICIT_TRANSACTIONS ON;

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

BEGIN TRANSACTION

-- Update all subscriptions' statuses with odd identifiers
UPDATE [subscriptions]
SET [sb_is_active] = (CASE WHEN [sb_is_active] = 'Y' THEN 'N' ELSE 'Y' END)
WHERE [sb_subscriber] % 2 > 0;
PRINT N'Fields are updated';

-- Ten seconds delay
WAITFOR DELAY '00:00:10';

-- Roll back transaction
ROLLBACK TRANSACTION;
PRINT N'Second transaction is rolled back...';

SELECT * FROM [subscriptions];
GO

/*
	������������ ������: 

	������� �� ������� �subscriptions� �������, ������������ ������� 
	������������-��� ����������, � ������� ������ �������� �������� ����������, 
	� ���������� ��������, ���� ������� ��������������� ���������� ������� �� REPEATABLE READ.

	���������� �����: 6
*/
CREATE OR ALTER TRIGGER [subscriptions_upd_trans]
ON [subscriptions]
AFTER UPDATE
AS
	DECLARE @isolation_level NVARCHAR(50);

	SET @isolation_level = 
	(
		SELECT [transaction_isolation_level]
		FROM [sys].[dm_exec_sessions]
		WHERE [session_id] = @@SPID
	);

	IF (@isolation_level != 3)
	BEGIN
		RAISERROR ('Please, switch your transaction to REPEATABLE READ isolation level and rerun this UPDATE again.', 16, 1);
		ROLLBACK TRANSACTION;
		RETURN;
	END;
GO

-- Successful
SET TRANSACTION ISOLATION
LEVEL REPEATABLE READ;

UPDATE [subscriptions]
SET [sb_is_active] = 'Y'
WHERE [sb_subscriber] % 2 = 0;

-- Error
SET TRANSACTION ISOLATION
LEVEL READ COMMITTED;

UPDATE [subscriptions]
SET [sb_is_active] = 'Y'
WHERE [sb_subscriber] % 2 = 0;