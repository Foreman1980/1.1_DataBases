-- Воспроизведение скрипта урока № 2 (создание БД "shop")
-- С учётом материала урока № 7
-- С учётом материала урока № 9

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
	price DECIMAL(11,2) comment 'Цена',
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

-- Урок № 7 - начало
ALTER TABLE orders
CHANGE id id serial;

-- CONSTRAINT fk_... FOREIGN KEY (col1,...) REFERENCES tbl (tbl_col1,...)
-- fk_...          - имя внешнего ключа (можно не указывать, тогда присвоится автоматически) 
-- (col1,...)      - столбцы таблицы, играющие роль внешнего ключа
-- tbl             - имя таблицы предка
-- (tbl_col1,...)  - столбцы таблицы предка, играющие роль первичного ключа
-- 
-- [ON DELETE...]  - действие при удалении
-- [ON UPDATE...]  - действие при обновлении
-- 
-- CASCADE         - каскадное удаление/обновление
-- SET NULL        - установить NULL
-- NO ACTION       - нет действий
-- RESTRICT        - запрет удаления/обновления (будет ошибка)
-- SET DEFAULT     - установить значение по-умолчанию для столбца

-- SHOW CREATE TABLE products; -- в терминале просмотр скрипта по созданию таблицы products

ALTER TABLE products
CHANGE catalog_id catalog_id bigint UNSIGNED DEFAULT NULL;

ALTER TABLE products
ADD
    CONSTRAINT fk_catalog_id
    FOREIGN KEY (catalog_id)
    REFERENCES catalogs (id)
    ON DELETE SET NULL
    ON UPDATE CASCADE;

-- ALTER TABLE products
-- DROP FOREIGN KEY fk_catalog_id;

-- Урок № 7 - конец

-- Урок № 9 - начало

DROP TABLE IF EXISTS accounts;
CREATE TABLE accounts(
    id serial,
    user_id int,
    total decimal(11,2) comment 'Счёт',
    created_at DATETIME DEFAULT current_timestamp,
    updated_at DATETIME DEFAULT current_timestamp ON UPDATE current_timestamp    
) comment 'Счета пользователей и интернет магазина';

INSERT INTO accounts (user_id, total)
VALUES
    (4, 5000.00),
    (3, 0.00),
    (2, 200.00),
    (NULL, 25000.00);

-- Урок № 9 - конец
