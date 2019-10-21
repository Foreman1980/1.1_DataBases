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








