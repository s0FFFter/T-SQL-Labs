USE library;

/*
	������������ ������: �������� ��� ���������� �� �������
	������������ � ������: 1
*/
SELECT * FROM [authors];

/*
	������������ ������: �������� ��� ���������� � ������
	������������ � ������: 2
*/
SELECT * FROM [genres];

/*
	������������ ������: ��������, ������� ����� ��������� ���������������� � ����������
	������������ � ������: 5
*/
SELECT COUNT(*) FROM subscribers;

/*
	������������ ������: �������� �������������� ���� ������ �������� ���������, ������� � ��������-�� ������ ����� ����
	������������ � ������: 13
*/
SELECT [sb_subscriber]
FROM   [subscriptions]
GROUP BY [sb_subscriber]
HAVING COUNT(*) = (SELECT TOP 1 COUNT(*)
				   FROM [subscriptions]
				   GROUP BY [sb_subscriber]);

/*
	������������ ������: ��������, ������� � ������� ����������� ���� ���� � ����������
	������������ � ������: 15
*/
SELECT FORMAT(AVG(CAST([b_quantity] AS FLOAT)), 'N2')
FROM   [books];






