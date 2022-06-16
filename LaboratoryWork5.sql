USE [library];

-- �������� ����� ��������� ���������

IF OBJECT_ID(N'books_upper_case_insert') IS NOT NULL
	DROP TRIGGER [books_upper_case_insert];
GO

IF OBJECT_ID(N'books_upper_case_update') IS NOT NULL
	DROP TRIGGER [books_upper_case_update];
GO

IF OBJECT_ID(N'subscriptions_view_insert') IS NOT NULL
	DROP TRIGGER [subscriptions_view_insert];
GO

IF OBJECT_ID(N'books_with_authors_insert') IS NOT NULL
	DROP TRIGGER [books_with_authors_insert];
GO

-- �������� ����� ��������� �������������

IF OBJECT_ID(N'subscriptions_without_book_view') IS NOT NULL
	DROP VIEW [subscriptions_without_book_view];
GO

IF OBJECT_ID(N'subscriptions_start_finish_view') IS NOT NULL
	DROP VIEW [subscriptions_start_finish_view];
GO

IF OBJECT_ID(N'books_upper_case') IS NOT NULL
	DROP VIEW [books_genres_view];
GO

IF OBJECT_ID(N'subscriptions_view') IS NOT NULL
	DROP VIEW [subscriptions_view];
GO

IF OBJECT_ID(N'books_with_authors_view') IS NOT NULL
	DROP VIEW [books_with_auhtors_view];
GO

/*
	������������ ������: ������� �������������, ����� ������� ���������� �������� ���������� � ���, ����� ��������� ����� ���� ������ �������� � ����� �� �����.
	������������ � ������: 4
*/

CREATE VIEW [subscriptions_without_book_view]
AS
SELECT [sb_id],
	   [sb_subscriber],
	   [sb_start],
	   [sb_finish],
	   [sb_is_active]
FROM   [subscriptions];
GO

SELECT * FROM [subscriptions_without_book_view];
GO

/*
	������� �������������, ������������ ��� ���������� �� ������� subscriptions, ���������� ���� �� ����� sb_start � sb_finish � ������ �����-��-�� �ͻ, ��� ��ͻ � ���� ������ � ���� ������ ������� �������� (�.�. ������������, �������� � �.�.)
	������������ � ������: 5
*/

CREATE VIEW [subscriptions_start_finish_view]
AS
SELECT [sb_id],
	   [sb_subscriber],
	   [sb_book],
	   CONCAT([sb_start], ' ', CASE DATEPART(weekday, [sb_start]) 
									WHEN 1 THEN '�����������'
									WHEN 2 THEN '�������'
									WHEN 3 THEN '�����'
									WHEN 4 THEN '�������'
									WHEN 5 THEN '�������'
									WHEN 6 THEN '�������'
									WHEN 7 THEN '�����������'
							    END) AS [sb_start],
	   CONCAT([sb_finish], ' ', CASE DATEPART(weekday, [sb_finish]) 
									 WHEN 1 THEN '�����������'
									 WHEN 2 THEN '�������'
									 WHEN 3 THEN '�����'
									 WHEN 4 THEN '�������'
									 WHEN 5 THEN '�������'
									 WHEN 6 THEN '�������'
									 WHEN 7 THEN '�����������'
								END) AS [sb_finish],
	   [sb_is_active]
FROM [subscriptions];
GO

SELECT * FROM [subscriptions_start_finish_view];
GO

/*
	������������ ������: ������� �������������, ����������� ���������� � ������, �������� ���� ����� � ������� ������� � ��� ���� ����������� ����������� ������ ����
	������������ � ������: 6
*/

CREATE VIEW [books_upper_case]
WITH SCHEMABINDING 
AS
	SELECT [b_id],
		   UPPER([b_name]) AS [b_name]
	FROM   [dbo].[books];
GO

CREATE TRIGGER [books_upper_case_insert]
ON [books_upper_case]
INSTEAD OF INSERT
AS
	SET IDENTITY_INSERT [books] ON;
	INSERT INTO [books]
				([b_id], [b_name])
	SELECT (CASE
			WHEN [b_id] IS NULL OR [b_id] = 0
				THEN IDENT_CURRENT('books') + 
					 IDENT_INCR('books') +
					 ROW_NUMBER() OVER (ORDER BY (SELECT 1)) - 1
				ELSE [b_id]
			END) AS [b_id],
			[b_name]
	FROM [inserted];
	SET IDENTITY_INSERT [books] OFF;
GO

CREATE TRIGGER [books_upper_case_update]
ON [books_upper_case]
INSTEAD OF UPDATE
AS
	IF UPDATE([b_id])
	BEGIN
		PRINT(N'��������� ���� ��� ��������. ���������� ���������� ������������ ������� � ������ ��������');
		ROLLBACK;
	END
	ELSE
		UPDATE [books]
		SET [books].[b_name] = [inserted].[b_name]
		FROM [books]
			JOIN [inserted]
				ON [books].[b_id] = [inserted].[b_id];
GO

SELECT * FROM [books_upper_case];
GO

/*
	������������ ������: ������� �������������, ����������� ���������� � ����� ������ � �������� ���� � ��������� ������ ����� � ���� ������ ������ � ������� �����-��-�� - ����-��-�� - ���������� � ��� ���� ����������� ���������� ���������� � ������� subscriptions.
	������������ � ������: 7
*/

CREATE VIEW [subscriptions_view]
WITH SCHEMABINDING 
AS
	SELECT [sb_id],
		   [sb_subscriber],
		   [sb_book],
		   CONCAT([sb_start], ' - ', [sb_finish], ' - ', (CASE 
				WHEN [sb_is_active] = 'Y' THEN '�� ����������'
				ELSE '����������'
		   END)) AS [sb_dates_status]
	FROM [dbo].[subscriptions];
GO

CREATE TRIGGER [subscriptions_view_insert]
ON [subscriptions_view]
INSTEAD OF INSERT 
AS
	SET IDENTITY_INSERT [subscriptions] ON;
	INSERT INTO [subscriptions]
				([sb_id], 
				 [sb_subscriber], 
				 [sb_book], 
				 [sb_start], 
				 [sb_finish], 
				 [sb_is_active]
				)	
	SELECT (CASE 
				WHEN [sb_id] IS NULL OR [sb_id] = 0 THEN
					IDENT_CURRENT('subscriptions') +
					IDENT_INCR('subscriptions') +
					ROW_NUMBER() OVER (ORDER BY (SELECT 1)) - 1
				ELSE [sb_id]
			END) AS [sb_id],
			[sb_subscriber],
			[sb_book],
			SUBSTRING([sb_dates_status], 1, 10) AS [sb_start],
			SUBSTRING([sb_dates_status], 14, 10) AS [sb_finish],
			SUBSTRING([sb_dates_status], 27, 13) AS [sb_is_active]
	FROM [inserted];
	SET IDENTITY_INSERT [subscriptions] OFF;
GO

SELECT * FROM [subscriptions_view];
GO

/*
	������������ ������: ������� �������������, ������������ ������ ���� � �� ��������, � ��� ���� ���-�������� ��������� ����� �������.
	������������ � ������: 9
*/

CREATE VIEW [books_with_authors_view]
AS
WITH [prepared_data]
	AS (SELECT [books].[b_id],
		       [b_name],
			   [a_name]
		FROM   [books]
			   JOIN [m2m_books_authors]
					ON [books].[b_id] = [m2m_books_authors].[b_id]
			   JOIN [authors]
				    ON [m2m_books_authors].[a_id] = [authors].[a_id])
SELECT [outer].[b_id],
	   [outer].[b_name],
	   STUFF((SELECT DISTINCT ',' + [inner].[a_name]
			  FROM [prepared_data] AS [inner]
			  WHERE [outer].[b_id] = [inner].[b_id]
			  ORDER BY ',' + [inner].[a_name]
			  FOR XML PATH(''), TYPE).value('.', 'nvarchar(max)'),
			  1, 1, '')
	   AS [authors]
FROM [prepared_data] AS [outer]
GROUP BY [outer].[b_id],
	     [outer].[b_name];
GO

CREATE TRIGGER [books_with_authors_insert] 
ON [books_with_authors_view]
INSTEAD OF INSERT
AS
	INSERT INTO [authors] ([a_name])
	SELECT [authors]
	FROM [inserted];
GO

SELECT * FROM [books_with_authors_view];