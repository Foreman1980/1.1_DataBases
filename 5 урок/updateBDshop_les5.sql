USE shop;

DROP TABLE IF EXISTS cat;

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

truncate users;
INSERT INTO users (name, birthday_at) VALUES
    ('��������', '1990-10-05'),
    ('�������', '1984-11-12'),
    ('���������', '1985-05-20'),
    ('������', '1988-02-14'),
    ('����', '1998-01-12'),
    ('�����', '1992-08-29');
    
SELECT * FROM users WHERE birthday_at >= '1990-01-01' AND birthday_at < '2000-01-01';
SELECT * FROM users WHERE birthday_at BETWEEN '1990-01-01' AND '2000-01-01';
SELECT * FROM users WHERE birthday_at LIKE '199%';

SELECT * FROM catalogs ORDER BY name;
SELECT * FROM catalogs ORDER BY name DESC;

truncate products;
INSERT INTO products(name, description, price, catalog_id) VALUES
    ('Intel Core i3-8100', '��������� ��� ���������� ������������ �����������, ���������� �� ��������� Intel.', 7890.00, 1),
    ('Intel Core i5-7400', '��������� ��� ���������� ������������ �����������, ���������� �� ��������� Intel.', 12700.00, 1),
    ('AMD FX-8320E', '��������� ��� ���������� ������������ �����������, ���������� �� ��������� AMD.', 4780.00, 1),
    ('AMD FX-8320', '��������� ��� ���������� ������������ �����������, ���������� �� ��������� AMD.', 7120.00, 1),
    ('ASUS ROG MAXIMUS X HERO', '����������� ����� ASUS ROG MAXIMUS X HERO, Z370, Socket 1151-V2, DDR4, ATX', 19310.00, 2),
    ('Gigabyte H310M S2H', '����������� ����� Gigabyte H310M S2H, H310, Socket 1151-V2, DDR4, mATX', 4790.00, 2),
    ('MSI B250M GAMING PRO', '����������� ����� MSI B250M GAMING PRO, B250, Socket 1151, DDR4, mATX', 5060.00, 2);

SELECT * FROM products;
SELECT id, catalog_id, price, name FROM products;
SELECT id, catalog_id, price, name FROM products ORDER BY catalog_id, price;
SELECT id, catalog_id, price, name FROM products ORDER BY catalog_id, price DESC;
SELECT id, catalog_id, price, name FROM products ORDER BY catalog_id DESC, price DESC;
SELECT id, catalog_id, price, name FROM products LIMIT 2;
SELECT id, catalog_id, price, name FROM products LIMIT 2, 2;
SELECT id, catalog_id, price, name FROM products LIMIT 4, 2;
SELECT id, catalog_id, price, name FROM products LIMIT 2 offset 4;

SELECT catalog_id FROM products ORDER BY catalog_id;
SELECT DISTINCT catalog_id FROM products ORDER BY catalog_id;
SELECT ALL catalog_id FROM products ORDER BY catalog_id; -- �������� ����� "ALL" ����������, �.�. ������ ������ ���������� ������� ��-���������

/*������� - ��������� �� 10% ���� ����������� ����, ���� ������� ��������� 5000�.*/

SELECT id, catalog_id, price, name FROM products WHERE catalog_id = 2 AND price > 5000;
UPDATE products
    SET price = price * 0.9
    WHERE catalog_id = 2 AND price > 5000;
SELECT id, catalog_id, price, name FROM products;

/*������� - ������� ��� ����� ������� ������� � ������� "products"*/

SELECT id, catalog_id, price, name FROM products ORDER BY price DESC LIMIT 2;
DELETE FROM products ORDER BY price DESC LIMIT 2;
SELECT id, catalog_id, price, name FROM products;

SELECT date('2018-10-10 15:20:00');
SELECT now();

INSERT INTO users VALUES (NULL, '���������', '1986-01-20', now(), now());
SELECT * FROM users;
SELECT name, created_at, updated_at FROM users WHERE name = '���������';
SELECT name, date(created_at), date(updated_at) FROM users WHERE name = '���������';
SELECT name, date(created_at) AS created_at, date(updated_at) AS updated_at FROM users WHERE name = '���������';
/*����������� �� ��������� �������� ����� "AS" ������� ��� ��������.*/
SELECT name, date(created_at) created_at, date(updated_at) updated_at FROM users WHERE name = '���������';

SELECT date_format('2018-06-12 01:59:59', '�� ����� %Y ���.'); -- ������������������ %Y �������� �� ���������� ���� �� ������������ ��������
SELECT date_format(now(), '�� ����� %Y ���.');

SELECT name, date_format(birthday_at, '%d.%m.%Y') birthday FROM users;

/*�������������� ���� � ������� � "UNIXSTAMP"-������ (��� ���������� ������, ������� ������ � �������� 01.01.1970. ����������� �� 31.12.2037 23:59:59).
 * DATETIME - 8 bytes
 * UNIXSTAMP - 4 bytes
 * UNIX_TIMESTAMP(DATETIME) = UNIXSTAMP
 * FROM_UNIXTIME(UNIXSTAMP) = DATETIME*/
SELECT unix_timestamp(now()) TIMESTAMP, from_unixtime(1570205067) DATETIME;

/*������� - �� ���� "birthday_at" ��������� ������� ������� ������������ �� ������� "users"*/

SELECT * FROM users;
SELECT name, (to_days(now()) - to_days(birthday_at)) / 365.25 AS age FROM users;
SELECT name, floor((to_days(now()) - to_days(birthday_at)) / 365.25) AS age FROM users;
SELECT name, timestampdiff(YEAR, birthday_at, now()) AS age FROM users;

SELECT * FROM users ORDER BY rand(); -- ����� ����� ������� � ��������� �������
SELECT * FROM users ORDER BY rand() LIMIT 1; -- ����� ����� ��������� ������

/*�������������� �������:
 * SELECT VERSION() - ���������� ������� ������ MySQL �������
 * SELECT LAST_INSERT_ID() - ���������� ������� �������� �������� � ������� "AUTO_INCREMENT"...�� ������ �������...
 * SELECT DATABASE() - ���������� ������� ��, ���� �� �� �������, ������� ���������� NULL
 * SELECT USER() - ���������� �������� ������������ - root@localhost*/
SELECT VERSION();
SELECT LAST_INSERT_ID();
SELECT DATABASE();
SELECT USER();







