-- Доработка таблиц БД vk по материалам урока № 4

use vk;

ALTER TABLE users ADD is_deleted bit DEFAULT 0 NOT NULL;



