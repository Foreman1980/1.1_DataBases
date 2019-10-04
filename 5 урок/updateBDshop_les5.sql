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





