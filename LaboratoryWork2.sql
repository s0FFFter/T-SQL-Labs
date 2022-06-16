USE library;

/*
	Формулировка задачи: Показать всю информацию об авторах
	Расположение в списке: 1
*/
SELECT * FROM [authors];

/*
	Формулировка задачи: Показать всю информацию о жанрах
	Расположение в списке: 2
*/
SELECT * FROM [genres];

/*
	Формулировка задачи: Показать, сколько всего читателей зарегистрировано в библиотеке
	Расположение в списке: 5
*/
SELECT COUNT(*) FROM subscribers;

/*
	Формулировка задачи: Показать идентификаторы всех «самых читающих читателей», взявших в библиоте-ке больше всего книг
	Расположение в списке: 13
*/
SELECT [sb_subscriber]
FROM   [subscriptions]
GROUP BY [sb_subscriber]
HAVING COUNT(*) = (SELECT TOP 1 COUNT(*)
				   FROM [subscriptions]
				   GROUP BY [sb_subscriber]);

/*
	Формулировка задачи: Показать, сколько в среднем экземпляров книг есть в библиотеке
	Расположение в списке: 15
*/
SELECT FORMAT(AVG(CAST([b_quantity] AS FLOAT)), 'N2')
FROM   [books];






