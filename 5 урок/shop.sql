DROP DATABASE IF EXISTS shop;
CREATE DATABASE shop;

USE shop;

DROP TABLE IF EXISTS catalogs;
CREATE TABLE catalogs(
	id serial,
	name VARCHAR(255) comment '�������� �������',
	
	PRIMARY KEY(id),
	UNIQUE unique_name(name(10))
) comment = '������� ��������-��������';

/* INSERT INTO catalogs VALUES (DEFAULT, '����������');
 INSERT INTO catalogs VALUES (DEFAULT, '���. �����');
 INSERT INTO catalogs VALUES (DEFAULT, '����������');
 
 INSERT INTO catalogs VALUES
     (DEFAULT, '����������'),
     (DEFAULT, '���. �����'),
     (DEFAULT, '����������');*/
 

INSERT INTO catalogs (name) VALUES
    ('����������'),
    ('���. �����'),
    ('����������');

/*INSERT IGNORE INTO catalogs (name) VALUES
    ('����������'),
    ('���. �����'),
    ('����������'),
    ('����������');*/

-- SELECT id, name FROM catalogs;
-- SELECT * FROM catalogs;

-- DELETE FROM catalogs;
-- DELETE FROM catalogs LIMIT 2;
-- DELETE FROM catalogs WHERE id > 1 LIMIT 1;

-- truncate catalogs;

UPDATE catalogs
    SET name = '���������� (Intel)'
    WHERE name = '����������';

/*DROP TABLE IF EXISTS cat;
CREATE TABLE cat(
    id serial,
    name VARCHAR(255) comment '�������� �������',
    
    PRIMARY KEY(id),
    UNIQUE unique_name(name(10))
) comment = '����� ������� "catalogs"';

INSERT cat -- �������� ����� "INTO" - �����������
    SELECT *
    FROM catalogs;

SELECT * FROM cat;*/

DROP TABLE IF EXISTS users;
CREATE TABLE users(
	id serial,
	name VARCHAR(255) comment '��� ����������',
	birthday_at DATE comment '���� ��������',
	created_at DATETIME DEFAULT current_timestamp,
	updated_at DATETIME DEFAULT current_timestamp ON UPDATE current_timestamp,
	
	PRIMARY KEY(id)
) comment = '����������';

DROP TABLE IF EXISTS products;
CREATE TABLE products(
	id serial,
	name VARCHAR(255) comment '�������� �������',
	description TEXT comment '��������',
	prise DECIMAL(11,2) comment '����',
	catalog_id INT UNSIGNED,
	created_at DATETIME DEFAULT current_timestamp,
    updated_at DATETIME DEFAULT current_timestamp ON UPDATE current_timestamp,
    
    PRIMARY KEY(id),
    KEY index_of_catalog_id(catalog_id)
) comment = '�������� �������';

-- CREATE INDEX index_of_catalog_id ON products(catalog_id);
/* �� ����� ���� ������� ��� ������� ��� ������ ��������� ����� "USING" */
-- CREATE INDEX index_of_catalog_id USING BTREE ON products(catalog_id);
/* ��� BTREE ��� �������� ������. ����� ���� HASH-�������. */
-- DROP INDEX index_of_catalog_id ON products;

DROP TABLE IF EXISTS orders;
CREATE TABLE orders(
	id INT UNSIGNED NOT NULL,
	user_id INT UNSIGNED,
	created_at DATETIME DEFAULT current_timestamp,
    updated_at DATETIME DEFAULT current_timestamp ON UPDATE current_timestamp,
    
    PRIMARY KEY(id),
    KEY index_of_user_id(user_id)
) comment = '������';

DROP TABLE IF EXISTS orders_products;
CREATE TABLE orders_products(
	id serial,
	order_id INT UNSIGNED,
	product_id INT UNSIGNED,
	total INT UNSIGNED DEFAULT 1 comment '���������� ���������� �������� �������',
	created_at DATETIME DEFAULT current_timestamp,
    updated_at DATETIME DEFAULT current_timestamp ON UPDATE current_timestamp,
    
    PRIMARY KEY(id)
--     KEY index_of_order_id(order_id, product_id),
--     KEY index_of_product_id(product_id, order_id)
) comment = '������ ������';

DROP TABLE IF EXISTS discounts;
CREATE TABLE discounts(
	id serial,
	user_id INT UNSIGNED,
	product_id INT UNSIGNED,
	discount FLOAT UNSIGNED comment '�������� ������ �� 0.0 �� 1.0',
	started_at DATETIME,
	finished_at DATETIME,
	created_at DATETIME DEFAULT current_timestamp,
    updated_at DATETIME DEFAULT current_timestamp ON UPDATE current_timestamp,
    
    PRIMARY KEY(id),
    KEY index_of_user_id(user_id),
    KEY index_of_product_id(product_id)
) comment = '������';

DROP TABLE IF EXISTS storehouses;
CREATE TABLE storehouses(
    id serial,
    name varchar(255) comment '��������',
    created_at DATETIME DEFAULT current_timestamp,
    updated_at DATETIME DEFAULT current_timestamp ON UPDATE current_timestamp,
    
    PRIMARY KEY(id)
) comment = '������';

DROP TABLE IF EXISTS storehouses_products;
CREATE TABLE storehouses_products(
	id serial,
	storehouse_id INT UNSIGNED,
	product_id INT UNSIGNED,
	value INT UNSIGNED comment '����� �������� ������� �� ������',
	created_at DATETIME DEFAULT current_timestamp,
    updated_at DATETIME DEFAULT current_timestamp ON UPDATE current_timestamp,
    
    PRIMARY KEY(id)
) comment = '������ �� ������';












