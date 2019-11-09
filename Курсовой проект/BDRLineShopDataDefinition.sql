/*------------------Формирование структуры БД "RLineShop" для курсового проекта------------------*/

DROP DATABASE IF EXISTS rlineshop;
CREATE DATABASE rlineshop;

USE rlineshop;

DROP TABLE IF EXISTS clients;
CREATE TABLE clients(
    id serial,
    handle varchar(100),
    phone varchar(12) NOT NULL,
    email varchar(100),
    vk_profile varchar(100),
    hometown varchar(100),
    discount_card_id bigint NOT NULL,
    registration datetime DEFAULT CURRENT_TIMESTAMP,
    updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_deleted bit(1) NOT NULL DEFAULT b'0',
       
    PRIMARY KEY (id)
    -- добавить внешний ключ по диск. карте
) comment 'Карточка клиента. Формируется при подтверждении и/или оплате заказа.';

DROP TABLE IF EXISTS units;
CREATE TABLE units(
    id serial,
    abbreviation varchar(20),
    full_name varchar(100),
    si_units_value bigint DEFAULT NULL comment 'для конвертации к единой единице измерения в СИ',
    si_units_name varchar(20) comment 'наименование единицы измерения в СИ',
    short_description text DEFAULT NULL,
           
    PRIMARY KEY (id)
) comment 'Список единиц измерения.';

DROP TABLE IF EXISTS consist;
CREATE TABLE consist(
    id serial,
    name varchar(100) NOT NULL,
    alter_name varchar(255) DEFAULT NULL,
    short_description text DEFAULT NULL,
    daily_value int UNSIGNED DEFAULT NULL comment 'суточная норма при высокой физической нагрузке',
    units_id varchar(20),
           
    PRIMARY KEY (id)
) comment 'Состав нутриентов.';

DROP TABLE IF EXISTS nutrients;
CREATE TABLE nutrients(
    id serial,
    consist_id bigint NOT NULL,
    name varchar(100) NOT NULL,
    alter_name varchar(255) DEFAULT NULL,
    short_description text DEFAULT NULL,
    daily_value int UNSIGNED DEFAULT NULL comment 'суточная норма при высокой физической нагрузке',
    units_id varchar(20),
           
    PRIMARY KEY (id)
) comment 'Список питательных веществ.';

DROP TABLE IF EXISTS amino_acids;
CREATE TABLE amino_acids(
    id serial,
    consist_id bigint NOT NULL,
    name varchar(100) NOT NULL,
    alter_name varchar(255) DEFAULT NULL,
    short_description text DEFAULT NULL,
    daily_value int UNSIGNED DEFAULT NULL comment 'суточная норма при высокой физической нагрузке',
    units_id varchar(20),
           
    PRIMARY KEY (id)
) comment 'Список аминокислот.';

DROP TABLE IF EXISTS vitamin_complex;
CREATE TABLE vitamin_complex(
    id serial,
    consist_id bigint NOT NULL,
    name varchar(100) NOT NULL,
    alter_name varchar(255) DEFAULT NULL,
    short_description text,
    daily_value int UNSIGNED DEFAULT NULL comment 'суточная норма при высокой физической нагрузке',
    units_id varchar(20),
           
    PRIMARY KEY (id)
) comment 'Список витаминов и минералов.';

DROP TABLE IF EXISTS products;
CREATE TABLE products(
    id serial,
    name varchar(255) NOT NULL,
    short_description text,
    full_description text,
    recommendations text,
    serving_size_gramm int UNSIGNED NOT NULL,
    energy_per_serv_kсal int UNSIGNED NOT NULL,
    certificate_id varchar(255) DEFAULT NULL,
    link varchar(255) DEFAULT NULL,
    created_at datetime DEFAULT CURRENT_TIMESTAMP,
    updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_deleted bit(1) NOT NULL DEFAULT b'0',
       
    PRIMARY KEY (id)
) comment 'Карточка товара.';

DROP TABLE IF EXISTS product_photos;
CREATE TABLE product_photos(
    id serial,
    product_id bigint unsigned NOT NULL,
    -- добавить внешние ключи по таре и развесовке
    file_name varchar(255),
       
    PRIMARY KEY (id)
    -- индекс по product_id и таре/развесовке
) comment 'Фотографии товара.';

DROP TABLE IF EXISTS discount_card;
CREATE TABLE discount_card(
    id serial,
    barcode varchar(13) NOT NULL,
    summ decimal(10,2),
    is_deleted bit(1) NOT NULL DEFAULT b'0',
       
    PRIMARY KEY (id)
    -- добавить индекс по баркоду карты
) comment 'Дисконтная карта и накопленная сумма скидки.';

DROP TABLE IF EXISTS storehouses;
CREATE TABLE storehouses(
    id int unsigned NOT NULL AUTO_INCREMENT,
    name varchar(100) NOT NULL,
    description varchar(255),
       
    PRIMARY KEY (id)
) comment 'Перечень складов.';

INSERT INTO storehouses(name, description) VALUES
    ('main_warehouse', 'Основной склад'),
    ('retail_warehouse', 'Розничный склад'),
    ('custodyhouse', 'Склад ответственного хранения');

DROP TABLE IF EXISTS storehouses_products;
CREATE TABLE storehouses_products(
  id serial,
  storehouse_id int unsigned NOT NULL DEFAULT 1,
  product_id bigint unsigned NOT NULL,
  value int unsigned NOT NULL COMMENT 'Запас товарной позиции на складе',
  created_at datetime DEFAULT CURRENT_TIMESTAMP,
  updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  is_deleted bit(1) NOT NULL DEFAULT b'0',
       
    PRIMARY KEY (id)
) comment 'Запасы на складе.';

DROP TABLE IF EXISTS price_lists;
CREATE TABLE price_lists(
    id bigint unsigned NOT NULL AUTO_INCREMENT,
    name varchar(100) NOT NULL,
    description varchar(255),
       
    PRIMARY KEY (id)
) comment 'Прайс-листы.';

INSERT INTO price_lists(name, description) VALUES
    ('wholesale', 'Оптовый прайс-лист'),
    ('retail', 'Розничный прайс-лист'),
    ('selling', 'Прайс-лист под реализацию');

DROP TABLE IF EXISTS promo_codes;
CREATE TABLE promo_codes(
    id serial,
    promo_code varchar(7) NOT NULL,
    discount_card_id bigint NOT NULL,
    summ decimal(10,2),
    created_at datetime DEFAULT CURRENT_TIMESTAMP,
    activated_at datetime DEFAULT NULL,
       
    PRIMARY KEY (id)
) comment 'Прайс-листы.';

DROP TABLE IF EXISTS orders;
CREATE TABLE orders(
    id serial,
    storehouse_id int unsigned NOT NULL
    client_id bigint DEFAULT NULL,
    created_at datetime DEFAULT CURRENT_TIMESTAMP,
    updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    executed_at datetime,
    paid_at datetime,
    is_deleted bit(1) NOT NULL DEFAULT b'0',
       
    PRIMARY KEY (id)
);

DROP TABLE IF EXISTS orders_products;
CREATE TABLE orders_products(
    id serial,
    orders_id bigint NOT NULL,
    storehouses_product_id int unsigned NOT NULL,
    value int unsigned NOT NULL,
        
    PRIMARY KEY (id)
    -- добавить внешний ключ orders_id
) comment 'Состав заказа/покупки.';

















