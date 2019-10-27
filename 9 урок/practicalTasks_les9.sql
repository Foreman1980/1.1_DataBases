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
    dates date
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
    dates AS 'date',
    (IF (august_2018.dates IN ( SELECT dates.created_at
                        FROM dates), '1', '0')) AS 'check'
FROM august_2018;

-- Решение с пом. временной таблицы "august_2018" и уже изученных процедур
DROP PROCEDURE IF EXISTS check_august;

DELIMITER //
CREATE PROCEDURE check_august()
BEGIN
    DECLARE dd date;
    DROP TABLE IF EXISTS august_2018;
    CREATE TEMPORARY TABLE august_2018 (dates date);
    SET dd = date('2018-08-01');
    REPEAT
        INSERT INTO august_2018 VALUES (dd);    
        SET dd = dd + INTERVAL 1 DAY;
    until dd >= date('2018-08-31')
    END REPEAT;
    SELECT
        dates AS 'date',
        (IF (august_2018.dates IN ( SELECT dates.created_at
                                    FROM dates), '1', '0')) AS 'check'
    FROM august_2018;
END//
DELIMITER ;

CALL check_august();

SELECT * FROM august_2018;

DROP TABLE IF EXISTS dates;
DROP PROCEDURE IF EXISTS check_august;

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

/*-------------------------Тема - Хранимые процедуры и функции, триггеры-------------------------*/

/* 1. Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток.
 * С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", с 12:00 до 18:00 функция должна возвращать фразу
 * "Добрый день", с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".*/

DROP PROCEDURE IF EXISTS hello;

DELIMITER //
CREATE PROCEDURE hello()
BEGIN
    IF (time_to_sec(curtime()) BETWEEN 6 * 60 * 60 AND 12 * 60 * 60 - 1) THEN
        SELECT 'Доброе утро!';
    ELSEIF (time_to_sec(curtime()) BETWEEN 12 * 60 * 60 AND 18 * 60 * 60 - 1) THEN
        SELECT 'Добрый день!';
    ELSEIF (time_to_sec(curtime()) BETWEEN 18 * 60 * 60 AND 24 * 60 * 60 - 1) THEN
        SELECT 'Добрый вечер!';
    ELSEIF (time_to_sec(curtime()) BETWEEN 0 AND 6 * 60 * 60 - 1) THEN
        SELECT 'Доброй ночи!';
    END IF;
END//
DELIMITER ;

CALL hello();

DROP PROCEDURE IF EXISTS hello;

/* 2. В таблице products есть два текстовых поля: name с названием товара и description с его описанием. Допустимо
 * присутствие обоих полей или одно из них. Ситуация, когда оба поля принимают неопределенное значение NULL
 * неприемлема. Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены. При
 * попытке присвоить полям NULL-значение необходимо отменить операцию.*/

DROP TRIGGER IF EXISTS not_null_prod_ins;

DELIMITER //
CREATE TRIGGER not_null_prod_ins BEFORE INSERT ON products
FOR EACH ROW
BEGIN
    IF (NEW.name IS NULL AND new.description IS NULL) THEN
        SIGNAL SQLSTATE '45000' SET message_text = 'INSERT canceled!';
    END IF;
END//

DELIMITER ;

-- тест
INSERT INTO products(name, description, price, catalog_id) VALUES
    (NULL, NULL, 1000.00, 1);
-- получили ошибку - "SQL Error [1644] [45000]: INSERT canceled!"

SELECT * FROM products;
-- запись не вставлена...

DROP TRIGGER IF EXISTS not_null_prod_ins;

DROP TRIGGER IF EXISTS not_null_prod_upd;

DELIMITER //
CREATE TRIGGER not_null_prod_upd BEFORE UPDATE ON products
FOR EACH ROW
BEGIN
    IF (COALESCE(NEW.name, NEW.description) IS NULL OR COALESCE(NEW.name, OLD.description) IS NULL
    OR COALESCE(OLD.name, NEW.description) IS NULL) THEN
        SIGNAL SQLSTATE '45000' SET message_text = 'UPDATE canceled!';
    END IF;
END//

DELIMITER ;

-- тест - случай № 1:
UPDATE products
SET 
    name = NULL,
    description = NULL
WHERE id = 1;
-- получили ошибку - "SQL Error [1644] [45000]: UPDATE canceled!"

SELECT * FROM products;
-- запись не вставлена...

-- тест - случай № 2 (когда одно из старых значений уже было "NULL"):
-- установим значение "NULL" для поля "description" записи с id = 1
UPDATE products
SET 
    description = NULL
WHERE id = 1;

SELECT * FROM products;
-- поле "description" записи с id = 1 получило значение "NULL"
-- пробуем для этой же записи установить значение "NULL" в поле "NAME"
UPDATE products
SET 
    name = NULL
WHERE id = 1;
-- получили ошибку - "SQL Error [1644] [45000]: UPDATE canceled!"

SELECT * FROM products;
-- запись не вставлена...

DROP TRIGGER IF EXISTS not_null_prod_upd;

/* 3. Напишите хранимую функцию для вычисления произвольного числа Фибоначчи. Числами Фибоначчи называется
 * последовательность в которой число равно сумме двух предыдущих чисел. Вызов функции FIBONACCI(10) должен возвращать
 * число 55.*/

DROP FUNCTION IF EXISTS fibonacci;

DELIMITER //
CREATE FUNCTION fibonacci(num int)
RETURNS int DETERMINISTIC
BEGIN
    DECLARE counter, spam, previous_num, fib int;
    IF (num = 1) THEN
        SET fib = 1;
    ELSEIF (num > 1) THEN
        SET counter = 1;
        SET previous_num = 1;
        SET spam = 0;
        SET fib = 0;
        REPEAT
            SET fib = previous_num + spam;
            SET spam = previous_num;
            SET previous_num = fib;
            SET counter = counter + 1;
        until counter >= num
        END REPEAT;
    END IF;
    RETURN fib;
END//
DELIMITER ;

-- Проверка работы функции:
SELECT fibonacci(1); -- Вывод - 1
SELECT fibonacci(2); -- Вывод - 1
SELECT fibonacci(5); -- Вывод - 5
SELECT fibonacci(10); -- Вывод - 55

DROP FUNCTION IF EXISTS fibonacci;
