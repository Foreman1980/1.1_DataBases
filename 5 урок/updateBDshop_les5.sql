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

-- -------------------------МОДУЛЬ № 5-------------------------

SELECT id, name
FROM users;

-- функция вырезания подстроки из строки
-- агументы - строка, начальный символ, конечный символ
-- нумерация символов в строках начинается с единицы
SELECT id, substring(name, 1, 5) AS name
FROM users;

-- функция объединенния строк
SELECT id, concat(name, ' ', timestampdiff(YEAR, birthday_at, now())) AS name
FROM users;
-- о, у Геннадия сегодня ДР! (05.10.2019)

-- Вывод слов "совершеннолетний" или "несовершеннолетний" в зависимости от того достиг пользователь 18 лет или нет

-- Логические функции помогают преобразовать результат в зависимости от выполнения того или иного условия
-- аргументы - лог. выражение, результаты при истинном лог. выражении и при ложном
SELECT IF(TRUE, 'истина', 'ложь'), IF(FALSE, 'истина', 'ложь');

-- Изменим дату рождений пользователя Марии для выполнения следующего задания

UPDATE users
SET birthday_at = '2006-08-29'
WHERE id = 6;

SELECT *
FROM users;

SELECT
    name,
    IF(
        timestampdiff(YEAR, birthday_at, now()) >= 18,
        'совершеннолетний',
        'несовершеннолетний'
    ) AS status
FROM
    users;

/*--------------------------ТЕМА - Агрегация----------------------------*/
/*-------------------МОДУЛЬ № 1 - Группировка данных.-------------------*/

SELECT catalog_id
FROM products;

SELECT DISTINCT catalog_id
FROM products;

SELECT
    id,
    name,
    id % 3
FROM
    products
ORDER BY id % 3;

-- группировка содержимого таблицы по полю "catalog_id"
SELECT catalog_id
FROM products
GROUP BY catalog_id;

-- для группировки могут использоваться также вычисляемые значения
SELECT
    id,
    name,
    birthday_at
FROM users;

SELECT
    id,
    name,
    substring(birthday_at, 1, 3) AS decade
FROM users;

SELECT
    id,
    name,
    substring(birthday_at, 1, 3) AS decade
FROM users
ORDER BY decade;

SELECT
    count(*),
    substring(birthday_at, 1, 3) AS decade
FROM users
GROUP BY decade
ORDER BY decade DESC;

SELECT
    count(*),
    substring(birthday_at, 1, 3) AS decade
FROM users
GROUP BY decade
ORDER BY count(*);

SELECT
    count(*) AS total,
    substring(birthday_at, 1, 3) AS decade
FROM users
GROUP BY decade
ORDER BY total
LIMIT 2;

-- вывод количества записей в таблице
SELECT
    count(*)
FROM users;

-- вывод содержимого группы
SELECT
    group_concat(name),
    substring(birthday_at, 1, 3) AS decade
FROM users
GROUP BY decade;

-- вывод с сепаратором
SELECT
    group_concat(name SEPARATOR ', '),
    substring(birthday_at, 1, 3) AS decade
FROM users
GROUP BY decade;

-- вывод с сортировкой
SELECT
    group_concat(name ORDER BY name DESC SEPARATOR ', '),
    substring(birthday_at, 1, 3) AS decade
FROM users
GROUP BY decade;
-- функция "GROUP_CONCAT" имеет ограничение, она может извлекать из группы максимум 1000 элементов
-- но это можно изменить с помощью параметра сервера "GROUP_CONCAT_MAX_LEN" (на слух)

/*------------------МОДУЛЬ № 2 - Агрегационные функции.------------------*/











