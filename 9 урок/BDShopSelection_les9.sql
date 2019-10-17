/*---------------------------Отработка запросов по материалам урока № 9---------------------------*/

/*--------------------------Тема - Транзакции, переменные, представления--------------------------*/
-- Содержание:
-- Модуль № 1 - Транзакции
-- Модуль № 2 - Внутренняя реализация транзакций
-- Модуль № 3 - Переменные, временные таблицы и динамические запросы
-- Модуль № 4 - Представления

/*------------------------------------Модуль № 1 - Транзакции------------------------------------*/
-- План занятия:
-- Транзакции
-- Ключевые слова COMMIT и ROLLBACK
-- Точки сохранения
-- Режим автозавершения транзакций
-- Принцип ACID
-- Уровни изоляции

USE shop;

SELECT id, user_id, total
FROM accounts;

START TRANSACTION;
SELECT total FROM accounts WHERE user_id = 4;

UPDATE accounts
SET total = total - 2000.00
WHERE user_id = 4;

UPDATE accounts
SET total = total + 2000.00
WHERE user_id IS NULL;

-- проверил через терминал, пока таблица accounts не изменилась

COMMIT;

-- магия..., теперь изменилась

-- мы так же можем отменять транзакцию

START TRANSACTION;
SELECT total FROM accounts WHERE user_id = 4;

UPDATE accounts
SET total = total - 2000.00
WHERE user_id = 4;

UPDATE accounts
SET total = total + 2000.00
WHERE user_id IS NULL;

ROLLBACK;

-- проверил через терминал, таблица accounts не изменилась

-- Необратимые команды
-- CREATE INDEX
-- DROP INDEX
-- CREATE TABLE
-- DROP TABLE
-- truncate TABLE
-- ALTER TABLE
-- RENAME TABLE
-- CREATE DATABASE
-- DROP DATABASE
-- ALTER DATABASE

-- следует избегать помещать их в транзакции с другими операторами

Неявное завершение транзакций
-- CREATE INDEX
-- DROP INDEX
-- CREATE TABLE
-- DROP TABLE
-- truncate TABLE
-- ALTER TABLE
-- RENAME TABLE
-- CREATE DATABASE
-- DROP DATABASE
-- BEGIN
-- LOAD master DATA
-- LOCK TABLES
-- RENAME
-- SET autocommit=1
-- START TRANSACTION

START TRANSACTION;
SELECT total FROM accounts WHERE user_id = 4;

SAVEPOINT accounts_4;

UPDATE accounts
SET total = total - 2000.00
WHERE user_id = 4;

ROLLBACK TO SAVEPOINT accounts_4;

-- MySQL по-умолчанию работает в режиме автозавершения транзакций, в этом случае любая последовательность команд
-- будет восприниматься как транзакция

SET autocommit=0;

SELECT total FROM accounts WHERE user_id = 4;

UPDATE accounts
SET total = total - 2000.00
WHERE user_id = 4;

UPDATE accounts
SET total = total + 2000.00
WHERE user_id IS NULL;

SELECT id, user_id, total
FROM accounts;

-- чтобы сохранить изменения требуется ввести команду "COMMIT"

COMMIT;

SET autocommit=1;

-- Транзакции должны удовлетворять принципам ACID
-- Atomicy - атомарность
-- Consistency - согласованность
-- Isolation - изолированность
-- Durability - сохраняемость

-- Уровни изоляции (от слабого к более сильному уровню изоляции):
-- READ UNCOMMITTED
-- READ COMITTED
-- REPEATABLE READ - в MySQL по-умолчанию
-- SERIALIZABLE

-- Изменить уровень изоляции можно с помощью команды
-- SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

/*-------------------------Модуль № 2 - Внутренняя реализация транзакций-------------------------*/
-- План занятия:
-- Взаимоблокировка
-- Журнал транзакций
-- Управление режимом сохранения транзакций
-- MVCC
-- Связь MVCC с уровнями изоляции









