-- Отработка материала урока № 5 не относящегося напрямую к БД "shop"

/*---------ТЕМА: Операторы, фильтрация, сортировка и ограничания---------*/
/*--------------------------МОДУЛЬ № 1. НАЧАЛО.--------------------------*/

SHOW DATABASES;

DROP DATABASE IF EXISTS examples;
CREATE DATABASE examples;

USE example;

SHOW tables;

DROP TABLE IF EXISTS tbl;
CREATE TABLE tbl(
    x int,
    y int,
    summ int AS (x + y)
);

DESCRIBE tbl;

INSERT tbl (x, y) VALUES
    (1, 2),
    (2, 3),
    (6, 9);

SELECT * FROM tbl;

SELECT date('2018-10-10 15:20:00');
SELECT now();

SELECT date_format('2018-06-12 01:59:59', 'На дворе %Y год.'); -- последовательность %Y отвечает за извлечение года из календарного значения
SELECT date_format(now(), 'На дворе %Y год.');

/*Преобразование даты и времени в "UNIXSTAMP"-формат (это количество секунд, которое прошло с полуночи 01.01.1970. Ограничение до 31.12.2037 23:59:59).
 * DATETIME - 8 bytes
 * UNIXSTAMP - 4 bytes
 * UNIX_TIMESTAMP(DATETIME) = UNIXSTAMP
 * FROM_UNIXTIME(UNIXSTAMP) = DATETIME*/
SELECT unix_timestamp(now()) TIMESTAMP, from_unixtime(1570205067) DATETIME;

/*Информационные функции:
 * SELECT VERSION() - возвращает текущую версию MySQL сервера
 * SELECT LAST_INSERT_ID() - возвращает текущее значение счётчика в столбце "AUTO_INCREMENT"...не совсем понятно...
 * SELECT DATABASE() - возврвщает текущую БД, если БД не выбрана, функция возвращает NULL
 * SELECT USER() - возвращает текущего пользователя - root@localhost*/
SELECT VERSION();
SELECT LAST_INSERT_ID();
SELECT DATABASE();
SELECT USER();

-- -------------------------МОДУЛЬ № 5. НАЧАЛО.-------------------------

-- Использование встроенных функций
-- Вычисление расстояния между точками

DROP TABLE IF EXISTS distances;
CREATE TABLE distances(
    id serial,
    x1 int NOT NULL,
    y1 int NOT NULL,
    x2 int NOT NULL,
    y2 int NOT NULL,
    distance double AS (sqrt(pow(x1 - x2, 2) + pow(y1 - y2, 2))),
    
    PRIMARY KEY (id)
) comment 'Расстояние между двумя точками';

truncate distances;
INSERT INTO distances (x1, y1, x2, y2) VALUES
    (1, 1, 4, 5),
    (4, -1, 3, 2),
    (-2, 5, 1, 3);

SELECT * FROM distances;

-- То же самое с использованием JSON полей

DROP TABLE IF EXISTS distances;
CREATE TABLE distances(
    id serial,
    a json NOT NULL,
    b json NOT NULL,
    distance double AS (sqrt(pow(a->>'$.x' - b->>'$.x', 2) + pow(a->>'$.y' - b->>'$.y', 2))),
    
    PRIMARY KEY (id)
) comment 'Расстояние между двумя точками';

truncate distances;
INSERT INTO distances (a, b) VALUES
    ('{"x": 1, "y": 1}', '{"x": 4, "y": 5}'),
    ('{"x": 4, "y": -1}', '{"x": 3, "y": 2}'),
    ('{"x": -2, "y": 5}', '{"x": 1, "y": 3}');

SELECT * FROM distances;

-- Вычисление площади треугольника с использованием функции SIN

DROP TABLE IF EXISTS triangles;
CREATE TABLE triangles(
    id serial,
    a double NOT NULL comment 'Сторона треугольника',
    b double NOT NULL comment 'Сторона треугольника',
    angle int NOT NULL comment 'Угол треугольника в градусах',
    square double AS (a * b * sin(radians(angle)) / 2),
    
    PRIMARY KEY (id)
) comment 'Площадь треугольника';

truncate triangles;
INSERT INTO triangles(a, b, angle)
VALUES
    (1.414, 1, 45),
    (2.707, 2.104, 60),
    (2.088, 2.112, 56),
    (5.014, 2.304, 23),
    (3.482, 4.708, 38);

SELECT * FROM triangles;

ALTER TABLE triangles
CHANGE square
    square double AS (round((a * b * sin(radians(angle)) / 2), 4));

SELECT round(2.4), round(2.5), round(2.6); -- математическое округление
-- если не уакзан разряд, до кот. нужно вып. округление, то округление производится до десятичной точки

-- округление в большую сторону
SELECT CEILING(-2.9), CEILING(-2.1), CEILING(2.1), CEILING(2.9);

-- округление в меньшую сторону
SELECT floor(-2.9), floor(-2.1), floor(2.1), floor(2.9);

-- Если нужно использовать много условий можно использовать выражение "CASE..END"
DROP TABLE IF EXISTS rainbow;
CREATE TABLE rainbow(
    id serial,
    color varchar(255),
    
    PRIMARY KEY (id)
) comment 'Цвета радуги';

truncate rainbow;
INSERT INTO
    rainbow(color)
VALUES
    ('red'),
    ('orange'),
    ('yellow'),
    ('green'),
    ('blue'),
    ('indigo'),
    ('violet');

SELECT * FROM rainbow;

SELECT
    CASE
        WHEN color = 'red' THEN 'красный'
        WHEN color = 'orange' THEN 'оранжевый'
        WHEN color = 'yellow' THEN 'желтый'
        WHEN color = 'green' THEN 'зелёный'
        WHEN color = 'blue' THEN 'голубой'
        WHEN color = 'indigo' THEN 'синий'
        ELSE 'фиолетовый'
    END AS russian
FROM
    rainbow;

-- Вспомогательные функции
-- функция "INET_ATON" принимает IP-адрес и представляет его в виде целого числа
SELECT inet_aton('62.145.69.10'), inet_aton('127.0.0.1');

-- функция "INET_NTOA" решает обратную задачу
SELECT inet_ntoa('1049707786'), inet_ntoa('2130706433');

-- функция "UUID" возвращает универсальный уникальный идентификатор
-- этот идентификатор реализован в виде числа, кот. является голобально уникальныи во времени и пространстве
SELECT uuid();

/*--------------------------Тема - Агрегация----------------------------*/
/*-------------------Модуль № 1 - Группировка данных.-------------------*/

/*-----------------Модуль № 2 - Агрегационные функции.------------------*/

DROP TABLE IF EXISTS tbl;
CREATE TABLE tbl(
    id int NOT NULL,
    value int DEFAULT NULL
);

SELECT * FROM tbl;

truncate tbl;
INSERT INTO tbl(id, value)
VALUES
    (1, 230),
    (2, NULL),
    (3, 405),
    (4, NULL);

SELECT * FROM tbl;

SELECT
    count(id),
    count(value),
    count(*)
FROM tbl;

/*------------Модуль № 3 - Специальные возможности GROUP BY.------------*/
