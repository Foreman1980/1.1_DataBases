USE shop;

INSERT INTO catalogs (name) VALUES
    ('������� �����'),
    ('����������� ������');

UPDATE catalogs
    SET name = '����������� �����'
    WHERE name = '���. �����';
    
SHOW DATABASES;
SHOW tables;

DROP TABLE IF EXISTS tbl;
CREATE TABLE tbl(
    x int,
    y int,
    summ int AS (x + y)
);

DESCRIBE tbl;

INSERT tbl (x, y) VALUES
    (1, 2),
    (2, 3),
    (6, 9);

SELECT * FROM tbl;

SELECT * FROM catalogs;
SELECT * FROM catalogs WHERE id > 2;
SELECT * FROM catalogs WHERE id IN (1, 2, 5);
SELECT * FROM catalogs WHERE id NOT IN (1, 2, 5);
SELECT * FROM catalogs WHERE name = '����������';
SELECT * FROM catalogs WHERE name LIKE '����������';
SELECT * FROM catalogs WHERE name LIKE '%�';
SELECT * FROM catalogs WHERE name NOT LIKE '%�';

SELECT * FROM users WHERE birthday_at >= '1990-01-01' AND birthday_at < '2000-01-01';
SELECT * FROM users WHERE birthday_at BETWEEN '1990-01-01' AND '2000-01-01';

INSERT INTO users (name, birthday_at) VALUES
    ('��������', '1990-10-05'),
    ('�������', '1984-11-12'),
    ('���������', '1985-05-20'),
    ('������', '1988-02-14'),
    ('����', '1998-01-12'),
    ('�����', '1992-08-29');
    
