/*-------------------Приктическое задание к уроку № 5-------------------*/

USE shop;

/*1. Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их
текущими датой и временем.*/

SELECT * FROM users;
UPDATE users
SET
    created_at = now(),
    updated_at = now();

/*2. Таблица users была неудачно спроектирована. Записи created_at и updated_at были заданы
типом VARCHAR и в них долгое время помещались значения в формате "20.10.2017 8:10".
Необходимо преобразовать поля к типу DATETIME, сохранив введеные ранее значения.*/

SELECT STR_TO_DATE('20.10.2017 8:10', '%d.%m.%Y %h:%i');

/*3. В таблице складских запасов storehouses_products в поле value могут встречаться самые
разные цифры: 0, если товар закончился и выше нуля, если на складе имеются запасы.
Необходимо отсортировать записи таким образом, чтобы они выводились в порядке
увеличения значения value. Однако, нулевые запасы должны выводиться в конце, после всех
записей.*/

INSERT INTO storehouses(name)
VALUES ('main');

SELECT * FROM storehouses;
SELECT * FROM products;

truncate storehouses_products;
INSERT INTO storehouses_products(storehouse_id, product_id, value)
VALUES
    (1, 1, 100),
    (1, 2, 200),
    (1, 3, 0),
    (1, 4, 300),
    (1, 5, 0),
    (1, 6, 200),
    (1, 7, 150);

SELECT
    product_id,
    value,
    if(value > 0, 1, 0) AS availability
FROM storehouses_products
ORDER BY availability DESC, value;

/*4. (по желанию) Из таблицы users необходимо извлечь пользователей, родившихся в августе и
мае. Месяцы заданы в виде списка английских названий ('may', 'august')*/

SELECT
    group_concat(name SEPARATOR ', '),
    monthname(birthday_at) AS birthday_month
FROM users
GROUP BY birthday_month
HAVING birthday_month = 'May' OR birthday_month = 'August' OR birthday_month = 'February';

/*5. (по желанию) Из таблицы catalogs извлекаются записи при помощи запроса. SELECT * FROM
catalogs WHERE id IN (5, 1, 2); Отсортируйте записи в порядке, заданном в списке IN.*/

SELECT *
FROM catalogs
WHERE id IN (5, 1, 2)
ORDER BY field(id, 5, 1, 2);
