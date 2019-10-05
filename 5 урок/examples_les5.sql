-- Воспроизведение материала урока № 5 для закрепления

USE example;

SHOW DATABASES;
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

-- -----------------------МОДУЛЬ № 5-----------------------

/*Использование встроенных функций*/
/*Вычисление расстояния между точками*/

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

/*То же самое с использованием JSON полей*/

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

















