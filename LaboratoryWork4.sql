USE [library];

/*
	������������ ������: �������� � ���� ������ ���������� � ����� ����� ���������: ������ �.�.�, �������� �.�.�, ��������� �.��
	������������ � ������: 1
*/
INSERT INTO [subscribers]
			([s_name])
VALUES      ('����� �.�.'),
			('������� �.�.'),
			('�������� �.�.');

/*
	������������ ������: �������� � ���� ������ ���������� � ���, ��� ������ �� ����� ����������� ����-����� 20-�� ������ 2016-�� ���� �� ����� ���� � ���������� ����� ����� ���������-���� ������.
	������������ � ������: 2
*/
INSERT INTO [subscriptions]
			([sb_subscriber],
			 [sb_book],
			 [sb_start],
			 [sb_finish],
			 [sb_is_active])
VALUES      (5, 
			 6, 
			 CAST(N'2016-01-20' AS DATE),
			 CAST(N'2016-02-20' AS DATE),
			 N'Y'
			),
			(6,
			 6,
			 CAST(N'2016-01-20' AS DATE),
			 CAST(N'2016-02-20' AS DATE),
			 N'Y'
			),
			(7,
			 6,
			 CAST(N'2016-01-20' AS DATE),
			 CAST(N'2016-02-20' AS DATE),
			 N'Y'
			);

/*
	������������ ������: �������� � ���� ������ ���� ����� ������� � ������ ���� ���� ������� (�� ��� �� �������); ���� �����������, �������� � ���� ������ ��������������� �����. ��-������ ��������� ����������� ���� � �� �������������� � ��������������� ���-���.
	������������ � ������: 3
*/

-- ���������� ����� ������

INSERT INTO [genres]
			([g_name])
VALUES		(N'�������'),
			(N'���������'),
			(N'�����'),
			(N'�������');

-- ���������� ����� �������

INSERT INTO [authors]
			([a_name])
VALUES      (N'�.�. ������'),
			(N'�. ���������'),
			(N'�. ��������'),
			(N'�. �����'),
			(N'�.�. ��������');

-- ���������� ����� ����

INSERT INTO [books]
			([b_name],
			 [b_year],
			 [b_quantity])
VALUES		(N'�������', 1952, 7),
			(N'������� ����', 1984, 5),
			(N'����������� ����������', 2000, 3),
			(N'������������ ����', 2002, 4),
			(N'���� ���������������� ��', 2001, 6),
			(N'�������� ����� ����������������', 2001, 6),
			(N'UNIX ��� ������������� � �������������', 2002, 4),
			(N'������ � ���������', 1999, 5),
			(N'������� ������', 1993, 3);

-- ���������� ������ � �������������� ����� � �������������(��) ������(��)

INSERT INTO [m2m_books_authors]
			([b_id], [a_id])
VALUES		(
			  (SELECT [b_id] FROM [books] WHERE [b_name] = '�������'),
			  (SELECT [a_id] FROM [authors] WHERE [a_name] = '�.�. ������')
			),
			(
			  (SELECT [b_id] FROM [books] WHERE [b_name] = '������� ����'),
			  (SELECT [a_id] FROM [authors] WHERE [a_name] = '�.�. ������')
			),
			(
			  (SELECT [b_id] FROM [books] WHERE [b_name] = '����������� ����������'),
			  (SELECT [a_id] FROM [authors] WHERE [a_name] = '�. ���������')
			),
			(
			  (SELECT [b_id] FROM [books] WHERE [b_name] = '������������ ����'),
			  (SELECT [a_id] FROM [authors] WHERE [a_name] = '�. ���������')
			),
			(
			  (SELECT [b_id] FROM [books] WHERE [b_name] = '���� ���������������� ��'),
			  (SELECT [a_id] FROM [authors] WHERE [a_name] = '�. ��������')
			),
			(
			  (SELECT [b_id] FROM [books] WHERE [b_name] = '�������� ����� ����������������'),
			  (SELECT [a_id] FROM [authors] WHERE [a_name] = '�. ��������')
			),
			(
			  (SELECT [b_id] FROM [books] WHERE [b_name] = '���� ���������������� ��'),
			  (SELECT [a_id] FROm [authors] WHERE [a_name] = '�. �����')
			),
			(
			  (SELECT [b_id] FROM [books] WHERE [b_name] = 'UNIX ��� ������������� � �������������'),
			  (SELECT [a_id] FROM [authors] WHERE [a_name] = '�. �����')
			),
			(
			  (SELECT [b_id] FROM [books] WHERE [b_name] = '������ � ���������'),
			  (SELECT [a_id] FROM [authors] WHERE [a_name] = '�.�. ��������')
			),
			(
			  (SELECT [b_id] FROM [books] WHERE [b_name] = '������� ������'),
			  (SELECT [a_id] FROM [authors] WHERE [a_name] = '�.�. ��������')
			);

-- ���������� ������ � �������������� ����� � �������������(��) �����(��)

INSERT INTO [m2m_books_genres]
			([b_id], [g_id])
VALUES		(
			   (SELECT [b_id] FROM [books] WHERE [b_name] = '�������'),
			   (SELECT [g_id] FROM [genres] WHERE [g_name] = '�������')
			),
			(
			   (SELECT [b_id] FROM [books] WHERE [b_name] = '������� ����'),
			   (SELECT [g_id] FROM [genres] WHERE [g_name] = '���������')
			),
			(
			   (SELECT [b_id] FROM [books] WHERE [b_name] = '����������� ����������'),
			   (SELECT [g_id] FROM [genres] WHERE [g_name] = '����������������')
			),
			(
			   (SELECT [b_id] FROM [books] WHERE [b_name] = '������������ ����'),
			   (SELECT [g_id] FROM [genres] WHERE [g_name] = '����������������')
			),
			(
			   (SELECT [b_id] FROM [books] WHERE [b_name] = '���� ���������������� ��'),
			   (SELECT [g_id] FROM [genres] WHERE [g_name] = '����������������')
			),
			(
			   (SELECT [b_id] FROM [books] WHERE [b_name] = '�������� ����� ����������������'),
			   (SELECT [g_id] FROM [genres] WHERE [g_name] = '����������������')
			),
			(
			   (SELECT [b_id] FROM [books] WHERE [b_name] = 'UNIX ��� ������������� � �������������'),
			   (SELECT [g_id] FROM [genres] WHERE [g_name] = '����������������')
			),
			(
			   (SELECT [b_id] FROM [books] WHERE [b_name] = '������ � ���������'),
			   (SELECT [g_id] FROM [genres] WHERE [g_name] = '�����')
			),
			(
			   (SELECT [b_id] FROM [books] WHERE [b_name] = '������� ������'),
			   (SELECT [g_id] FROM [genres] WHERE [g_name] = '�������')
			);

-- ������������ ��������� � �������������� ����� � ������������� �����

SELECT [b_name] AS [book_name],
	   [a_name] AS [author_name],
	   [g_name] AS [genre_name]
FROM   [books]
	   JOIN [m2m_books_authors]
	   ON [books].[b_id] = [m2m_books_authors].[b_id]
	   JOIN [authors]
	   ON [m2m_books_authors].[a_id] = [authors].[a_id]
	   JOIN [m2m_books_genres]
	   ON [books].[b_id] = [m2m_books_genres].[b_id]
	   JOIN [genres]
	   ON [m2m_books_genres].[g_id] = [genres].[g_id];

/*
	������������ ������: �������� ��� �������������� ��� ������, ���������� ��������� � ������������-��� 2.
	������������ � ������: 6
*/

-- ���������� �������� � ��������������� 2 ��� ������������ ������

INSERT INTO [subscriptions]
			(
			 [sb_subscriber], 
			 [sb_book], 
			 [sb_start], 
			 [sb_finish], 
			 [sb_is_active]
			)
VALUES		(2, 3, CAST(N'2015-01-13' AS DATE), CAST(N'2015-01-26' AS DATE), 'N'),
			(2, 4, CAST(N'2015-02-5' AS DATE), CAST(N'2015-02-17' AS DATE), 'N'),
			(2, 5, CAST(N'2015-03-9' AS DATE), CAST(N'2015-03-24' AS DATE), 'Y'),
			(2, 6, CAST(N'2016-04-10' AS DATE), CAST(N'2016-04-21' AS DATE), 'Y'),
			(2, 7, CAST(N'2016-05-14' AS DATE), CAST(N'2016-05-29' AS DATE), 'N');

-- ������� ���� ����� ��� ��������������

UPDATE [subscriptions]
SET [sb_is_active] = 'Y'
WHERE [sb_subscriber] = 2;


/*
	������������ ������: �������� � ���� ������ ����� ���������, ������������, ���������.
	������������ � ������: 10
*/
MERGE INTO [genres]
USING (VALUES (N'��������'),
			  (N'����������'),
			  (N'�������')) AS [new_genres] ([g_name])
ON [genres].[g_name] = [new_genres].[g_name]
WHEN NOT MATCHED BY TARGET THEN
	INSERT ([g_name])
	VALUES ([new_genres].[g_name]);
