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

/*--------------------------Тема - Агрегация----------------------------*/
/*-------------------Модуль № 1 - Группировка данных.-------------------*/

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

/*-----------------Модуль № 2 - Агрегационные функции.------------------*/
-- Содержание:
-- Особенности функции COUNT()
-- Поиск минимального и максимального значаний
-- Среднее значение
-- Подсчёт суммы столбца

-- агрегационная функция COUNT() возвращает количество строк таблицы, значение столбца для кот. отлично от NULL 
SELECT count(id)
FROM catalogs;

-- при использовании символа "*" будет возвращено количество строк таблицы вне зависимости от того принимают какие-то из полей значения NULL или нет 
SELECT count(*)
FROM catalogs;

SELECT catalog_id
FROM products;

-- используя GROUP BY мы разбиваем таблицу на две группы
SELECT catalog_id
FROM products
GROUP BY catalog_id;

-- используя функцию COUNT() мы можем подсчитать количество записей в каждой из этих групп
SELECT
    catalog_id,
    count(*) AS total
FROM products
GROUP BY catalog_id;

SELECT
    count(id) AS total_ids,
    count(catalog_id) AS total_catalog_ids
FROM products;

SELECT
    count(DISTINCT id) AS total_ids,
    count(DISTINCT catalog_id) AS total_catalog_ids
FROM products;

-- функции MIN() и MAX() возвращают минимальное и максимальное значение столбца
SELECT
    min(price),
    max(price)
FROM products;

SELECT
    catalog_id,
    min(price),
    max(price)
FROM products
GROUP BY catalog_id;

SELECT
    id,
    name,
    price
FROM products
ORDER BY price DESC
LIMIT 1;

-- функция AVG() возвращает среднее значение
SELECT
    catalog_id,
    round(avg(price), 2) AS price
FROM products
GROUP BY catalog_id;

-- мы можем увеличить возвращаемую цену на 20% 
SELECT
    catalog_id,
    round(avg(price) * 1.2, 2) AS price
FROM products
GROUP BY catalog_id;

-- функция SUM() возвращает сумму всех значений столбца
SELECT
    catalog_id,
    sum(price) AS summ
FROM products
GROUP BY catalog_id;

/*------------Модуль № 3 - Специальные возможности GROUP BY.------------*/
-- Содержание:
-- Условие HAVING
-- Получение уникальных значений
-- Функция ANY_VALUE()
-- Конструкция WITH ROLLUP

SELECT
    group_concat(name ORDER BY name SEPARATOR ', '),
    substring(birthday_at, 1, 3) AS decade
FROM users
GROUP BY decade;

SELECT
    count(*) AS total,
    substring(birthday_at, 1, 3) AS decade
FROM users
GROUP BY decade
ORDER BY decade;

SELECT
    count(*) AS total,
    substring(birthday_at, 1, 3) AS decade
FROM users
GROUP BY decade
HAVING total >= 2
ORDER BY decade;

-- перенос уникальных строк из одной таблицы в другую
-- создадим временную таблицу
DROP TABLE IF EXISTS products_new;
CREATE TABLE products_new(
    id serial,
    name VARCHAR(255) comment 'Название раздела',
    description TEXT comment 'Описание',
    price DECIMAL(11,2) comment 'Цена',
    catalog_id INT UNSIGNED,
    created_at DATETIME DEFAULT current_timestamp,
    updated_at DATETIME DEFAULT current_timestamp ON UPDATE current_timestamp,
    
    PRIMARY KEY(id),
    KEY index_of_catalog_id(catalog_id)
) comment = 'Товарные позиции';

-- в таблицу "products" дважды добавим один и тот же товар
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

-- перенесём уникальные записи во временную таблицу "products_new"
INSERT INTO products_new(
    name,
    description,
    price,
    catalog_id,
    created_at,
    updated_at
)
SELECT
-- здесь можно было указать NULL и тогда в разделе INSERT не нужно было бы перечислять названия столбцов для вставки
    name,
    description,
    price,
    catalog_id,
    now(),
    now()
FROM products
GROUP BY
    name,
    description,
    price,
    catalog_id;

SELECT * FROM products_new;

-- удалим таблицу products и дадим её имя таблице products_new 
DROP TABLE IF EXISTS products;
ALTER TABLE products_new RENAME products;

SHOW tables;
SELECT * FROM products;

-- для группировки можно использовать вычисляемые значения
SELECT
    name,
    birthday_at
FROM users
ORDER BY birthday_at;

SELECT
    name,
    birthday_at
FROM users
ORDER BY birthday_at;

SELECT
    group_concat(name ORDER BY name SEPARATOR ', ') AS name,
    YEAR(birthday_at) AS birthday_year
FROM users
GROUP BY birthday_year
ORDER BY birthday_year;

-- так же можно использовать функцию ANY_VALUE(), кот. возвращает случайное значение из группы
SELECT
    any_value(name) AS name,
    YEAR(birthday_at) AS birthday_year
FROM users
GROUP BY birthday_year
ORDER BY birthday_year;

SELECT
    substring(birthday_at, 1, 3) AS decade,
    count(*) AS total
FROM users
GROUP BY decade
-- ORDER BY decade -- конструкция WITH ROLLUP с сортировкой почему- то не работает
WITH ROLLUP;
