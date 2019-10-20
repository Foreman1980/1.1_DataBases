/*--------------------------------Приктическое задание к уроку № 9--------------------------------*/

/*--------------------------Тема - Транзакции, переменные, представления--------------------------*/

/* 1. В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных. Переместите запись id = 1 из
 * таблицы shop.users в таблицу sample.users. Используйте транзакции.*/

-- создаём БД "sample" с такой же структурой как и БД "shop"
-- Вариант № 1:
truncate sample.users;

START TRANSACTION;

INSERT INTO sample.users
SELECT * FROM shop.users WHERE id = 1;

COMMIT;

-- ROLLBACK;

SELECT *
FROM sample.users;
-- проверенно, до выполнения "COMMIT" таблица "sample.users" - пуста

-- Вариант № 2:
truncate sample.users;

CREATE OR REPLACE VIEW `user_shop` AS
SELECT *
FROM shop.users
WHERE id = 1;

START TRANSACTION;

INSERT INTO sample.users
SELECT * FROM `user_shop`;
    
COMMIT;

-- ROLLBACK;

SELECT *
FROM sample.users;
-- проверенно, до выполнения "COMMIT" таблица "sample.users" - пуста

SHOW tables;
DROP VIEW IF EXISTS `user_shop`;

/* 2. Создайте представление, которое выводит название name товарной позиции из таблицы products и соответствующее
 * название каталога name из таблицы catalogs.*/

CREATE OR REPLACE VIEW prod AS
SELECT
    name,
    (   SELECT name
        FROM catalogs
        WHERE id = catalog_id) AS 'catalog'
FROM products;

SELECT * FROM prod;

SHOW tables;
DROP VIEW IF EXISTS prod;

/* 3. Пусть имеется таблица с календарным полем created_at. В ней размещены разряженые календарные записи за август
 * 2018 года '2018-08-01', '2016-08-04', '2018-08-16' и '2018-08-17'. Составьте запрос, который выводит полный список
 * дат за август, выставляя в соседнем поле значение 1, если дата присутствует в исходном таблице и 0, если она
 * отсутствует.*/


DROP TABLE IF EXISTS dates;
CREATE TABLE dates(
    created_at date
);

INSERT INTO dates
VALUES
    ('2018-08-01'),
    ('2016-08-04'),
    ('2018-08-16'),
    ('2018-08-17');

SELECT * FROM dates;

DROP TABLE IF EXISTS august_2018;
CREATE TABLE august_2018(
    created_at date
);

INSERT INTO august_2018
VALUES
    ('2018-08-01'),
    ('2018-08-02'),
    ('2018-08-03'),
    ('2018-08-04'),
    ('2018-08-05'),
    ('2018-08-06'),
    ('2018-08-07'),
    ('2018-08-08'),
    ('2018-08-09'),
    ('2018-08-10'),
    ('2018-08-11'),
    ('2018-08-12'),
    ('2018-08-13'),
    ('2018-08-14'),
    ('2018-08-15'),
    ('2018-08-16'),
    ('2018-08-17'),
    ('2018-08-18'),
    ('2018-08-19'),
    ('2018-08-20'),
    ('2018-08-21'),
    ('2018-08-22'),
    ('2018-08-23'),
    ('2018-08-24'),
    ('2018-08-25'),
    ('2018-08-26'),
    ('2018-08-27'),
    ('2018-08-28'),
    ('2018-08-29'),
    ('2018-08-30'),
    ('2018-08-31');

SELECT
    created_at AS 'date',
    (IF (august_2018.created_at IN ( SELECT dates.created_at
                        FROM dates), '1', '0')) AS 'check'
FROM august_2018;

/* 4. Пусть имеется любая таблица с календарным полем created_at. Создайте запрос, который удаляет устаревшие записи из
 * таблицы, оставляя только 5 самых свежих записей.*/
-- Шаг № 1
CREATE OR REPLACE VIEW new_record (date) AS
SELECT *
FROM august_2018
ORDER BY created_at DESC
LIMIT 5;

SELECT * FROM new_record;

-- Шаг № 2
DELETE FROM august_2018
WHERE created_at NOT IN (   SELECT date
                            FROM new_record);

SELECT * FROM august_2018;

DROP VIEW IF EXISTS new_record;
SHOW TABLES;