/* Практическое задание к уроку № 3 по теме “Введение в проектирование БД”
 * 
 * 1. Проанализировать структуру БД vk, которую мы создали на занятии, и внести предложения по
 * усовершенствованию (если такие идеи есть). Напишите пожалуйста, всё-ли понятно по
 * структуре.
 * 2. Добавить необходимую таблицу/таблицы для того, чтобы можно было использовать лайки для
 * медиафайлов, постов и пользователей.
 * 3. Используя сервис http://filldb.info или другой по вашему желанию, сгенерировать тестовые
 * данные для всех таблиц, учитывая логику связей. Для всех таблиц, где это имеет смысл,
 * создать не менее 100 строк. Создать локально БД vk и загрузить в неё тестовые данные. */

-- Воспроизведение инфраструктуры БД "vk" из Урока № 3.

-- Содание БД "vk":

DROP DATABASE IF EXISTS vk;
CREATE DATABASE vk;
USE vk;

-- Создание таблицы с пользователями:

DROP TABLE IF EXISTS users;
CREATE TABLE users(
	id serial, -- SERIAL = BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE
	first_name varchar(100) comment 'Имя пользователя',
	/* MySQl позволяет добавлять комментарии к заголовкам полей. */ 
	last_name varchar(100) comment 'Фамилия пользователя',
	email varchar(100) UNIQUE,
	phone varchar (12),
	
	PRIMARY KEY (id), -- первичный ключ
	/* Первичный ключ у таблицы может быть только один и предполагается, что запись будет уникально
	 * идентифицироваться по этому полю. Также первичный ключ в MySQL одновременно является индексом.
	 * Индекс даёт примерно +10% к занимаемому полем места на HDD.
	 * Индексы следует выбирать для полей, для которых часто будет осуществляться поиск, группировка
	 * и для полей, которые будет участвовать в объединении таблиц ("JOIN") и не делать индексы для
	 * тех полей, которые будут часто участвовать в обновлении и во вставках. */
	
	INDEX users_phone_idx(phone), -- индекс
	INDEX users_name_idx(first_name, last_name)
);

-- Создание таблицы с профилями пользователей:

DROP TABLE IF EXISTS profiles;
CREATE TABLE profiles(
	user_id serial,
	gender char(1),
	birthday date,
	photo_id bigint UNSIGNED NULL,
	home_town varchar(100),
	created_at datetime DEFAULT now()
);

/* Внешний ключ, как и любой другой ключ в БД, это ограничение БД, которое заключается в том, что поле
 * одной таблицы ссылается на поле другой таблицы.
 * Принято названия внешних ключей начинать с "fk_". */

ALTER TABLE profiles
	ADD CONSTRAINT fk_user_id -- добавить ограничение
	FOREIGN KEY (user_id) REFERENCES users(id) -- внеш. ключ, ссылающийся на поле "id" в таблице "users"
;

-- Создание таблицы с сообщениями

DROP TABLE IF EXISTS messages;
CREATE TABLE messages(
	id serial,
	from_user_id bigint UNSIGNED NOT NULL,
	to_user_id bigint UNSIGNED NOT NULL,
	body text,
	created_at datetime DEFAULT now(),
	
	PRIMARY KEY (id),
	
	INDEX (from_user_id), -- имена индексов можно не задавать, они присвоятся автоматически
	INDEX (to_user_id),
	
	FOREIGN KEY (from_user_id) REFERENCES users(id),
	FOREIGN KEY (to_user_id) REFERENCES users(id)
);

-- Создание таблицы с запросами о дружбе:

DROP TABLE IF EXISTS friend_requests;
CREATE TABLE friend_requests(
	-- id serial PRIMARY KEY,
	from_user_id bigint UNSIGNED NOT NULL,
	to_user_id bigint UNSIGNED NOT NULL,
	-- status tinyint UNSIGNED - 0, 1, 2, 3, 4, ...
	status enum('requested', 'approved', 'declined', 'unfriended'),
	requested_at datetime DEFAULT now(),
	reacted_at datetime,
	
	/* Так как комбинация полей "from_user_id" и "to_user_id" уникальна для каждой записи,
	 * то мы можем задать следующий первичный ключ: */
	
	PRIMARY KEY (from_user_id, to_user_id),
	
	INDEX (from_user_id),
	INDEX (to_user_id),
	
	FOREIGN KEY (from_user_id) REFERENCES users(id),
	FOREIGN KEY (to_user_id) REFERENCES users(id)
);

/* Следующая сущность это "Сообщества".
 * Так как один пользователь может состоять в нескольких сообществах и одно сообщество
 * состоит из многих пользователей, то такая связь называется "многие-ко-многим",
 * соответственно она организовывается с помощью промежуточной таблицы. То есть у нас
 * должна быть сущность "Пользователи" (она у нас уже есть), у нас должна быть сущность
 * "Сообщества" и у нас должна быть промежуточная сущность, которая будет хранить только
 * "id" пользователя и сообщества. */

-- Создание таблицы с сообществами:

DROP TABLE IF EXISTS communities;
CREATE TABLE communities(
	id serial,
	admin_user_id bigint UNSIGNED NOT NULL,
	name varchar(150),
	
	PRIMARY KEY (id),
	
	INDEX (name),
	
	FOREIGN KEY (admin_user_id) REFERENCES users(id)
);

-- Создание таблицы для организации связи пользователей и сообществ:

DROP TABLE IF EXISTS users_communities;
CREATE TABLE users_communities(
	user_id bigint UNSIGNED NOT NULL,
	community_id bigint UNSIGNED NOT NULL,
	
	PRIMARY KEY (user_id, community_id),
	
	FOREIGN KEY (user_id) REFERENCES users(id),
	FOREIGN KEY (community_id) REFERENCES communities(id)
);

/* Для организации таблицы с постами пользователей, сначала создадим таблицу, содержащую
 * возможные типы медиа-данных */

-- Создание таблицы с типами медиа-данных, кот. можно использовать в посте:

DROP TABLE IF EXISTS media_types;
CREATE TABLE media_types(
	id serial,
	name varchar(150),
	created_at datetime DEFAULT now(),
	updated_at datetime DEFAULT current_timestamp ON UPDATE current_timestamp,
	
	PRIMARY KEY (id)
);

-- Создание таблицы с постами пользователей:

DROP TABLE IF EXISTS media;
CREATE TABLE media(
	id serial,
	media_type_id bigint UNSIGNED NOT NULL,
	user_id bigint UNSIGNED NOT NULL,
	body text,
	file_name varchar(255),
	file_size int,
	metadata json,
	created_at datetime DEFAULT now(),
	updated_at datetime DEFAULT current_timestamp ON UPDATE current_timestamp,
	
	PRIMARY KEY (id),
	
	INDEX (user_id),
	
	FOREIGN KEY (user_id) REFERENCES users(id),
	
	/* У внешних ключей есть опции, задающие их поведение при обновлении и при удалении записей. */
	
	FOREIGN KEY (media_type_id) REFERENCES media_types(id)
		ON UPDATE CASCADE
		ON DELETE RESTRICT
);

-- Создание таблицы с отметками "like":

DROP TABLE IF EXISTS likes;
CREATE TABLE likes(
	id serial,
	user_id bigint UNSIGNED NOT NULL,
	media_id bigint UNSIGNED NOT NULL,
	created_at datetime DEFAULT now(),
	
	PRIMARY KEY (id),
	
	FOREIGN KEY (user_id) REFERENCES users(id),
	FOREIGN KEY (media_id) REFERENCES media(id)
);

-- Создание таблицы с фотоальбомами:

DROP TABLE IF EXISTS photo_album;
CREATE TABLE photo_album(
	id serial,
	user_id bigint UNSIGNED NOT NULL,
	name varchar(150),
	created_at datetime DEFAULT now(),
	
	PRIMARY KEY (id),
	
	FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Создание таблицы с фотографиями.

/*  Они могут как принадлежать фотоальбому, так и быть самостоятельными */

DROP TABLE IF EXISTS photos;
CREATE TABLE photos(
	id serial,
	album_id bigint UNSIGNED,
	media_id bigint UNSIGNED,
	created_at datetime DEFAULT now(),
	
	PRIMARY KEY (id),
	
	FOREIGN KEY (album_id) REFERENCES photo_album(id),
	FOREIGN KEY (media_id) REFERENCES media(id)
);

-- Добавим внешний ключ к полю "photo_id" таблицы "profiles":

ALTER TABLE profiles ADD CONSTRAINT fk_photo_id FOREIGN KEY (photo_id) REFERENCES media(id);

/* Задание № 1:
 * Воспроизвёл скрипт. Вроде всё понятно, но самому что-то дополнить пока сложно...
 * 
 * Задание № 2:
 * Вроде этот функционал уже есть? я видимо не понимаю задания...
 * 
 * Задание № 3:
 * Данные для заполнения в файле "fulldb21-09-2019 18-45.sql". Нужно их поправить немного, но суть понятна. */




