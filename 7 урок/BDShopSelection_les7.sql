/*--------------Отработка запросов по материалам урока № 7--------------*/

/*------------------------Тема - Сложные запросы------------------------*/
-- Содержание:
-- Модуль № 1 - Типы многотабличных запросов и UNION
-- Модуль № 2 - Вложенные запросы
-- Модуль № 3 - JOIN-объединения таблиц
-- Модуль № 4 - Внешние ключи и ссылочная целостность
/*-----------Модуль № 1 - Типы многотабличных запросов и UNION-----------*/
-- Содержание:


USE shop;

/*------------Получить список товаров из раздела "Процессоры"------------*/
-- Шаг 1
SELECT *
FROM products
WHERE catalog_id = (SELECT id
                    FROM catalogs
                    WHERE name LIKE 'Проц%');

/*--------Найти в таблице "products" товар с самой высокой ценой--------*/
-- Шаг 1
SELECT id, name, price
FROM products
ORDER BY price DESC
LIMIT 1;

-- с использованиме вложенного запроса (как в видео-уроке)
-- Шаг 1
SELECT max(price)
FROM products;

-- Шаг 2
SELECT id, name, price
FROM products
WHERE price = ( SELECT max(price)
                FROM products);

/*----------------Найти все товары, чья цена ниже средней----------------*/
-- Шаг 1
SELECT avg(price)
FROM products;

-- Шаг 2
SELECT id, name, price     
FROM products
WHERE price < ( SELECT avg(price)
                FROM products);

/*------------Для каждого из товаров извлеч название каталога------------*/
-- Шаг 1
SELECT
    id,
    name,
    (   SELECT name
        FROM catalogs
        WHERE id = catalog_id) AS 'catalog'
FROM products;

-- в случаях конфликта, можно явно использовать "квалификационные" имена:
SELECT
    products.id,
    products.name,
    (   SELECT catalogs.name
        FROM catalogs
        WHERE catalogs.id = products.catalog_id) AS 'catalog'
FROM products;

-- Если подзапрос использует столбец из внешного запроса, то такой подзапрос называется "коррелированным"
-- (это довольно ресурсоёмко при объёмных таблицах)

/*Есть ли среди товаров из "Мат. плат" поз. дешевле любой (какой-нибудь) поз. из "Процессоры"*/
-- Шаг 1 - Найдём все товары из раздела "Материнские платы"
SELECT id, name, price
FROM products
WHERE catalog_id = (SELECT id
                    FROM catalogs
                    WHERE name LIKE 'мат%');

-- Шаг 2 - Найдём все товары из раздела "Процессоры"
SELECT id, name, price
FROM products
WHERE catalog_id = (SELECT id
                    FROM catalogs
                    WHERE name LIKE 'проц%');

-- Шаг 3 - Найдём всве цены на процессоры
SELECT price
FROM products
WHERE catalog_id = (SELECT id
                    FROM catalogs
                    WHERE name LIKE 'проц%');

-- Шаг 4 - Итог
SELECT id, name, price, catalog_id    
FROM products
WHERE catalog_id = (SELECT id
                    FROM catalogs
                    WHERE name LIKE 'мат%') AND price < ANY (   SELECT price
                                                                FROM products
                                                                WHERE catalog_id = (SELECT id
                                                                                    FROM catalogs
                                                                                    WHERE name LIKE 'проц%'));

-- то же с ключевым словом "SOME"
SELECT id, name, price, catalog_id    
FROM products
WHERE catalog_id = (SELECT id
                    FROM catalogs
                    WHERE name LIKE 'мат%') AND price < SOME (  SELECT price
                                                                FROM products
                                                                WHERE catalog_id = (SELECT id
                                                                                    FROM catalogs
                                                                                    WHERE name LIKE 'проц%'));

/*Найдём все товары из "Мат. плат", кот. дороже любой поз. из "Процессоры"*/
-- Шаг 1
SELECT id, name, price, catalog_id    
FROM products
WHERE catalog_id = (SELECT id
                    FROM catalogs
                    WHERE name LIKE 'мат%') AND price > ALL (   SELECT price
                                                                FROM products
                                                                WHERE catalog_id = (SELECT id
                                                                                    FROM catalogs
                                                                                    WHERE name LIKE 'проц%'));

/*Извлечь те разделы каталога, для кот. имеется хотя бы одна товарная поз.*/
-- Шаг 1
SELECT *
FROM catalogs
WHERE id IN (   SELECT catalog_id
                FROM products);

-- с использованиме вложенного запроса (как в видео-уроке)
SELECT *
FROM catalogs
WHERE EXISTS (  SELECT *
                FROM products
                WHERE catalog_id = catalogs.id);
-- если вложенный запрос возвращает более одной строки "EXISTS" возвращает истину
-- для ускорения работы подзапроса можно не выводить никаких столбцов (заменим "*" на "1"): 
SELECT *
FROM catalogs
WHERE EXISTS (  SELECT 1
                FROM products
                WHERE catalog_id = catalogs.id);

/*Извлечь те разделы каталога, для кот. нет ни одной товарной поз.*/
-- Шаг 1
SELECT *
FROM catalogs
WHERE NOT EXISTS (  SELECT 1
                    FROM products
                    WHERE catalog_id = catalogs.id);

/*--Вычислить минимальные цены в разделах и получить среднюю мин. цену--*/
-- Шаг 1
SELECT
    (   SELECT name
        FROM catalogs
        WHERE id = catalog_id) AS 'Catalogs',
    min(price)
FROM products
GROUP BY catalog_id;

-- Шаг 2
SELECT avg(price)
FROM (  SELECT min(price) AS price
        FROM products
        GROUP BY catalog_id) AS min_price;

/*-----------------Модуль № 3 - JOIN-объединения таблиц-----------------*/
-- Содержание:
-- Декартово произведение таблиц
-- Типы соединений
-- Ключевые слова ON и USING
-- Многотабличные обновления
-- Многотабличные удаления

/*---------------Объединим таблицы "catalogs" и "products"---------------*/
-- Шаг 1
SELECT p.name, p.price, c.name
FROM catalogs AS c JOIN products AS p;

-- Шаг 2
SELECT p.name, p.price, c.name
FROM catalogs AS c JOIN products AS p
WHERE c.id = p.catalog_id;

-- Шаг 3
SELECT p.name, p.price, c.name
FROM catalogs AS c JOIN products AS p
ON c.id = p.catalog_id;
-- "ON"-условие срабатывает в момент соединения, т.е. результирующая таблица сразу получается небольшой, в то время как
-- "WHERE"-условие всегда действует после соединения, т.е. сначала получается промежуточная таблица с декартовым
-- произведением исходных таблиц и лишь затем осуществляется фильтрация

/*---------------Объединим таблицу "catalogs" саму с собой---------------*/
-- Шаг 1
SELECT *
FROM catalogs AS fst JOIN catalogs AS snd;
-- такие запросы называются самообъединением таблиц

-- Щаг 2 - давайте избавимся от повторов
SELECT *
FROM catalogs AS fst JOIN catalogs AS snd
ON fst.id = snd.id;
-- в случае, если названия столбцов в "ON"-условии совпадают, можно использовать ключевое слово "USING"
SELECT *
FROM catalogs AS fst JOIN catalogs AS snd
USING(id);

/*Рассмотрим соединение "LEFT JOIN" на примере табл. "catalogs" и "products"*/
-- Шаг 1
SELECT p.name, p.price, c.name
FROM catalogs AS c JOIN products AS p
ON c.id = p.catalog_id;

-- Шаг 2 - Используем "LEFT JOIN"
SELECT p.name, p.price, c.name
FROM catalogs AS c LEFT JOIN products AS p
ON c.id = p.catalog_id;

-- Шаг 3 - Используем "RIGHT JOIN"
SELECT p.id, p.name, p.price, c.name
FROM products AS p RIGHT JOIN catalogs AS c
ON c.id = p.catalog_id;

-- многотабличные запросы можно использовать не только для извлечения, но и для обновления и удаления данных
/*----------------Снизим цену на 10% для материнских плат----------------*/
-- Шаг 1
-- UPDATE catalogs JOIN products
-- ON catalogs.id = products.catalog_id
-- SET price = price * 0.9
-- WHERE catalogs.name LIKE 'мат%';

/*----------------Снизим цену на 10% для материнских плат----------------*/
-- Шаг 1 - здесь нужно явно указывать из каких таблиц нужно удалить записи
-- DELETE catalogs, products
-- FROM catalogs JOIN products
-- ON catalogs.id = products.catalog_id
-- WHERE catalogs.name LIKE 'мат%';

/*----------Модуль № 4 - Внешние ключи и ссылочная целостность----------*/
-- Содержание:
-- Ограничение внешнего ключа
-- Нарушение ссылочной целостности
-- Ключевое слово FOREIGN KEY
















-- самое важное из нового материала: коррелированные запросы, EXISTS, конструктор ("ROW" для вывода нескольких
-- столбцов, само ключевое слово не обязательно)
