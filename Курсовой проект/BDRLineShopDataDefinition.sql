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

-- DROP TABLE IF EXISTS orders;
-- CREATE TABLE orders(
--     id serial,
--     user_id bigint NOT NULL,
--     created_at datetime DEFAULT CURRENT_TIMESTAMP,
--     updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
--        
--     PRIMARY KEY (id)
-- );
-- 
-- DROP TABLE IF EXISTS orders_products;
-- CREATE TABLE orders_products(
--     id serial,
--     orders_id bigint NOT NULL,
--     
--     created_at datetime DEFAULT CURRENT_TIMESTAMP,
--     updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
--        
--     PRIMARY KEY (id)
-- );

















