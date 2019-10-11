/*-------------------Приктическое задание к уроку № 7-------------------*/

/* 1. Составьте список пользователей users, которые осуществили хотя бы один заказ orders
 * в интернет магазине.*/
-- Вариант 1
SELECT id, name
FROM users
WHERE id IN (   SELECT user_id
                FROM orders);

-- Вариант 2
SELECT users.id, users.name
FROM users JOIN orders
ON users.id = orders.user_id
GROUP BY users.id;

/* 2. Выведите список товаров products и разделов catalogs, который соответствует товару.*/
-- это же было в видео-уроке...или я опять что-то путаю??
SELECT
    products.id,
    products.name,
    (   SELECT catalogs.name
        FROM catalogs
        WHERE catalogs.id = products.catalog_id) AS 'catalog'
FROM products;

/* 3. Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label,
 * name). Поля from, to и label содержат английские названия городов, поле name — русское.
 * Выведите список рейсов flights с русскими названиями городов.*/
DROP DATABASE IF EXISTS examples;
CREATE DATABASE examples;

USE examples;

DROP TABLE IF EXISTS flights;
CREATE TABLE flights(
    id serial,
    city_from varchar(255),
    city_to varchar(255),
    
    PRIMARY KEY (id)
);

DROP TABLE IF EXISTS cities;
CREATE TABLE cities(
    id serial,
    label varchar(255),
    name varchar(255),
    
    PRIMARY KEY (id)
);

INSERT INTO flights(city_from, city_to)
VALUES
    ('moscow', 'omsk'),
    ('novgorod', 'kazan'),
    ('irkutsk', 'moscow'),
    ('omsk', 'irkutsk'),
    ('moscow', 'kazan');

INSERT INTO cities(label, name)
VALUES
    ('moscow', 'Москва'),
    ('irkutsk', 'Иркутск'),
    ('novgorod', 'Новгород'),
    ('kazan', 'Казань'),
    ('omsk', 'Омск');

SELECT *
FROM flights;

SELECT *
FROM cities;

SELECT
    (   SELECT cities.name
        FROM cities
        WHERE cities.label = flights.city_from) AS 'Город отправления',
    (   SELECT cities.name
        FROM cities
        WHERE cities.label = flights.city_to) AS 'Город прибытия'
FROM flights;
