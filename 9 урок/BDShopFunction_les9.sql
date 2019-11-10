/*----------------------Создание процедур и функций по материалам урока № 9----------------------*/

/*-------------------------Тема - Хранимые процедуры и функции, триггеры-------------------------*/
-- Содержание:
-- Модуль № 1 - Хранимые процедуры и функции
-- Модуль № 2 - Параметры, переменные, ветвления
-- Модуль № 3 - Циклы и курсоры
-- Модуль № 4 - Триггеры

/*---------------------------Модуль № 1 - Хранимые процедуры и функции---------------------------*/
-- План занятия:
-- Создание процедур и функций
-- Вызов на выполнение
-- Получение списка
-- Просмотр содержимого
-- Удаление
-- Переназначение признака конца запроса

-- Процедура
DROP PROCEDURE IF EXISTS my_version;

DELIMITER //
CREATE PROCEDURE my_version()
BEGIN
    SELECT version();
END//
DELIMITER ;

DROP PROCEDURE IF EXISTS my_version;

-- Функция
DROP FUNCTION IF EXISTS get_version;

DELIMITER //
CREATE FUNCTION get_version()
RETURNS text DETERMINISTIC
BEGIN
    RETURN version();
END//
DELIMITER ;

DROP FUNCTION IF EXISTS get_version;

-- Функция
DROP FUNCTION IF EXISTS get_version;

DELIMITER //
CREATE FUNCTION get_version()
RETURNS varchar(255) DETERMINISTIC
BEGIN
    RETURN version();
END//
DELIMITER ;

DROP FUNCTION IF EXISTS get_version;

/*-------------------------Модуль № 2 - Параметры, переменные, ветвления-------------------------*/
-- План занятия:
-- Параметры
-- Переменные
-- Команда SET
-- Команда SELECT...INTO...FROM...
-- Операторы IF и CASE

-- Процедура
DROP PROCEDURE IF EXISTS set_x;

DELIMITER //
CREATE PROCEDURE set_x(IN value int)
BEGIN
    SET @x = value;
END//
DELIMITER ;

DROP PROCEDURE IF EXISTS set_x;

-- Процедура
DROP PROCEDURE IF EXISTS set_x;

DELIMITER //
CREATE PROCEDURE set_x(IN value int)
BEGIN
    SET @x = value;
    SET value = value - 1000;
END//
DELIMITER ;

DROP PROCEDURE IF EXISTS set_x;

-- Процедура
DROP PROCEDURE IF EXISTS set_x;

DELIMITER //
CREATE PROCEDURE set_x(OUT value int)
BEGIN
    SET @x = value;
    SET value = 1000;
END//
DELIMITER ;

DROP PROCEDURE IF EXISTS set_x;

-- Процедура
DROP PROCEDURE IF EXISTS set_x;

DELIMITER //
CREATE PROCEDURE set_x(INOUT value int)
BEGIN
    SET @x = value;
    SET value = value - 1000;
END//
DELIMITER ;

DROP PROCEDURE IF EXISTS set_x;

-- Процедура
DROP PROCEDURE IF EXISTS declare_var;

DELIMITER //
CREATE PROCEDURE declare_var()
BEGIN
    DECLARE id, num int(11) DEFAULT 0;
    DECLARE name, hello, temp TINYTEXT;
END//
DELIMITER ;

DROP PROCEDURE IF EXISTS declare_var;

-- Процедура
DROP PROCEDURE IF EXISTS declare_var;

DELIMITER //
CREATE PROCEDURE declare_var()
BEGIN
    DECLARE var TINYTEXT DEFAULT 'внешняя переменная';
    BEGIN
        DECLARE var TINYTEXT DEFAULT 'внутренняя переменная';
        SELECT var;
    END;
    SELECT var;
END//
DELIMITER ;

DROP PROCEDURE IF EXISTS declare_var;

-- Процедура
DROP PROCEDURE IF EXISTS declare_var;

DELIMITER //
CREATE PROCEDURE declare_var()
BEGIN
    DECLARE var TINYTEXT DEFAULT 'внешняя переменная';
    BEGIN
        SELECT var;
    END;
    SELECT var;
END//
DELIMITER ;

DROP PROCEDURE IF EXISTS declare_var;

-- Функция
DROP FUNCTION IF EXISTS second_format;

DELIMITER //
CREATE FUNCTION second_format (seconds int)
RETURNS varchar(255) DETERMINISTIC
BEGIN
    DECLARE days, hours, minutes int;

    SET days = floor(seconds / 86400);
    SET seconds = seconds - days * 86400;
    SET hours = floor(seconds / 3600);
    SET seconds = seconds - hours * 3600;
    SET minutes = floor(seconds / 60);
    SET seconds = seconds - minutes * 60;

    RETURN concat(  days, ' days ',
                    hours, ' hours ',
                    minutes, ' minutes ',
                    seconds, ' seconds ');
END//
DELIMITER ;

DROP FUNCTION IF EXISTS second_format;

-- Процедура
DROP PROCEDURE IF EXISTS numcatalogs;

DELIMITER //
CREATE PROCEDURE numcatalogs(OUT total int)
BEGIN
    SELECT count(*) INTO total FROM catalogs;
END//
DELIMITER ;

DROP PROCEDURE IF EXISTS numcatalogs;

-- Процедура
DROP PROCEDURE IF EXISTS format_date;

DELIMITER //
CREATE PROCEDURE format_date(format char(4))
BEGIN
    IF (format = 'date') THEN
        SELECT date_format(now(), '%d.%m.%Y') AS format_now;
    END IF;
    IF (format = 'time') THEN
        SELECT date_format(now(), '%H:%i:%s') AS format_now;
    END IF;
END//
DELIMITER ;

DROP PROCEDURE IF EXISTS format_date;

-- Процедура
DROP PROCEDURE IF EXISTS format_date;

DELIMITER //
CREATE PROCEDURE format_date(format char(4))
BEGIN
    IF (format = 'date') THEN
        SELECT date_format(now(), '%d.%m.%Y') AS format_now;
    ELSE
        SELECT date_format(now(), '%H:%i:%s') AS format_now;
    END IF;
END//
DELIMITER ;

DROP PROCEDURE IF EXISTS format_date;

-- Процедура
DROP PROCEDURE IF EXISTS format_date;

DELIMITER //
CREATE PROCEDURE format_date(format char(4))
BEGIN
    IF (format = 'date') THEN
        SELECT date_format(now(), '%d.%m.%Y') AS format_now;
    ELSEIF (format = 'time') THEN
        SELECT date_format(now(), '%H:%i:%s') AS format_now;
    ELSE
        SELECT unix_timestamp(now()) AS format_now;
    END IF;
END//
DELIMITER ;

DROP PROCEDURE IF EXISTS format_date;

-- Процедура
DROP PROCEDURE IF EXISTS format_date;

DELIMITER //
CREATE PROCEDURE format_date(format char(4))
BEGIN
    CASE format
        WHEN 'date' THEN
            SELECT date_format(now(), '%d.%m.%Y') AS format_now;
        WHEN 'time' THEN
            SELECT date_format(now(), '%H:%i:%s') AS format_now;
        WHEN 'secs' THEN
            SELECT unix_timestamp(now()) AS format_now;
        ELSE
            SELECT 'Ошибка в параметре format';
    END CASE;
END//
DELIMITER ;

DROP PROCEDURE IF EXISTS format_date;

/*----------------------------------Модуль № 3 - Циклы и курсоры----------------------------------*/
-- План занятия:
-- Циклы
-- Досрочный выход из циклов
-- Обработчики ошибок
-- Курсоры

-- Процедура
DROP PROCEDURE IF EXISTS now3;

DELIMITER //
CREATE PROCEDURE now3()
BEGIN
    DECLARE i int DEFAULT 3;
    WHILE i > 0 do
        SELECT now();
        SET i = i - 1;
    END WHILE;
END//
DELIMITER ;

DROP PROCEDURE IF EXISTS now3;

-- Процедура
DROP PROCEDURE IF EXISTS nowN;

DELIMITER //
CREATE PROCEDURE nowN(IN num int)
BEGIN
    DECLARE i int DEFAULT 0;
    IF (num > 0) THEN
        WHILE i < num do
            SELECT now();
            SET i = i + 1;
        END WHILE;
    ELSE
        SELECT 'Ошибочное значение параметра';
    END IF;
END//
DELIMITER ;

DROP PROCEDURE IF EXISTS nowN;

-- Процедура
DROP PROCEDURE IF EXISTS nowN;

DELIMITER //
CREATE PROCEDURE nowN(IN num int)
BEGIN
    DECLARE i int DEFAULT 0;
    IF (num > 0) THEN
        circle: WHILE i < num do
            IF i >= 2 THEN LEAVE circle;
            END IF;
            SELECT now();
            SET i = i + 1;
        END WHILE circle;
    ELSE
        SELECT 'Ошибочное значение параметра';
    END IF;
END//
DELIMITER ;

DROP PROCEDURE IF EXISTS nowN;

-- Процедура
DROP PROCEDURE IF EXISTS numbers_string;

DELIMITER //
CREATE PROCEDURE numbers_string(IN num int)
BEGIN
    DECLARE i int DEFAULT 0;
    DECLARE bin TINYTEXT DEFAULT '';
    IF (num > 0) THEN
        circle: WHILE i < num do
            SET i = i + 1;
            SET bin = concat(bin, i);
            IF i > CEILING(num / 2) THEN ITERATE circle;
            END IF;
            SET bin = concat(bin, i);
        END WHILE circle;
        SELECT bin;
    ELSE
        SELECT 'Ошибочное значение параметра';
    END IF;
END//
DELIMITER ;

DROP PROCEDURE IF EXISTS numbers_string;

-- Процедура
DROP PROCEDURE IF EXISTS now3;

DELIMITER //
CREATE PROCEDURE now3()
BEGIN
    DECLARE i int DEFAULT 3;
    REPEAT
        SELECT now();
        SET i = i - 1;
    until i <= 0
    END REPEAT;
END//
DELIMITER ;

DROP PROCEDURE IF EXISTS now3;

-- Процедура
DROP PROCEDURE IF EXISTS now3;

DELIMITER //
CREATE PROCEDURE now3()
BEGIN
    DECLARE i int DEFAULT 3;
    circle: LOOP
        SELECT now();
        SET i = i - 1;
        IF i <= 0 THEN LEAVE circle;
        END IF;
    END LOOP circle;
END//
DELIMITER ;

DROP PROCEDURE IF EXISTS now3;

-- Процедура
DROP PROCEDURE IF EXISTS insert_to_catalog;

DELIMITER //
CREATE PROCEDURE insert_to_catalog (IN id int, IN name varchar(255))
BEGIN
    DECLARE CONTINUE handler FOR SQLSTATE '23000' SET @error = 'Ошибка вставки значения';
    INSERT INTO catalogs VALUES (id, name);
    IF @error IS NOT NULL THEN
        SELECT @error;
    END IF;
END//
DELIMITER ;

DROP PROCEDURE IF EXISTS insert_to_catalog;

-- Процедура
DROP PROCEDURE IF EXISTS copy_catalogs;

DELIMITER //
CREATE PROCEDURE copy_catalogs ()
BEGIN
    DECLARE id int;
    DECLARE is_end int DEFAULT 0;
    DECLARE name TINYTEXT;

    DECLARE curcat CURSOR FOR SELECT * FROM catalogs;
    DECLARE CONTINUE handler FOR NOT FOUND SET is_end = 1;

    OPEN curcat;
    
    circle: LOOP
        FETCH curcat INTO id, name;
        IF is_end THEN LEAVE circle;
        END IF;
        INSERT INTO upcase_catalogs VALUES (id, upper(name));
    END LOOP circle;

    CLOSE curcat;    

END//
DELIMITER ;

DROP PROCEDURE IF EXISTS copy_catalogs;
