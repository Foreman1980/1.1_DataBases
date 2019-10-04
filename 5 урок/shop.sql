DROP DATABASE IF EXISTS shop;
CREATE DATABASE shop;

USE shop;

DROP TABLE IF EXISTS catalogs;
CREATE TABLE catalogs(
	id serial,
	name VARCHAR(255) comment 'Название раздела',
	
	PRIMARY KEY(id),
	UNIQUE unique_name(name(10))
) comment = 'Разделы интернет-магазина';

/* INSERT INTO catalogs VALUES (DEFAULT, 'Процессоры');
 INSERT INTO catalogs VALUES (DEFAULT, 'Мат. платы');
 INSERT INTO catalogs VALUES (DEFAULT, 'Видеокарты');
 
 INSERT INTO catalogs VALUES
     (DEFAULT, 'Процессоры'),
     (DEFAULT, 'Мат. платы'),
     (DEFAULT, 'Видеокарты');*/
 

INSERT INTO catalogs (name) VALUES
    ('Процессоры'),
    ('Мат. платы'),
    ('Видеокарты');

/*INSERT IGNORE INTO catalogs (name) VALUES
    ('Процессоры'),
    ('Мат. платы'),
    ('Видеокарты'),
    ('Видеокарты');*/

-- SELECT id, name FROM catalogs;
-- SELECT * FROM catalogs;

-- DELETE FROM catalogs;
-- DELETE FROM catalogs LIMIT 2;
-- DELETE FROM catalogs WHERE id > 1 LIMIT 1;

-- truncate catalogs;

UPDATE catalogs
    SET name = 'Процессоры (Intel)'
    WHERE name = 'Процессоры';

/*DROP TABLE IF EXISTS cat;
CREATE TABLE cat(
    id serial,
    name VARCHAR(255) comment 'Название раздела',
    
    PRIMARY KEY(id),
    UNIQUE unique_name(name(10))
) comment = 'Копия таблицы "catalogs"';

INSERT cat -- ключевое слово "INTO" - опционально
    SELECT *
    FROM catalogs;

SELECT * FROM cat;*/

DROP TABLE IF EXISTS users;
CREATE TABLE users(
	id serial,
	name VARCHAR(255) comment 'Имя покупателя',
	birthday_at DATE comment 'Дата рождения',
	created_at DATETIME DEFAULT current_timestamp,
	updated_at DATETIME DEFAULT current_timestamp ON UPDATE current_timestamp,
	
	PRIMARY KEY(id)
) comment = 'Покупатели';

DROP TABLE IF EXISTS products;
CREATE TABLE products(
	id serial,
	name VARCHAR(255) comment 'Название раздела',
	description TEXT comment 'Описание',
	prise DECIMAL(11,2) comment 'Цена',
	catalog_id INT UNSIGNED,
	created_at DATETIME DEFAULT current_timestamp,
    updated_at DATETIME DEFAULT current_timestamp ON UPDATE current_timestamp,
    
    PRIMARY KEY(id),
    KEY index_of_catalog_id(catalog_id)
) comment = 'Товарные позиции';

-- CREATE INDEX index_of_catalog_id ON products(catalog_id);
/* Мы можем явно указать тип индекса при помощи ключевого слова "USING" */
-- CREATE INDEX index_of_catalog_id USING BTREE ON products(catalog_id);
/* где BTREE это бинарное дерево. Также есть HASH-индексы. */
-- DROP INDEX index_of_catalog_id ON products;

DROP TABLE IF EXISTS orders;
CREATE TABLE orders(
	id INT UNSIGNED NOT NULL,
	user_id INT UNSIGNED,
	created_at DATETIME DEFAULT current_timestamp,
    updated_at DATETIME DEFAULT current_timestamp ON UPDATE current_timestamp,
    
    PRIMARY KEY(id),
    KEY index_of_user_id(user_id)
) comment = 'Заказы';

DROP TABLE IF EXISTS orders_products;
CREATE TABLE orders_products(
	id serial,
	order_id INT UNSIGNED,
	product_id INT UNSIGNED,
	total INT UNSIGNED DEFAULT 1 comment 'Количество заказанных товарных позиций',
	created_at DATETIME DEFAULT current_timestamp,
    updated_at DATETIME DEFAULT current_timestamp ON UPDATE current_timestamp,
    
    PRIMARY KEY(id)
--     KEY index_of_order_id(order_id, product_id),
--     KEY index_of_product_id(product_id, order_id)
) comment = 'Состав заказа';

DROP TABLE IF EXISTS discounts;
CREATE TABLE discounts(
	id serial,
	user_id INT UNSIGNED,
	product_id INT UNSIGNED,
	discount FLOAT UNSIGNED comment 'Величина скидки от 0.0 до 1.0',
	started_at DATETIME,
	finished_at DATETIME,
	created_at DATETIME DEFAULT current_timestamp,
    updated_at DATETIME DEFAULT current_timestamp ON UPDATE current_timestamp,
    
    PRIMARY KEY(id),
    KEY index_of_user_id(user_id),
    KEY index_of_product_id(product_id)
) comment = 'Скидки';

DROP TABLE IF EXISTS storehouses;
CREATE TABLE storehouses(
    id serial,
    name varchar(255) comment 'Название',
    created_at DATETIME DEFAULT current_timestamp,
    updated_at DATETIME DEFAULT current_timestamp ON UPDATE current_timestamp,
    
    PRIMARY KEY(id)
) comment = 'Склады';

DROP TABLE IF EXISTS storehouses_products;
CREATE TABLE storehouses_products(
	id serial,
	storehouse_id INT UNSIGNED,
	product_id INT UNSIGNED,
	value INT UNSIGNED comment 'Запас товарной позиции на складе',
	created_at DATETIME DEFAULT current_timestamp,
    updated_at DATETIME DEFAULT current_timestamp ON UPDATE current_timestamp,
    
    PRIMARY KEY(id)
) comment = 'Запасы на складе';












