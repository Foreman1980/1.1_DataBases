/* ������������ ������� �� ���� ��������� � ��������������
 * �Ĕ
 * 1. ���������������� ��������� �� vk, ������� �� ������� �� �������, � ������ ����������� ��
 * ������������������ (���� ����� ���� ����). �������� ����������, ��-�� ������� ��
 * ���������.
 * 2. �������� ����������� �������/������� ��� ����, ����� ����� ���� ������������ ����� ���
 * �����������, ������ � �������������.
 * 3. ��������� ������ http://filldb.info ��� ������ �� ������ �������, ������������� ��������
 * ������ ��� ���� ������, �������� ������ ������. ��� ���� ������, ��� ��� ����� �����,
 * ������� �� ����� 100 �����. ������� �������� �� vk � ��������� � �� �������� ������. */

-- ��������������� �������������� �� "vk" �� ����� � 3.

-- ������� �� "vk":

DROP DATABASE IF EXISTS vk;
CREATE DATABASE vk;
USE vk;

-- �������� ������� � ��������������:

DROP TABLE IF EXISTS users;
CREATE TABLE users(
	id serial, -- SERIAL = BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE
	first_name varchar(100) comment '��� ������������',
	/* MySQl ��������� ��������� ����������� � ���������� �����. */ 
	last_name varchar(100) comment '������� ������������',
	email varchar(100) UNIQUE,
	phone varchar (12),
	
	PRIMARY KEY (id), -- ��������� ����
	/* ��������� ���� � ������� ����� ���� ������ ���� � ��������������, ��� ������ ����� ���������
	 * ������������������ �� ����� ����. ����� ��������� ���� � MySQL ������������ �������� ��������.
	 * ������ ��� �������� +10% � ����������� ����� ����� �� HDD.
	 * ������� ������� �������� ��� �����, ��� ������� ����� ����� �������������� �����, �����������
	 * � ��� �����, ������� ����� ����������� � ����������� ������ ("JOIN") � �� ������ ������� ���
	 * ��� �����, ������� ����� ����� ����������� � ���������� � �� ��������. */
	
	INDEX users_phone_idx(phone), -- ������
	INDEX users_name_idx(first_name, last_name)
);

-- �������� ������� � ��������� �������������:

DROP TABLE IF EXISTS profiles;
CREATE TABLE profiles(
	user_id serial,
	gender char(1),
	birthday date,
	photo_id bigint UNSIGNED NULL,
	home_town varchar(100),
	created_at datetime DEFAULT now()
);

/* ������� ����, ��� � ����� ������ ���� � ��, ��� ����������� ��, ������� ����������� � ���, ��� ����
 * ����� ������� ��������� �� ���� ������ �������.
 * ������� �������� ������� ������ �������� � "fk_". */

ALTER TABLE profiles
	ADD CONSTRAINT fk_user_id -- �������� �����������
	FOREIGN KEY (user_id) REFERENCES users(id) -- ����. ����, ����������� �� ���� "id" � ������� "users"
;

-- �������� ������� � �����������

DROP TABLE IF EXISTS messages;
CREATE TABLE messages(
	id serial,
	from_user_id bigint UNSIGNED NOT NULL,
	to_user_id bigint UNSIGNED NOT NULL,
	body text,
	created_at datetime DEFAULT now(),
	
	PRIMARY KEY (id),
	
	INDEX (from_user_id), -- ����� �������� ����� �� ��������, ��� ���������� �������������
	INDEX (to_user_id),
	
	FOREIGN KEY (from_user_id) REFERENCES users(id),
	FOREIGN KEY (to_user_id) REFERENCES users(id)
);

-- �������� ������� � ��������� � ������:

DROP TABLE IF EXISTS friend_requests;
CREATE TABLE friend_requests(
	-- id serial PRIMARY KEY,
	from_user_id bigint UNSIGNED NOT NULL,
	to_user_id bigint UNSIGNED NOT NULL,
	-- status tinyint UNSIGNED - 0, 1, 2, 3, 4, ...
	status enum('requested', 'approved', 'declined', 'unfriended'),
	requested_at datetime DEFAULT now(),
	reacted_at datetime,
	
	/* ��� ��� ���������� ����� "from_user_id" � "to_user_id" ��������� ��� ������ ������,
	 * �� �� ����� ������ ��������� ��������� ����: */
	
	PRIMARY KEY (from_user_id, to_user_id),
	
	INDEX (from_user_id),
	INDEX (to_user_id),
	
	FOREIGN KEY (from_user_id) REFERENCES users(id),
	FOREIGN KEY (to_user_id) REFERENCES users(id)
);

/* ��������� �������� ��� "����������".
 * ��� ��� ���� ������������ ����� �������� � ���������� ����������� � ���� ����������
 * ������� �� ������ �������������, �� ����� ����� ���������� "������-��-������",
 * �������������� ��� ���������������� � ������� ������������� �������. �� ���� � ���
 * ������ ���� �������� "������������" (��� � ��� ��� ����), � ��� ������ ���� ��������
 * "����������" � � ��� ������ ���� ������������� ��������, ������� ����� ������� ������
 * "id" ������������ � ����������. */

-- �������� ������� � ������������:

DROP TABLE IF EXISTS communities;
CREATE TABLE communities(
	id serial,
	admin_user_id bigint UNSIGNED NOT NULL,
	name varchar(150),
	
	PRIMARY KEY (id),
	
	INDEX (name),
	
	FOREIGN KEY (admin_user_id) REFERENCES users(id)
);

-- �������� ������� ��� ����������� ����� ������������� � ���������:

DROP TABLE IF EXISTS users_communities;
CREATE TABLE users_communities(
	user_id bigint UNSIGNED NOT NULL,
	community_id bigint UNSIGNED NOT NULL,
	
	PRIMARY KEY (user_id, community_id),
	
	FOREIGN KEY (user_id) REFERENCES users(id),
	FOREIGN KEY (community_id) REFERENCES communities(id)
);

/* ��� ����������� ������� � ������� �������������, ������� �������� �������, ����������
 * ��������� ���� �����-������ */

-- �������� ������� � ������ �����-������, ���. ����� ������������ � �����:

DROP TABLE IF EXISTS media_types;
CREATE TABLE media_types(
	id serial,
	name varchar(150),
	created_at datetime DEFAULT now(),
	updated_at datetime DEFAULT current_timestamp ON UPDATE current_timestamp,
	
	PRIMARY KEY (id)
);

-- �������� ������� � ������� �������������:

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
	
	/* � ������� ������ ���� �����, �������� �� ��������� ��� ���������� � ��� �������� �������. */
	
	FOREIGN KEY (media_type_id) REFERENCES media_types(id)
		ON UPDATE CASCADE
		ON DELETE RESTRICT
);

-- �������� ������� � ��������� "like":

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

-- �������� ������� � �������������:

DROP TABLE IF EXISTS photo_album;
CREATE TABLE photo_album(
	id serial,
	user_id bigint UNSIGNED NOT NULL,
	name varchar(150),
	created_at datetime DEFAULT now(),
	
	PRIMARY KEY (id),
	
	FOREIGN KEY (user_id) REFERENCES users(id)
);

-- �������� ������� � ������������.

/*  ��� ����� ��� ������������ �����������, ��� � ���� ���������������� */

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

-- ������� ������� ���� � ���� "photo_id" ������� "profiles":

ALTER TABLE profiles ADD CONSTRAINT fk_photo_id FOREIGN KEY (photo_id) REFERENCES media(id);

/* ������� � 1:
 * ���������� ������. ����� �� �������, �� ������ ���-�� ��������� ���� ������...
 * 
 * ������� � 2:
 * ����� ���� ���������� ��� ����? � ������ �� ������� �������...
 * 
 * ������� � 3:
 * ������ ��� ���������� � ����� "fulldb21-09-2019 18-45.sql". ����� �� ��������� �������, �� ���� �������. */




