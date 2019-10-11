-- Заполнение данными БД "shop" по материалам урока № 5
-- С учётом урока № 7

USE shop;

truncate catalogs;
/* INSERT INTO catalogs VALUES (DEFAULT, 'Процессоры');
 INSERT INTO catalogs VALUES (DEFAULT, 'Мат. платы');
 INSERT INTO catalogs VALUES (DEFAULT, 'Видеокарты');
 
 INSERT INTO catalogs VALUES
     (DEFAULT, 'Процессоры'),
     (DEFAULT, 'Мат. платы'),
     (DEFAULT, 'Видеокарты');*/
 

INSERT INTO catalogs (name) VALUES
    ('Процессоры'),
    ('Материнские платы'),
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

-- UPDATE catalogs
--     SET name = 'Процессоры (Intel)'
--     WHERE name = 'Процессоры';

-- INSERT INTO catalogs (name) VALUES
--     ('Жесткие диски'),
--     ('Оперативная память');

UPDATE catalogs
    SET name = 'Материнские платы'
    WHERE name = 'Мат. платы';

truncate users;
INSERT INTO users (name, birthday_at)
VALUES
    ('Геннадий', '1990-10-05'),
    ('Наталья', '1984-11-12'),
    ('Александр', '1985-05-20'),
    ('Сергей', '1988-02-14'),
    ('Иван', '1998-01-12'),
    ('Мария', '1992-08-29');

truncate products;
INSERT INTO products(name, description, price, catalog_id)
VALUES
    ('Intel Core i3-8100', 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.', 7890.00, 1),
    ('Intel Core i5-7400', 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.', 12700.00, 1),
    ('AMD FX-8320E', 'Процессор для настольных персональных компьютеров, основанных на платформе AMD.', 4780.00, 1),
    ('AMD FX-8320', 'Процессор для настольных персональных компьютеров, основанных на платформе AMD.', 7120.00, 1),
    ('ASUS ROG MAXIMUS X HERO', 'Материнская плата ASUS ROG MAXIMUS X HERO, Z370, Socket 1151-V2, DDR4, ATX', 19310.00, 2),
    ('Gigabyte H310M S2H', 'Материнская плата Gigabyte H310M S2H, H310, Socket 1151-V2, DDR4, mATX', 4790.00, 2),
    ('MSI B250M GAMING PRO', 'Материнская плата MSI B250M GAMING PRO, B250, Socket 1151, DDR4, mATX', 5060.00, 2);

INSERT INTO users(name, birthday_at)
VALUES
    ('Светлана', '1988-02-04'),
    ('Олег', '1998-03-20'),
    ('Юлия', '2006-07-12');

-- Урок № 7 - начало
truncate orders;
INSERT INTO orders(user_id)
VALUES (1), (3), (5), (7), (5), (7);

truncate orders_products;
INSERT INTO orders_products(order_id, product_id, total)
VALUES
    (1, 1, 1),
    (1, 5, 1),
    (2, 2, 1),
    (2, 7, 1),
    (3, 6, 1),
    (4, 7, 1),
    (5, 3, 1),
    (6, 3, 1);
-- Урок № 7 - конец
