USE shop;

DROP TABLE IF EXISTS cat;

INSERT INTO catalogs (name) VALUES
    ('Жесткие диски'),
    ('Оперативная память');

UPDATE catalogs
    SET name = 'Материнские платы'
    WHERE name = 'Мат. платы';
    
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
SELECT * FROM catalogs WHERE name = 'Процессоры';
SELECT * FROM catalogs WHERE name LIKE 'Процессоры';
SELECT * FROM catalogs WHERE name LIKE '%ы';
SELECT * FROM catalogs WHERE name NOT LIKE '%ы';

INSERT INTO users (name, birthday_at) VALUES
    ('Геннадий', '1990-10-05'),
    ('Наталья', '1984-11-12'),
    ('Александр', '1985-05-20'),
    ('Сергей', '1988-02-14'),
    ('Иван', '1998-01-12'),
    ('Мария', '1992-08-29');
    
SELECT * FROM users WHERE birthday_at >= '1990-01-01' AND birthday_at < '2000-01-01';
SELECT * FROM users WHERE birthday_at BETWEEN '1990-01-01' AND '2000-01-01';
SELECT * FROM users WHERE birthday_at LIKE '199%';

SELECT * FROM catalogs ORDER BY name;
SELECT * FROM catalogs ORDER BY name DESC;

truncate products;
INSERT INTO products(name, description, price, catalog_id) VALUES
    ('Intel Core i3-8100', 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.', 7890.00, 1),
    ('Intel Core i5-7400', 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.', 12700.00, 1),
    ('AMD FX-8320E', 'Процессор для настольных персональных компьютеров, основанных на платформе AMD.', 4780.00, 1),
    ('AMD FX-8320', 'Процессор для настольных персональных компьютеров, основанных на платформе AMD.', 7120.00, 1),
    ('ASUS ROG MAXIMUS X HERO', 'Материнская плата ASUS ROG MAXIMUS X HERO, Z370, Socket 1151-V2, DDR4, ATX', 19310.00, 2),
    ('Gigabyte H310M S2H', 'Материнская плата Gigabyte H310M S2H, H310, Socket 1151-V2, DDR4, mATX', 4790.00, 2),
    ('MSI B250M GAMING PRO', 'Материнская плата MSI B250M GAMING PRO, B250, Socket 1151, DDR4, mATX', 5060.00, 2);

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
SELECT ALL catalog_id FROM products ORDER BY catalog_id; -- ключевое слово "ALL" опускается, т.к. данный запрос равносилен запросу по-умолчанию

/*Задание - уменьшить на 10% цену материнских плат, цена которых превышает 5000р.*/

SELECT id, catalog_id, price, name FROM products WHERE catalog_id = 2 AND price > 5000;
UPDATE products
    SET price = price * 0.9
    WHERE catalog_id = 2 AND price > 5000;
SELECT id, catalog_id, price, name FROM products;

/*Задание - Удалить две самые дорогие позиции в таблице "products"*/

SELECT id, catalog_id, price, name FROM products ORDER BY price DESC LIMIT 2;
DELETE FROM products ORDER BY price DESC LIMIT 2;
SELECT id, catalog_id, price, name FROM products;





