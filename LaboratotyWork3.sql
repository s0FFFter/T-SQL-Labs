USE [library]

/*
	������������ ������: �������� ������ ����, � ������� ����� ������ ������.
	������������ � ������: 1
	������� �1: �������� �������������� � �������� �����, � ����� ������ �������
*/
SELECT [books].[b_id] AS [book_id],
	   [books].[b_name] AS [book_name],
	   STRING_AGG([a_name], ', ') AS [list_authors]
FROM   [books]
	   JOIN [m2m_books_authors]
		 ON [books].[b_id] = [m2m_books_authors].[b_id]
	   JOIN [authors]
		 ON [m2m_books_authors].[a_id] = [authors].[a_id]
WHERE  [books].[b_id] IN (SELECT [b_id]
				  FROM   [m2m_books_authors]
				  GROUP BY [b_id]
				  HAVING COUNT([b_id]) >= 2)
GROUP BY [books].[b_id], 
	     [books].[b_name];

/* 
	������������ ������: �������� ������ ����, � ������� ����� ������ ������.
	������������ � ������: 1
	������� �1: �������� �������������� � �������� �����, � ����� ���������� �������
*/
SELECT [books].[b_id] AS [book_id],
	   [books].[b_name] AS [book_name],
	   COUNT([m2m_books_authors].[a_id]) AS [authors_count]
FROM   [books]
	   JOIN [m2m_books_authors]
	     ON [books].[b_id] = [m2m_books_authors].[b_id]
GROUP BY [books].[b_id],
		 [books].[b_name]
HAVING COUNT([m2m_books_authors].[a_id]) > 1;

/*
	������������ ������: �������� ������ ����, ����������� ����� � ������ �����.
	������������ � ������: 2
*/
SELECT [books].[b_id] AS [book_id],
	   [b_name] AS [book_name],
       [g_name] AS [genre_name]
FROM   [books]
	   JOIN [m2m_books_genres]
	   ON [books].[b_id] = [m2m_books_genres].[b_id]
	   JOIN [genres]
	   ON [m2m_books_genres].[g_id] = [genres].[g_id]
WHERE  [books].[b_id] IN (SELECT [b_id]
						  FROM [m2m_books_genres]
						  GROUP BY [b_id]
						  HAVING COUNT([b_id]) = 1);

/*
	������������ ������: �������� ��� ����� � �� ������� (������������ �������� ���� �� �����������)
	������������ � ������: 3
*/
SELECT [b_name],
	   STRING_AGG([g_name], ', ') AS [genre_names]
FROM   [books]
	   JOIN [m2m_books_genres]
	   ON [books].[b_id] = [m2m_books_genres].[b_id]
	   JOIN [genres]
	   ON [m2m_books_genres].[g_id] = [genres].[g_id]
GROUP BY [b_name];

/*
	������������ ������: �������� ���� ������� � ���������� ���� (�� ����������� ����, � ����� ��� ����-���) �� ������� ������.
	������������ � ������: 15
*/
SELECT [a_name],
	   COUNT([int].[a_id]) AS [books_count]
FROM   [authors]
	   JOIN [m2m_books_authors] AS [int]
	   ON [authors].[a_id] = [int].[a_id]
GROUP BY [a_name]
ORDER BY [books_count];

/*
	������������ ������: �������� ��������, ��������� �������� � ���������� �����.
	������������ � ������: 23
*/
SELECT [sb_subscriber] AS [reader_id],
	   [s_name] AS [reader_name],
	   [sb_start] AS [taken_date]
FROM   [subscriptions]
	   JOIN [subscribers]
	     ON [subscriptions].[sb_subscriber] = [subscribers].[s_id]
WHERE  [sb_start] = (SELECT MAX([sb_start]) FROM [subscriptions]);