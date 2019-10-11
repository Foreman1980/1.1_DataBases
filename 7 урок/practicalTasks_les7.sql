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











/* 3. Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label,
 * name). Поля from, to и label содержат английские названия городов, поле name — русское.
 * Выведите список рейсов flights с русскими названиями городов.*/














