/*------------------Формирование структуры БД "RLineShop" для курсового проекта------------------*/

DROP DATABASE IF EXISTS rlineshop;
CREATE DATABASE rlineshop;

USE rlineshop;

DROP TABLE IF EXISTS discount_card;
CREATE TABLE discount_card(
    id serial,
    barcode varchar(13) NOT NULL,
    summ decimal(10,2),
    created_at datetime DEFAULT CURRENT_TIMESTAMP,
    is_deleted bit(1) NOT NULL DEFAULT b'0',
       
    PRIMARY KEY (id),
    INDEX discount_card_barcode_idx (barcode)
) comment 'Дисконтная карта и накопленная сумма скидки.';

DROP TABLE IF EXISTS categories;
CREATE TABLE categories(
    id serial,
    name varchar(100) NOT NULL,
    description text,
    created_at datetime DEFAULT CURRENT_TIMESTAMP,
    updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_deleted bit(1) NOT NULL DEFAULT b'0',
       
    PRIMARY KEY (id)
) comment 'Товарная категория.';

DROP TABLE IF EXISTS products;
CREATE TABLE products(
    id serial,
    category_id bigint unsigned NOT NULL,
    name varchar(255) NOT NULL,
    short_description text,
    full_description text,
    other_nutrients text,
    recommendations text,
    serving_size_gramm int UNSIGNED NOT NULL,
    energy_per_serv_kсal int UNSIGNED NOT NULL,
    link varchar(255) DEFAULT NULL,
    created_at datetime DEFAULT CURRENT_TIMESTAMP,
    updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_deleted bit(1) NOT NULL DEFAULT b'0',
       
    PRIMARY KEY (id),
    INDEX name_idx (name(10)),
    FOREIGN KEY (category_id) REFERENCES categories(id)
) comment 'Карточка товара.';

DROP TABLE IF EXISTS certificates;
CREATE TABLE certificates(
    id serial,
    file_name varchar(255),
    link varchar(255) DEFAULT NULL,
    short_description text,
    created_at datetime DEFAULT CURRENT_TIMESTAMP,
    updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_deleted bit(1) NOT NULL DEFAULT b'0',
       
    PRIMARY KEY (id)
) comment 'Сертификат качества или декларация соответствия товара.';

DROP TABLE IF EXISTS product_certificate;
CREATE TABLE product_certificate(
    id serial,
    product_id bigint unsigned NOT NULL,
    certificate_id bigint unsigned NOT NULL,
    created_at datetime DEFAULT CURRENT_TIMESTAMP,
    updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
       
    PRIMARY KEY (id),
    FOREIGN KEY (product_id) REFERENCES products(id)
) comment 'Связь товара и сертификата качества либо декларацией соответствия.';

DROP TABLE IF EXISTS units;
CREATE TABLE units(
    id serial,
    abbreviation varchar(20),
    full_name varchar(100),
    si_units_value bigint DEFAULT NULL comment 'для конвертации к единой единице измерения в СИ',
    si_units_abbreviation varchar(20) comment 'наименование единицы измерения в СИ',
    short_description text DEFAULT NULL,
           
    PRIMARY KEY (id)
) comment 'Список отношений используемых единиц измерения к единицам в системе СИ для преобразованию к общему виду.';

DROP TABLE IF EXISTS nutrients;
CREATE TABLE nutrients(
    id serial,
    name varchar(100) NOT NULL,
    alter_name varchar(255) DEFAULT NULL,
    short_description text DEFAULT NULL,
    daily_value int UNSIGNED DEFAULT NULL comment 'суточная норма при высокой физической нагрузке',
    units_id varchar(20),
           
    PRIMARY KEY (id)
) comment 'Список питательных веществ.';

DROP TABLE IF EXISTS nutrient_compositions;
CREATE TABLE nutrient_compositions(
    id serial,
    product_id bigint unsigned NOT NULL,
    nutrient_id bigint unsigned NOT NULL,
    value float UNSIGNED DEFAULT NULL,
           
    PRIMARY KEY (id),
    FOREIGN KEY (product_id) REFERENCES products(id),
    FOREIGN KEY (nutrient_id) REFERENCES nutrients(id)
) comment 'Состав нутриентов в конкретном продукте.';

DROP TABLE IF EXISTS amino_acids;
CREATE TABLE amino_acids(
    id serial,
    name varchar(100) NOT NULL,
    alter_name varchar(255) DEFAULT NULL,
    short_description text DEFAULT NULL,
    daily_value varchar(20) DEFAULT NULL comment 'суточная норма при высокой физической нагрузке',
    units_id varchar(20),
           
    PRIMARY KEY (id)
) comment 'Список аминокислот.';

DROP TABLE IF EXISTS amino_acid_compositions;
CREATE TABLE amino_acid_compositions(
    id serial,
    product_id bigint unsigned NOT NULL,
    amino_acid_id bigint unsigned NOT NULL,
    value int UNSIGNED DEFAULT NULL,
           
    PRIMARY KEY (id),
    FOREIGN KEY (product_id) REFERENCES products(id),
    FOREIGN KEY (amino_acid_id) REFERENCES amino_acids(id)
) comment 'Состав аминокислот в конкретном продукте.';

DROP TABLE IF EXISTS vitamin_complex;
CREATE TABLE vitamin_complex(
    id serial,
    name varchar(100) NOT NULL,
    alter_name varchar(255) DEFAULT NULL,
    short_description text,
    daily_value int UNSIGNED DEFAULT NULL comment 'суточная норма при высокой физической нагрузке',
    units_id varchar(20),
           
    PRIMARY KEY (id)
) comment 'Список витаминов и минералов.';

DROP TABLE IF EXISTS vitamin_complex_compositions;
CREATE TABLE vitamin_complex_compositions(
    id serial,
    product_id bigint unsigned NOT NULL,
    vitamin_complex_id bigint unsigned NOT NULL,
    value int UNSIGNED DEFAULT NULL,
           
    PRIMARY KEY (id),
    FOREIGN KEY (product_id) REFERENCES products(id),
    FOREIGN KEY (vitamin_complex_id) REFERENCES vitamin_complex(id)
) comment 'Состав витаминно-минерального комплекса в конкретном продукте.';

DROP TABLE IF EXISTS product_photos;
CREATE TABLE product_photos(
    id serial,
    product_id bigint unsigned NOT NULL,
    -- добавить внешние ключи по таре и развесовке
    file_name varchar(255),
       
    PRIMARY KEY (id),
    FOREIGN KEY (product_id) REFERENCES products(id)
    -- индекс таре/развесовке
) comment 'Фотографии товара.';

DROP TABLE IF EXISTS clients;
CREATE TABLE clients(
    id serial,
    handle varchar(100),
    phone varchar(12) NOT NULL,
    email varchar(100) NOT NULL,
    vk_profile varchar(100) DEFAULT NULL,
    hometown varchar(100) NOT NULL,
    discount_card_id bigint UNSIGNED NOT NULL,
    registration datetime DEFAULT CURRENT_TIMESTAMP,
    updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_deleted bit(1) NOT NULL DEFAULT b'0',
       
    PRIMARY KEY (id),
    INDEX clients_handle_idx (handle),
    INDEX clients_phone_idx (phone),
    INDEX clients_email_idx (email),
    INDEX clients_vk_profile_idx (vk_profile),
    INDEX clients_hometown_idx (hometown),
    INDEX clients_discount_card_idx (discount_card_id),
    FOREIGN KEY (discount_card_id) REFERENCES discount_card(id) ON DELETE NO ACTION ON UPDATE NO ACTION
) comment 'Карточка клиента. Формируется при подтверждении и/или оплате заказа.';

DROP TABLE IF EXISTS storehouses;
CREATE TABLE storehouses(
    id int unsigned NOT NULL AUTO_INCREMENT,
    name varchar(100) NOT NULL,
    description varchar(255),
       
    PRIMARY KEY (id)
) comment 'Перечень складов.';

DROP TABLE IF EXISTS storehouses_products;
CREATE TABLE storehouses_products(
  id serial,
  storehouse_id int unsigned NOT NULL DEFAULT 1,
  product_id bigint unsigned NOT NULL,
  value int unsigned NOT NULL COMMENT 'Запас товарной позиции на складе',
  created_at datetime DEFAULT CURRENT_TIMESTAMP,
  updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  is_deleted bit(1) NOT NULL DEFAULT b'0',
       
    PRIMARY KEY (id),
    FOREIGN KEY (storehouse_id) REFERENCES storehouses(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
) comment 'Запасы на складе.';

DROP TABLE IF EXISTS price_lists;
CREATE TABLE price_lists(
    id bigint unsigned NOT NULL AUTO_INCREMENT,
    name varchar(100) NOT NULL,
    description varchar(255),
       
    PRIMARY KEY (id)
) comment 'Прайс-листы.';

DROP TABLE IF EXISTS promo_codes;
CREATE TABLE promo_codes(
    id serial,
    promo_code varchar(7) NOT NULL,
    discount_card_id bigint UNSIGNED NOT NULL,
    summ decimal(10,2),
    created_at datetime DEFAULT CURRENT_TIMESTAMP,
    activated_at datetime DEFAULT NULL,
       
    PRIMARY KEY (id),
    FOREIGN KEY (discount_card_id) REFERENCES discount_card(id)
) comment 'Промо-коды.';

DROP TABLE IF EXISTS orders;
CREATE TABLE orders(
    id serial,
    storehouse_id int unsigned NOT NULL,
    client_id bigint UNSIGNED DEFAULT NULL,
    created_at datetime DEFAULT CURRENT_TIMESTAMP,
    updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    executed_at datetime,
    paid_at datetime,
    is_deleted bit(1) NOT NULL DEFAULT b'0',
       
    PRIMARY KEY (id),
    FOREIGN KEY (storehouse_id) REFERENCES storehouses(id),
    FOREIGN KEY (client_id) REFERENCES clients(id)
) comment 'Заказы.';

DROP TABLE IF EXISTS orders_products;
CREATE TABLE orders_products(
    id serial,
    order_id bigint UNSIGNED NOT NULL,
    storehouses_product_id bigint unsigned NOT NULL,
    value int unsigned NOT NULL,
        
    PRIMARY KEY (id),
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (storehouses_product_id) REFERENCES storehouses_products(id)
) comment 'Состав заказа/покупки.';

-- DROP TABLE IF EXISTS payments;
-- CREATE TABLE payments(
--     id serial,
--     orders_id bigint NOT NULL,
--     storehouses_product_id int unsigned NOT NULL,
--     value int unsigned NOT NULL,
--         
--     PRIMARY KEY (id)
-- ) comment 'Оплаты.';
