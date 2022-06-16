USE [library];
GO

/*
	������������ ������: 
	
	������� �������� �������, ���������� �� ���� ������������� �������� 
	� ���-��������� ������ ��������������� ����, ������� �� ��� �������� � ������ � ����������.

	���������� ����� ������: 1
*/
CREATE OR ALTER FUNCTION GET_READ_BOOKS(@reader_id INT)
RETURNS @books TABLE
	(
		[book_id] INT
	)
AS
BEGIN
	INSERT @books
		SELECT [sb_book]
		FROM [subscriptions]
		WHERE ([sb_subscriber] = @reader_id) AND ([sb_is_active] = 'N')
	RETURN
END;
GO

SELECT * FROM GET_READ_BOOKS(1);
GO



/* 
	������������ ������: 
	
	������� �������� �������, ������������ ������ ������� ��������� ��������� �������� 
	�������������������� ��������� ������ � ��������� ������� (�����-���, ���� � ������� ���� ��������� 
	����� 1, 4, 8, �� ������ ��������� �������� � ��� �������� 2 � 3). 

	���������� �����: 2
*/

CREATE OR ALTER FUNCTION GET_FIRST_RANGE_FREE_KEYS()
RETURNS @first_range_free_keys TABLE
	(
		[start] INT,
		[stop] INT
	)
AS
BEGIN
	INSERT @first_range_free_keys
	SELECT TOP 1 [start],
				 [stop]
	FROM (SELECT [min_t].[sb_id] + 1 AS [start],
				 (SELECT MIN([sb_id]) - 1
				  FROM [subscriptions] AS [x]
				  WHERE [x].[sb_id] > [min_t].[sb_id]) AS [stop]
		  FROM [subscriptions] AS [min_t]
		  UNION
		  SELECT 1 AS [start],
				 (SELECT MIN([sb_id]) - 1
				  FROM [subscriptions] AS [x]
				  WHERE [sb_id] > 0) AS [stop]
		 ) AS [data]
	WHERE [stop] >= [start]
	ORDER BY [start],
			 [stop]
	RETURN
END;
GO

SELECT * FROM GET_FIRST_RANGE_FREE_KEYS();
GO

/* 
	������������ ������: 
	
	������� �������� �������, ���������� �� ���� ������������� �������� � ���-��������� 1, 
	���� � �������� �� ����� ������ ����� ������ ����, � 0 � ��������� ������.

	���������� ����� 3
*/
CREATE OR ALTER FUNCTION [dbo].BOOKS_LESS_THEN_TEN(@reader_id INT)
RETURNS INT
AS
BEGIN
	DECLARE @result INT;
	DECLARE @booksNumber INT;
	SET @result = 1;

	IF (SELECT COUNT([sb_book]) 
			   FROM [subscriptions] 
			   WHERE ([sb_subscriber] = @reader_id) AND 
				     ([sb_is_active] = 'Y')) < 10
	BEGIN
		SET @result = 0;
	END;

	RETURN @result;
END;
GO

SELECT [dbo].BOOKS_LESS_THEN_TEN(1) AS 'result';
GO

/* 
	������������ ������: 

	������� �������� �������, ���������� �� ���� ��� ������� ����� � ���������-��� 1, 
	���� ����� ������ ����� ��� ��� �����, � 0 � ��������� ������.

	���������� �����: 4
*/

CREATE OR ALTER FUNCTION [dbo].PUBLISHED_LESS_HUNDRED(@date DATETIME)
RETURNS INT
AS
BEGIN
	DECLARE @result INT;

	IF DATEDIFF(year, @date, GETDATE()) < 100 
		SET @result = 1;
	ELSE
		SET @result = 0;

	RETURN @result;
END;
GO

SELECT [dbo].PUBLISHED_LESS_HUNDRED('2000-05-05') AS 'result';
GO

/* 
	������������ ������: 

	������� �������� ���������, ����������� ��� ���� ���� DATE 
	(���� ����� ����) ���� ������� ��������� ������� �� �������� ������� ����.

	���������� �����: 5
*/
CREATE OR ALTER PROCEDURE [dbo].UPDATE_WITH_CURRENT_DATE
WITH EXECUTE AS OWNER
AS
	UPDATE [library].[dbo].[subscriptions]
	SET [sb_start] = GETDATE(), [sb_finish] = GETDATE()
GO

EXEC [dbo].UPDATE_WITH_CURRENT_DATE;

SELECT * FROM [subscriptions];
GO