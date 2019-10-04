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

truncate users;
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

SELECT date('2018-10-10 15:20:00');
SELECT now();

INSERT INTO users VALUES (NULL, 'Александр', '1986-01-20', now(), now());
SELECT * FROM users;
SELECT name, created_at, updated_at FROM users WHERE name = 'Александр';
SELECT name, date(created_at), date(updated_at) FROM users WHERE name = 'Александр';
SELECT name, date(created_at) AS created_at, date(updated_at) AS updated_at FROM users WHERE name = 'Александр';
/*Допускается не указывать ключевое слово "AS" заменяя его пробелом.*/
SELECT name, date(created_at) created_at, date(updated_at) updated_at FROM users WHERE name = 'Александр';

SELECT date_format('2018-06-12 01:59:59', 'На дворе %Y год.'); -- последовательность %Y отвечает за извлечение года из календарного значения
SELECT date_format(now(), 'На дворе %Y год.');

SELECT name, date_format(birthday_at, '%d.%m.%Y') birthday FROM users;

/*Преобразование даты и времени в "UNIXSTAMP"-формат (это количество секунд, которое прошло с полуночи 01.01.1970. Ограничение до 31.12.2037 23:59:59).
 * DATETIME - 8 bytes
 * UNIXSTAMP - 4 bytes
 * UNIX_TIMESTAMP(DATETIME) = UNIXSTAMP
 * FROM_UNIXTIME(UNIXSTAMP) = DATETIME*/
SELECT unix_timestamp(now()) TIMESTAMP, from_unixtime(1570205067) DATETIME;

/*Задание - По полю "birthday_at" вычислить текущий возраст пользователя из таблицы "users"*/

SELECT * FROM users;
SELECT name, (to_days(now()) - to_days(birthday_at)) / 365.25 AS age FROM users;
SELECT name, floor((to_days(now()) - to_days(birthday_at)) / 365.25) AS age FROM users;
SELECT name, timestampdiff(YEAR, birthday_at, now()) AS age FROM users;

SELECT * FROM users ORDER BY rand(); -- вывод полей таблицы в случайном порядке
SELECT * FROM users ORDER BY rand() LIMIT 1; -- вывод одной случайной записи

/*Информационные функции:
 * SELECT VERSION() - возвращает текущую версию MySQL сервера
 * SELECT LAST_INSERT_ID() - возвращает текущее значение счётчика в столбце "AUTO_INCREMENT"...не совсем понятно...
 * SELECT DATABASE() - возврвщает текущую БД, если БД не выбрана, функция возвращает NULL
 * SELECT USER() - возвращает текущего пользователя - root@localhost*/
SELECT VERSION();
SELECT LAST_INSERT_ID();
SELECT DATABASE();
SELECT USER();





