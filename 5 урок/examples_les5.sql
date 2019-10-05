-- Воспроизведение материала урока № 5 для закрепления

USE shop;

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





