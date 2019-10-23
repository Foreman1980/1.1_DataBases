/*----------------------Создание процедур и функций по материалам урока № 9----------------------*/
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









