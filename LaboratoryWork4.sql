USE [library];

/*
	Формулировка задачи: Добавить в базу данных информацию о троих новых читателях: «Орлов О.О.», «Соколов С.С.», «Беркутов Б.Б»
	Расположение в списке: 1
*/
INSERT INTO [subscribers]
			([s_name])
VALUES      ('Орлов О.О.'),
			('Соколов С.С.'),
			('Беркутов Б.Б.');

/*
	Формулировка задачи: Отразить в базе данных информацию о том, что каждый из троих добавленных чита-телей 20-го января 2016-го года на месяц взял в библиотеке книгу «Курс теоретиче-ской физики».
	Расположение в списке: 2
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
	Формулировка задачи: Добавить в базу данных пять любых авторов и десять книг этих авторов (по две на каждого); если понадобится, добавить в базу данных соответствующие жанры. От-разить авторство добавленных книг и их принадлежность к соответствующим жан-рам.
	Расположение в списке: 3
*/

-- Добавление новых жанров

INSERT INTO [genres]
			([g_name])
VALUES		(N'Комедия'),
			(N'Пикареска'),
			(N'Роман'),
			(N'Повесть');

-- Добавление новых авторов

INSERT INTO [authors]
			([a_name])
VALUES      (N'Н.В. Гоголь'),
			(N'Э. Таненбаум'),
			(N'Б. Керниган'),
			(N'Д. Ритчи'),
			(N'М.А. Булгаков');

-- Добавление новых книг

INSERT INTO [books]
			([b_name],
			 [b_year],
			 [b_quantity])
VALUES		(N'Ревизор', 1952, 7),
			(N'Мертвые души', 1984, 5),
			(N'Архитектура компьютера', 2000, 3),
			(N'Компьютерные сети', 2002, 4),
			(N'Язык программирования Си', 2001, 6),
			(N'Элементы стиля программирования', 2001, 6),
			(N'UNIX для программистов и пользователей', 2002, 4),
			(N'Мастер и Маргарита', 1999, 5),
			(N'Собачье сердце', 1993, 3);

-- Добавление данных о принадлежности книги к определенному(ым) автору(ам)

INSERT INTO [m2m_books_authors]
			([b_id], [a_id])
VALUES		(
			  (SELECT [b_id] FROM [books] WHERE [b_name] = 'Ревизор'),
			  (SELECT [a_id] FROM [authors] WHERE [a_name] = 'Н.В. Гоголь')
			),
			(
			  (SELECT [b_id] FROM [books] WHERE [b_name] = 'Мертвые души'),
			  (SELECT [a_id] FROM [authors] WHERE [a_name] = 'Н.В. Гоголь')
			),
			(
			  (SELECT [b_id] FROM [books] WHERE [b_name] = 'Архитектура компьютера'),
			  (SELECT [a_id] FROM [authors] WHERE [a_name] = 'Э. Таненбаум')
			),
			(
			  (SELECT [b_id] FROM [books] WHERE [b_name] = 'Компьютерные сети'),
			  (SELECT [a_id] FROM [authors] WHERE [a_name] = 'Э. Таненбаум')
			),
			(
			  (SELECT [b_id] FROM [books] WHERE [b_name] = 'Язык программирования Си'),
			  (SELECT [a_id] FROM [authors] WHERE [a_name] = 'Б. Керниган')
			),
			(
			  (SELECT [b_id] FROM [books] WHERE [b_name] = 'Элементы стиля программирования'),
			  (SELECT [a_id] FROM [authors] WHERE [a_name] = 'Б. Керниган')
			),
			(
			  (SELECT [b_id] FROM [books] WHERE [b_name] = 'Язык программирования Си'),
			  (SELECT [a_id] FROm [authors] WHERE [a_name] = 'Д. Ритчи')
			),
			(
			  (SELECT [b_id] FROM [books] WHERE [b_name] = 'UNIX для программистов и пользователей'),
			  (SELECT [a_id] FROM [authors] WHERE [a_name] = 'Д. Ритчи')
			),
			(
			  (SELECT [b_id] FROM [books] WHERE [b_name] = 'Мастер и Маргарита'),
			  (SELECT [a_id] FROM [authors] WHERE [a_name] = 'М.А. Булгаков')
			),
			(
			  (SELECT [b_id] FROM [books] WHERE [b_name] = 'Собачье сердце'),
			  (SELECT [a_id] FROM [authors] WHERE [a_name] = 'М.А. Булгаков')
			);

-- Добавление данных о принадлежности книги к определенному(ым) жанру(ам)

INSERT INTO [m2m_books_genres]
			([b_id], [g_id])
VALUES		(
			   (SELECT [b_id] FROM [books] WHERE [b_name] = 'Ревизор'),
			   (SELECT [g_id] FROM [genres] WHERE [g_name] = 'Комедия')
			),
			(
			   (SELECT [b_id] FROM [books] WHERE [b_name] = 'Мертвые души'),
			   (SELECT [g_id] FROM [genres] WHERE [g_name] = 'Пикареска')
			),
			(
			   (SELECT [b_id] FROM [books] WHERE [b_name] = 'Архитектура компьютера'),
			   (SELECT [g_id] FROM [genres] WHERE [g_name] = 'Программирование')
			),
			(
			   (SELECT [b_id] FROM [books] WHERE [b_name] = 'Компьютерные сети'),
			   (SELECT [g_id] FROM [genres] WHERE [g_name] = 'Программирование')
			),
			(
			   (SELECT [b_id] FROM [books] WHERE [b_name] = 'Язык программирования Си'),
			   (SELECT [g_id] FROM [genres] WHERE [g_name] = 'Программирование')
			),
			(
			   (SELECT [b_id] FROM [books] WHERE [b_name] = 'Элементы стиля программирования'),
			   (SELECT [g_id] FROM [genres] WHERE [g_name] = 'Программирование')
			),
			(
			   (SELECT [b_id] FROM [books] WHERE [b_name] = 'UNIX для программистов и пользователей'),
			   (SELECT [g_id] FROM [genres] WHERE [g_name] = 'Программирование')
			),
			(
			   (SELECT [b_id] FROM [books] WHERE [b_name] = 'Мастер и Маргарита'),
			   (SELECT [g_id] FROM [genres] WHERE [g_name] = 'Роман')
			),
			(
			   (SELECT [b_id] FROM [books] WHERE [b_name] = 'Собачье сердце'),
			   (SELECT [g_id] FROM [genres] WHERE [g_name] = 'Повесть')
			);

-- Демонстрация авторства и принадлежности книги к определенному жанру

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
	Формулировка задачи: Отметить как невозвращённые все выдачи, полученные читателем с идентификато-ром 2.
	Расположение в списке: 6
*/

-- Добавление читателя с идентификатором 2 для демонстрации работы

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

-- Отметка всех выдач как невозвращенные

UPDATE [subscriptions]
SET [sb_is_active] = 'Y'
WHERE [sb_subscriber] = 2;


/*
	Формулировка задачи: Добавить в базу данных жанры «Политика», «Психология», «История».
	Расположение в списке: 10
*/
MERGE INTO [genres]
USING (VALUES (N'Политика'),
			  (N'Психология'),
			  (N'История')) AS [new_genres] ([g_name])
ON [genres].[g_name] = [new_genres].[g_name]
WHEN NOT MATCHED BY TARGET THEN
	INSERT ([g_name])
	VALUES ([new_genres].[g_name]);
