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

ROLLBACK;

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

-- запрос параметров Журнала транзакций
SHOW variables LIKE 'innodb_log_%';
-- Журнал транзакций имеет два файла, размером по 50 Мб

-- Файлы Журнала транзакций находятся в каталоге данных
-- Получить путь к вашему каталогу данных можно с пом. след. запроса:
SHOW variables LIKE 'datadir';

-- InnoDB хранит таблицы всех баз данных в едином табличном пространстве, в файле "ibdata1"
-- Физически единое табличное пространство может располагаться в неск. файлах, более того, мы можем выделить отдельное
-- табличное пространство под каждую из таблиц

-- Транзакции помещаются в файлы Журнала транзакций "ib_logfile0" и "ib_logfile1" и потом перегоняются в "ibdata1"

-- Управление режимом сохранения журнала транзакций (за этот режим отвечает серверная переменная "innodb_flush_log_at_trx_commit"):
-- 0 - сохранение журнала раз в секунду
-- 1 - сохранение после каждой транзакции
-- 2 - сохранение журнала раз в секунду и после каждой транзакции
SHOW variables LIKE 'innodb_flush_log_at_trx_commit';

-- Давайте установим режим сохранения журнала транзакций на "раз в секунду":
SET GLOBAL innodb_flush_log_at_trx_commit = 0;
SHOW variables LIKE 'innodb_flush_log_at_trx_commit';

-- MVCC - многоверсионное управление конкурентным доступом
-- MVCC работает только на 2 и 3 уровнях изоляции ("READ COMITTED" и "REPEATABLE READ")

/*---------------Модуль № 3 - Переменные, временные таблицы и динамические запросы---------------*/
-- План занятия:
-- Пользовательские переменные
-- Системные переменные
-- Временные таблицы
-- Динамические запросы

-- Часто результаты запросов необходимо использовать я в последующих запросах, для этого полученные данные следует
-- сохранить во временных структурах. Эту задачу решают переменные SQL
-- объявление переменной начинается с символа алев "@", за которым следует имя переменной
SELECT @total := count(*) FROM products;
-- переменная будет доступна только в текущей сессии
SELECT @total;

/*-------------------------Извлечь товарную позицию с самой высокой ценой-------------------------*/
SELECT @max_price := max(price) FROM products;
SELECT name
FROM products
WHERE price = @max_price;

-- Если переменной присваивается значение столбца содержащего множество значений, переменной присвоится последнее
-- значение
SELECT @id := id FROM products;
SELECT @id;

-- Имена переменных не чувствительны к регистру
SELECT @id := 5, @ID := 3;
SELECT @id, @ID;

-- переменные также могу объявляться при помощи команды "SET". Команда "SET", в отличии от "SELECT" не возвращает
-- результирующую таблицу
SET @last := now() - INTERVAL 7 DAY;
SELECT curdate(), @last;

-- Чтобы получить полный список системных переменных, можно воспользоваться оператором "SHOW VARIABLES"
SHOW VARIABLES\G; -- с "\G" работает только в консоли
SHOW VARIABLES;

-- чтобы отфильтровать большое количество переменных можно использовать ключевое слово "LIKE"
SHOW VARIABLES LIKE 'read_buffer_size';

-- Сервер MySQL поддерживает два типа системных переменных:
-- GLOBAL - глобальные - влияют на весь сервер
-- SESSION - сеансовые - влияют на текущее соединение клиента с сервером

-- При старте сервера происходит инициализация глобальных переменных значениями по-умолчанию, оператор "SET" позволяет
-- изменять значение глобальных переменных уже после старта

-- Для этого перед именем переменной устанавливается ключевое слово "GLOBAL"
SET GLOBAL read_buffer_size = 2097152;

-- Вместо ключевого слова "GLOBAL" можно перед названием переменной указывать два символа @@
SET @@read_buffer_size = 2097152;

-- Кроме глобальных переменных сервер MySQL поддерживает набор сеансовых переменных для каждого соединения клиента
-- с сервером

-- При установке соединения с сервером, сеансовые переменные получают значения заданные для глобальных переменных,
-- однако Клиент, при помощи оператора "SET" может выставлять новые значения
SET SESSION read_buffer_size = 2097152;
-- действие такой переменной будет отражаться только на текущее соединение, не затрагивая соседних клиентов
-- существует альтернативная форма задания сессионных переменных
SET @@session.read_buffer_size = 2097152;

-- чтобы установить локальной переменной значение глобальной, достаточно присвоить локальной переменной ключевое слово
-- "DEFAULT"
SET read_buffer_size = DEFAULT;

-- Временная таблица автоматически удаляется при завершении соединения с сервером, а её имя действительно только в
-- течении данного соединения
-- CREATE TEMPORARY TABLE temp (id int, name varchar(255));
-- 
-- SHOW tables;
-- 
-- DESCRIBE temp;
-- 
-- Временные таблицы храняться в специальном табличном пространстве "ibtmp1"

-- Динамические запросы, это запросы, которые пользователи могут сохранять подобно переменным под конкретным именем и
-- вызывать позже в течении сессии
-- Для объявления динамического запроса используется команда "PREPARE"
PREPARE ver FROM 'SELECT VERSION()';

-- Выполняется такой динамический запрос при помощи команды "EXECUTE"
EXECUTE ver;

-- Если необходимо, чтобы динамический запрос существовал более длительное время, необходимо прибегнуть к
-- представлениям

-- Динамический запрос можно параметризовать
PREPARE prd FROM '  SELECT id, name, price
                    FROM products
                    WHERE catalog_id = ?'

SET @catalog_id := 1;

EXECUTE prd USING @catalog_id;

-- Динамический запрос может иметь более одного параметра, в таком случае они перечисляются через запятую, в том
-- порядке, в котором они встречаются в динамическом запросе
-- Динамический запрос всегда представляет собой лишь один запрос (вложенные динамич. запросы не допускаются)

-- Удалить динамический запрос можно при помощи оператора "DROP PREPARE"
DROP PREPARE prd;

/*-----------------------------------Модуль № 4 - Представления-----------------------------------*/
-- План занятия:
-- Создание представлений
-- Вертикальные и горизонтальные представления
-- Вставка записей в представление
-- Обновление представлений
-- Управление представлениями

-- Представление это запрос на выборку, которому присваивается уникальное имя и которые можно сохранять и удалять из БД
-- как обычную таблицу. Представления позволяют увидеть результат запроса таким образом, как будто это полноценная
-- таблица БД. Они позволяют более гибко управлять правами доступа к таблицам, также можно запретить прямое обращение
-- пользователей к таблицам и разрешить их только к представлениям

/*Создадим представление для таблицы "catalogs", в кот. записи будут поддерживаться в отсортированном состоянии*/

SELECT *
FROM catalogs;

-- Для создания представления используется программа "CREATE VIEW"
CREATE VIEW cat AS SELECT * FROM catalogs ORDER BY name; 

-- К представлению мы можем обращаться как к обычной таблице

SELECT * FROM cat;

-- Представления рассматриваются MySQL как полноценная таблица
SHOW TABLES;

CREATE VIEW cat_reverse(`catalog`, catalog_id) AS
SELECT name, id FROM catalogs;

SELECT *
FROM cat_reverse;

CREATE OR REPLACE VIEW namecat (id, name, total) AS
SELECT id, name, LENGTH(name) FROM catalogs;

SELECT *
FROM namecat
ORDER BY total DESC;

-- Алгоритм формирования конечного запроса
-- MERGE        -   запрос объединяется с представлением таким образом, что представление заменяет собой
--                  соответствующие части в запросе
-- TEMPTABLE    -   результирующая таблица представления помещается во временную таблицу, кот. затем используется в
--                  конечном запросе
-- UNDEFINED    -   СУБД MySQL самостоятельно пытается выбрать алгоритм, предпочитая использовать подход "MERGE" и
--                  прибегая к алгоритму "TEMPTABLE" только в случае необходимости
-- если ни одно из значений алгоритма не указано, по-умолчанию используется "UNDEFINED"

CREATE algorithm = temptable VIEW cat2 AS SELECT * FROM catalogs;
-- в созданном представлении мы требуем от MySQL при каждом обращении к представлению создавать временную таблицу

-- Следует отметить, что представления способны скрывать ряд столбцов за счёт того, что в SELECT-запросе могут
-- извлекаться не все столбцы таблицы. Такие представления называются "вертикальными"
DESCRIBE products;
CREATE OR REPLACE VIEW prod AS
SELECT id, name, price, catalog_id
FROM products
ORDER BY catalog_id, name;

SELECT *
FROM prod;

SELECT *
FROM prod
ORDER BY name DESC;

-- На ряду с "вертикальными" представлениями используются "горизонтальные"

/*-------Создадим представление, которое извлекает из таблицы "products" только процессоры-------*/
CREATE OR REPLACE VIEW processors AS
SELECT id, name, price, catalog_id
FROM products
WHERE catalog_id = 1;

SELECT *
FROM processors;

SHOW tables;

-- В реальной практике могут встречаться смешанные представления, кот. ограничивают таблицу и по горизонтали и по
-- вертикали

-- Для того чтобы в представления можно было вставлять записи при помощи команды "INSERT" и обновлять существующие
-- записи при помощи команды "UPDATE", необходимо при создании представления использовать конструкцию "WITH CHECK
-- OPTION"
-- 
-- CREATE VIEW v1 AS
-- SELECT *
-- FROM tbl1
-- WHERE value < 'fst5'
-- WITH CHECK OPTION;
-- 
-- -- давайте попробуем вставить запись
-- INSERT INTO v1
-- VALUES ('fst4');
-- 
-- -- однако при попытке вставить значение 'fst5' срабатывает ограничение "WHERE"-условия
-- INSERT INTO v1
-- VALUES ('fst5');
-- 
-- -- Отредактировать представление можно при помощи команды "ALTER"
-- ALTER VIEW v1 AS
-- SELECT *
-- FROM tbl1
-- WHERE value > 'fst4'
-- WITH CHECK OPTION;
-- 
-- -- либо
-- CREATE OR REPLACE VIEW v1 AS
-- SELECT *
-- FROM tbl1
-- WHERE value > 'fst4'
-- WITH CHECK OPTION;
-- 
-- эти две команды эквивалентны

-- Для удаления представления существует команда "DROP VIEW"
DROP VIEW cat, cat_reverse, namecat, prod, processors;

-- При попытке удаления несуществующего представления возникает ошибка, для избежания этого используется конструкция
-- "IF EXISTS"
DROP VIEW IF EXISTS cat, cat_reverse, namecat, prod, processors;

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

-- Создание процедур и функций
-- CREATE PROCEDURE procedure_name
-- CREATE FUNCTION function_name

-- различаются тем, что функции возвращают значение и их можно встраивать в SQL-запросы, а процедуры вызываются явно
-- отдельной командой "CALL"

-- Создание процедуры см. в файле "BDShopFunction_les9.sql"
-- DELIMITER //
-- CREATE PROCEDURE my_version()
-- BEGIN
--     SELECT version();
-- END//
-- DELIMITER ;

CALL my_version();

SHOW PROCEDURE status LIKE 'my_version%';

-- все процедуры и функции хранятся в таблице "proc" БД mysql
SELECT name, TYPE FROM mysql.proc LIMIT 10;
-- не сработало, т.к. у меня нет табл. "proc" в БД "mysql"...

-- После того как процедура создана, посмотреть её содержимое можно при помощи команды
SHOW CREATE PROCEDURE my_version;

-- для удаления процедур и функций предназначены операторы
-- DROP PROCEDURE procedure_name
-- DROP FUNCTION function_name

DROP PROCEDURE my_version;

-- попытка удаления несуществующей хранимой процедуры вызовет ошибку

-- для избежания ошибок допускается использование конструкции "IF EXISTS"
DROP PROCEDURE IF EXISTS my_version;

-- Создание функции см. в файле "BDShopFunction_les9.sql"
-- DELIMITER //
-- CREATE FUNCTION get_version()
-- RETURNS text DETERMINISTIC
-- BEGIN
--     RETURN version();
-- END//
-- DELIMITER ;

-- ключевое слово "RETURNS" указывает возвращаемый тип, в данном случае "text", но мы можем его заменить
-- Создание функции см. в файле "BDShopFunction_les9.sql"
-- DELIMITER //
-- CREATE FUNCTION get_version()
-- RETURNS varchar(255) DETERMINISTIC
-- BEGIN
--     RETURN version();
-- END//
-- DELIMITER ;

-- ключевое слово "DETERMINISTIC" означает, что результат функции детерминирован, т.е. при каждом вызове функции будет
-- возвращаться одно и тоже значение

-- если значения, которые возвращает функция каждый раз различны, то перед "DETERMINISTIC" следует добавить отрицание
-- "NOT"

-- внутри тела функции обязательно должно быть ключевое слово "RETURN", кот. возвращает результат вычисления

-- для вызова функции используется оператор "SELECT"
SELECT get_version();

/*-------------------------Модуль № 2 - Параметры, переменные, ветвления-------------------------*/
-- План занятия:
-- Параметры
-- Переменные
-- Команда SET
-- Команда SELECT...INTO...FROM...
-- Операторы IF и CASE

-- Хранимые процедуры и функции могут использовать параметры
-- Типы параметров (для процедур):
-- IN - данные передаются строго внутрь хранимой процедуры - используется по-умолчанию
-- OUT - данные передаются строго из хранимой процедуры
-- INOUT - данные передаются как внутрь, так и наружу хранимой процедуры

-- Создание процедуры см. в файле "BDShopFunction_les9.sql"
-- DELIMITER //
-- CREATE PROCEDURE set_x(IN value int)
-- BEGIN
--     SET @x = value;
-- END//
-- DELIMITER ;

CALL set_x(123456);
SELECT @x;

-- Создание процедуры см. в файле "BDShopFunction_les9.sql"
-- DELIMITER //
-- CREATE PROCEDURE set_x(IN value int)
-- BEGIN
--     SET @x = value;
--     SET value = value - 1000;
-- END//
-- DELIMITER ;

SET @y = 10000;
CALL set_x(@y);
SELECT @x, @y;
-- несмотря на то, что переменная "@y" подставилась вместо "value", изменение параметра "value" внутри процедуры не
-- отразилось на значении переменной "@y"
-- если требуется чтобы значение переменной подвергалось изменению, необходимо объявить параметр процедуры с
-- модификатором "OUT"

-- Создание процедуры см. в файле "BDShopFunction_les9.sql"
-- DELIMITER //
-- CREATE PROCEDURE set_x(OUT value int)
-- BEGIN
--     SET @x = value;
--     SET value = 1000;
-- END//
-- DELIMITER ;

SET @y = 10000;
CALL set_x(@y);
SELECT @x, @y;

-- Создание процедуры см. в файле "BDShopFunction_les9.sql"
-- DELIMITER //
-- CREATE PROCEDURE set_x(INOUT value int)
-- BEGIN
--     SET @x = value;
--     SET value = value - 1000;
-- END//
-- DELIMITER ;

SET @y = 10000;
CALL set_x(@y);
SELECT @x, @y;

# локальные переменные

-- Создание процедуры см. в файле "BDShopFunction_les9.sql"
-- DELIMITER //
-- CREATE PROCEDURE declare_var()
-- BEGIN
--     DECLARE id, num int(11) DEFAULT 0;
--     DECLARE name, hello, temp TINYTEXT;
-- END//
-- DELIMITER ;

-- Команда "DECLARE" может появляться только внутри блока "BEGIN...END", область видимости переменных также ограничена
-- этим блоком. Это означает, что в разных блоках "BEGIN...END" могут быть объявлены переменные с одинаковым именем и
-- действовать они будут только в рамках данного блока, не пересекаясь с переменными других блоков. Однако переменная,
-- объявленные во внешнем блоке "BEGIN...END" будет доступна и во вложенном блоке

-- Создание процедуры см. в файле "BDShopFunction_les9.sql"
-- DELIMITER //
-- CREATE PROCEDURE declare_var()
-- BEGIN
--     DECLARE var TINYTEXT DEFAULT 'внешняя переменная';
--     BEGIN
--         DECLARE var TINYTEXT DEFAULT 'внутренняя переменная';
--         SELECT var;
--     END;
--     SELECT var;
-- END//
-- DELIMITER ;

-- кроме ключевого слова "DEFAULT", которое позволяет присваивать значение переменной при её объявлении, существует ещё
-- два способа инициализации переменных. Инициализация переменных:
-- SET
-- SELECT...INTO...FROM - специальный синтаксис команды селект

-- Использование команды SET
SET @var = 100;
SET @var = @var + 1;
 
-- Использование команды SELECT...INTO
-- SELECT
--     id, `data`
-- INTO
--     @x, @y
-- FROM test;

-- Пример использования команды "SET":
-- Создание функции см. в файле "BDShopFunction_les9.sql"
-- DELIMITER //
-- CREATE FUNCTION second_format (seconds int)
-- RETURNS varchar(255) DETERMINISTIC
-- BEGIN
--     DECLARE days, hours, minutes int;
-- 
--     SET days = floor(seconds / 86400);
--     SET seconds = seconds - days * 86400;
--     SET hours = floor(seconds / 3600);
--     SET seconds = seconds - hours * 3600;
--     SET minutes = floor(seconds / 60);
--     SET seconds = seconds - minutes * 60;
-- 
--     RETURN concat(  days, ' days ',
--                     hours, ' hours ',
--                     minutes, ' minutes ',
--                     seconds, ' seconds ');
-- END//
-- DELIMITER ;

-- Пример использовани команды "SELECT...INTO":
-- Создание процедуры см. в файле "BDShopFunction_les9.sql"
-- DELIMITER //
-- CREATE PROCEDURE numcatalogs(OUT total int)
-- BEGIN
--     SELECT count(*) INTO total FROM catalogs;
-- END//
-- DELIMITER ;

CALL numcatalogs(@a);
SELECT @a;

-- Оператор "IF" позволяет реализовать ветвление программ по условию
-- Создание процедуры см. в файле "BDShopFunction_les9.sql"
-- DELIMITER //
-- CREATE PROCEDURE format_date(format char(4))
-- BEGIN
--     IF (format = 'date') THEN
--         SELECT date_format(now(), '%d.%m.%Y') AS format_now;
--     END IF;
--     IF (format = 'time') THEN
--         SELECT date_format(now(), '%H:%i:%s') AS format_now;
--     END IF;
-- END//
-- DELIMITER ;

CALL format_date('date');
CALL format_date('time');

-- Конструкция "IF...ELSE"
-- Создание процедуры см. в файле "BDShopFunction_les9.sql"
-- DELIMITER //
-- CREATE PROCEDURE format_date(format char(4))
-- BEGIN
--     IF (format = 'date') THEN
--         SELECT date_format(now(), '%d.%m.%Y') AS format_now;
--     ELSE
--         SELECT date_format(now(), '%H:%i:%s') AS format_now;
--     END IF;
-- END//
-- DELIMITER ;

CALL format_date('date');
CALL format_date('tttt');

-- Конструкция "IF...ELSEIF...ELSE"
-- Создание процедуры см. в файле "BDShopFunction_les9.sql"
-- DELIMITER //
-- CREATE PROCEDURE format_date(format char(4))
-- BEGIN
--     IF (format = 'date') THEN
--         SELECT date_format(now(), '%d.%m.%Y') AS format_now;
--     ELSEIF (format = 'time') THEN
--         SELECT date_format(now(), '%H:%i:%s') AS format_now;
--     ELSE
--         SELECT unix_timestamp(now()) AS format_now;
--     END IF;
-- END//
-- DELIMITER ;

CALL format_date('date');
CALL format_date('time');
CALL format_date('secs');

-- Для множественного выбора в MySQL предназначен оператор "CASE"
-- Создание процедуры см. в файле "BDShopFunction_les9.sql"
-- DELIMITER //
-- CREATE PROCEDURE format_date(format char(4))
-- BEGIN
--     CASE format
--         WHEN 'date' THEN
--             SELECT date_format(now(), '%d.%m.%Y') AS format_now;
--         WHEN 'time' THEN
--             SELECT date_format(now(), '%H:%i:%s') AS format_now;
--         WHEN 'secs' THEN
--             SELECT unix_timestamp(now()) AS format_now;
--         ELSE
--             SELECT 'Ошибка в параметре format';
--     END CASE;
-- END//
-- DELIMITER ;

CALL format_date('date');
CALL format_date('time');
CALL format_date('secs');
CALL format_date('ssss');

/*----------------------------------Модуль № 3 - Циклы и курсоры----------------------------------*/
-- План занятия:
-- Циклы
-- Досрочный выход из циклов
-- Обработчики ошибок
-- Курсоры

-- Циклы:
-- WHILE
-- REPEAT
-- LOOP

-- Оператор цикла "WHILE"
-- Создание процедуры см. в файле "BDShopFunction_les9.sql"
-- DELIMITER //
-- CREATE PROCEDURE now3()
-- BEGIN
--     DECLARE i int DEFAULT 3;
--     WHILE i > 0 do
--         SELECT now();
--         SET i = i - 1;
--     END WHILE;
-- END//
-- DELIMITER ;

CALL now3;

-- количество повторов не обязательно задавать внутри хранимой процедуры, например мы можем задать его в качестве
-- входящего параметра
-- Создание процедуры см. в файле "BDShopFunction_les9.sql"
-- DELIMITER //
-- CREATE PROCEDURE nowN(IN num int)
-- BEGIN
--     DECLARE i int DEFAULT 0;
--     IF (num > 0) THEN
--         WHILE i < num do
--             SELECT now();
--             SET i = i + 1;
--         END WHILE;
--     ELSE
--         SELECT 'Ошибочное значение параметра';
--     END IF;
-- END//
-- DELIMITER ;

CALL `nowN`(2);

-- Для досрочного выхода из цикла предназначен оператор "LEAVE"
-- Давайте ограничим цикл в процедуре "nowN()" только двумя итерациями, т.е. какое бы значение пользователь не
-- закладывал, максимальное количество, которое будет доступно это вывод двух дат
-- Создание процедуры см. в файле "BDShopFunction_les9.sql" (строка 312)
-- DELIMITER //
-- CREATE PROCEDURE nowN(IN num int)
-- BEGIN
--     DECLARE i int DEFAULT 0;
--     IF (num > 0) THEN
--         circle: WHILE i < num do
--             IF i >= 2 THEN LEAVE circle;
--             END IF;
--             SELECT now();
--             SET i = i + 1;
--         END WHILE circle;
--     ELSE
--         SELECT 'Ошибочное значение параметра';
--     END IF;
-- END//
-- DELIMITER ;

CALL `nowN`(1000);

-- Ещё одним оператором осуществляющим досрочное прекращение цикла является оператор "ITERATE", в отличии от оператора
-- "LEAVE" оператор "ITERATE" не полностью прекращает выполнение цикла, а лишь выполняет досрочное прекращение текущей
-- итерации
-- Создание процедуры см. в файле "BDShopFunction_les9.sql" (строка 334)
-- DELIMITER //
-- CREATE PROCEDURE numbers_string(IN num int)
-- BEGIN
--     DECLARE i int DEFAULT 0;
--     DECLARE bin TINYTEXT DEFAULT '';
--     IF (num > 0) THEN
--         circle: WHILE i < num do
--             SET i = i + 1;
--             SET bin = concat(bin, i);
--             IF i > CEILING(num / 2) THEN ITERATE circle;
--             END IF;
--             SET bin = concat(bin, i);
--         END WHILE circle;
--         SELECT bin;
--     ELSE
--         SELECT 'Ошибочное значение параметра';
--     END IF;
-- END//
-- DELIMITER ;

CALL numbers_string(9);

-- Оператор цикла "REPEAT"
-- Оператор "REPEAT" похож на оператор "WHILE", однако условие для покидания цикла располагается не в начале тела
-- цикла, а в конце. В результате тело цикла в любом случае выполняется хотя бы один раз
-- Создание процедуры см. в файле "BDShopFunction_les9.sql" (строка 359)
-- DELIMITER //
-- CREATE PROCEDURE now3()
-- BEGIN
--     DECLARE i int DEFAULT 3;
--     REPEAT
--         SELECT now();
--         SET i = i - 1;
--     until i <= 0
--     END REPEAT;
-- END//
-- DELIMITER ;

CALL now3();

-- Цикл "LOOP" в отличии от операторов "WHILE" и "REPEAT" не имеет условия выхода, поэтому данный вид цикла всегда
-- должен иметь в своём составе оператор "LEAVE"
-- Создание процедуры см. в файле "BDShopFunction_les9.sql" (строка 376)
-- DELIMITER //
-- CREATE PROCEDURE now3()
-- BEGIN
--     DECLARE i int DEFAULT 3;
--     circle: LOOP
--         SELECT now();
--         SET i = i - 1;
--         IF i <= 0 THEN LEAVE circle;
--         END IF;
--     END LOOP circle;
-- END//
-- DELIMITER ;

CALL now3();

-- Обработчики ошибок

-- Попробуем вставить в таблицу "catalogs" запись с идентификатором 1
INSERT INTO catalogs VALUES(1, 'Процессоры');
-- получили ошибку "SQL Error [1062] [23000]: Duplicate entry '1' for key 'PRIMARY'"
-- Данную ошибку можно обработать с пом. конструкции "DECLARE...HANDLER FOR". Данная команда может появляться только
-- в теле хранимых процедур и функций 
-- Создание процедуры см. в файле "BDShopFunction_les9.sql" (строка 396)
-- DELIMITER //
-- CREATE PROCEDURE insert_to_catalog (IN id int, IN name varchar(255))
-- BEGIN
--     DECLARE CONTINUE handler FOR SQLSTATE '23000' SET @error = 'Ошибка вставки значения';
--     INSERT INTO catalogs VALUES (id, name);
--     IF @error IS NOT NULL THEN
--         SELECT @error;
--     END IF;
-- END//
-- DELIMITER ;

CALL insert_to_catalog(1, 'Процессоры');

-- Курсоры

-- Если результирующий запрос возвращает одну запись, поместить результаты в локальную переменную можно при помощи
-- конструкции "SELECT...INTO...FROM"
-- DELIMITER //
-- CREATE PROCEDURE catalog_id(OUT total int)
-- BEGIN
--     SELECT id INTO total FROM catalogs;
-- END//
-- DELIMITER ;
-- однако результирующие таблицы чаще содержат несколько записей, тогда запрос "SELECT id INTO total FROM catalogs;"
-- вызовет ошибку. Можно добавить "LIMIT 1" или назначить обработчик ошибок, но чаще всего нужно обработать именно
-- многострочную результирующую таблицу. Решить эту задачу можно с помощью курсоров

/*--------------Создадим копию таблицы catalogs с наименованиями в верхнем регистре--------------*/
DROP TABLE IF EXISTS upcase_catalogs;
CREATE TABLE upcase_catalogs(
    id serial,
    name VARCHAR(255) comment 'Название раздела',
    
    PRIMARY KEY(id),
    UNIQUE unique_name(name(10))
) comment = 'Разделы интернет-магазина';

-- Создание процедуры см. в файле "BDShopFunction_les9.sql" (строка 412)
-- DELIMITER //
-- CREATE PROCEDURE copy_catalogs ()
-- BEGIN
--     DECLARE id int;
--     DECLARE is_end int DEFAULT 0;
--     DECLARE name TINYTEXT;
-- 
--     DECLARE curcat CURSOR FOR SELECT * FROM catalogs;
--     DECLARE CONTINUE handler FOR NOT FOUND SET is_end = 1;
-- 
--     OPEN curcat;
--     
--     circle: LOOP
--         FETCH curcat INTO id, name;
--         IF is_end THEN LEAVE circle;
--         END IF;
--         INSERT INTO upcase_catalogs VALUES (id, upper(name));
--     END LOOP circle;
-- 
--     CLOSE curcat;    
-- 
-- END//
-- DELIMITER ;

CALL copy_catalogs();

SELECT * FROM upcase_catalogs;
DROP TABLE IF EXISTS upcase_catalogs;

/*-------------------------------------Модуль № 4 - Триггеры-------------------------------------*/
-- План занятия:
-- Транзакции
-- Ключевые слова COMMIT и ROLLBACK
-- Точки сохранения
-- Режим автозавершения транзакций
-- Принцип ACID
-- Уровни изоляции

-- Пример использования триггера из документации MySQL (https://dev.mysql.com/doc/refman/8.0/en/trigger-syntax.html)
-- CREATE TABLE test1(a1 INT);
-- 
-- CREATE TABLE test4(
--   a4 INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
--   b4 INT DEFAULT 0
-- );
-- 
-- delimiter |
-- 
-- CREATE TRIGGER testref AFTER INSERT ON test1
--   FOR EACH ROW
--   BEGIN
--     UPDATE test4 SET b4 = b4 + 1 WHERE a4 = NEW.a1;
--   END;
-- |
-- 
-- delimiter ;
-- 
-- truncate test4;
-- INSERT INTO test4 (a4) VALUES
--   (0), (0), (0), (0), (0), (0), (0), (0), (0), (0);
--   
-- SELECT * FROM test1;
-- SELECT * FROM test4;
-- 
-- truncate test1;
-- INSERT INTO test1 VALUES 
--        (1), (3), (1), (7), (1), (8), (4), (4);
--  
-- SELECT * FROM test1;
-- SELECT * FROM test4;
-- 
-- DROP TRIGGER testref;
-- DROP TABLE test1;
-- DROP TABLE test4;
-- 
-- SHOW triggers;
