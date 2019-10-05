-- Доработка БД "shop" и отработка запросов по материалам урока № 5

USE shop;

DROP TABLE IF EXISTS cat;

INSERT INTO catalogs (name) VALUES
    ('Жесткие диски'),
    ('Оперативная память');

UPDATE catalogs
    SET name = 'Материнские платы'
    WHERE name = 'Мат. платы';
    
SELECT * FROM catalogs;
SELECT * FROM catalogs WHERE id > 2;
SELECT * FROM catalogs WHERE id IN (1, 2, 5);
SELECT * FROM catalogs WHERE id NOT IN (1, 2, 5);
SELECT * FROM catalogs WHERE name = 'Процессоры';
SELECT * FROM catalogs WHERE name LIKE 'Процессоры';
SELECT * FROM catalogs WHERE name LIKE '%ы';
SELECT * FROM catalogs WHERE name NOT LIKE '%ы';

SELECT * FROM users WHERE birthday_at >= '1990-01-01' AND birthday_at < '2000-01-01';
SELECT * FROM users WHERE birthday_at BETWEEN '1990-01-01' AND '2000-01-01';
SELECT * FROM users WHERE birthday_at LIKE '199%';

SELECT * FROM catalogs ORDER BY name;
SELECT * FROM catalogs ORDER BY name DESC;

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

INSERT INTO users VALUES (NULL, 'Александр', '1986-01-20', now(), now());
SELECT * FROM users;
SELECT name, created_at, updated_at FROM users WHERE name = 'Александр';
SELECT name, date(created_at), date(updated_at) FROM users WHERE name = 'Александр';
SELECT name, date(created_at) AS created_at, date(updated_at) AS updated_at FROM users WHERE name = 'Александр';
SELECT name, date(created_at) created_at, date(updated_at) updated_at FROM users WHERE name = 'Александр'; -- допускается не указывать ключевое слово "AS" заменяя его пробелом.

SELECT name, date_format(birthday_at, '%d.%m.%Y') birthday FROM users;

/*Задание - По полю "birthday_at" вычислить текущий возраст пользователя из таблицы "users"*/

SELECT * FROM users;
SELECT name, (to_days(now()) - to_days(birthday_at)) / 365.25 AS age FROM users;
SELECT name, floor((to_days(now()) - to_days(birthday_at)) / 365.25) AS age FROM users;
SELECT name, timestampdiff(YEAR, birthday_at, now()) AS age FROM users;

SELECT * FROM users ORDER BY rand(); -- вывод полей таблицы в случайном порядке
SELECT * FROM users ORDER BY rand() LIMIT 1; -- вывод одной случайной записи

-- -----------------------МОДУЛЬ № 5-----------------------





