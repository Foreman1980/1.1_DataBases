/*--------------Отработка запросов по материалам урока № 6--------------*/

USE vk;

/*---Получить фото профиля, полное имя пользователя и город проживания---*/
-- Шаг 1
SELECT
    first_name,
    last_name,
    'city',
    'main_photo'
FROM users
WHERE id = 1;

-- Шаг 2
SELECT home_town
FROM profiles
WHERE user_id = 1;

-- Шаг 3
SELECT photo_id
FROM profiles
WHERE user_id = 1;

-- Шаг 4
SELECT photo_id
FROM profiles
WHERE user_id = 1;

-- Шаг 5
SELECT file_name
FROM media
WHERE id = ( SELECT photo_id
             FROM profiles
             WHERE user_id = 1);

-- Шаг 6
SELECT
    first_name,
    last_name,
    (   SELECT home_town
        FROM profiles
        WHERE user_id = 1) AS 'city',
    (   SELECT file_name
        FROM media
        WHERE id = (   SELECT photo_id
                        FROM profiles
                        WHERE user_id = 1)) AS 'main_photo'
FROM users
WHERE id = 1;

/*--------------------Получить все фото пользователя--------------------*/
-- Шаг 1
SELECT id
FROM media_types
WHERE name LIKE 'photo';

-- Шаг 2
SELECT file_name
FROM media
WHERE user_id = 1 AND media_type_id = ( SELECT id
                                        FROM media_types
                                        WHERE name LIKE 'photo');

/*Получить все фото пользователя по его e-mail ('smitham.demarcus@example.net')*/
-- Шаг 1
SELECT id
FROM users
WHERE email = 'smitham.demarcus@example.net';

-- Шаг 2
SELECT file_name
FROM media
WHERE user_id = (   SELECT id
                    FROM users
                    WHERE email = 'smitham.demarcus@example.net') AND media_type_id = ( SELECT id
                                                                                        FROM media_types
                                                                                        WHERE name LIKE 'photo');

/*--------------Получить все новости пользователя с id = 3--------------*/
-- Шаг 1
SELECT *
FROM media
WHERE user_id = 3;

/*------Получить все видео-записи указанного пользователя с id = 3------*/
-- Шаг 1
SELECT id
FROM media_types AS mt
WHERE name LIKE 'video';

-- Шаг 2
SELECT *
FROM media
WHERE user_id = 3 AND media_type_id = ( SELECT id
                                        FROM media_types AS mt
                                        WHERE name LIKE 'video');

/*-------------------Вывести архив новостей по месяцам-------------------*/
-- Шаг 1 - Выделим месяца из даты создания новостей
SELECT monthname(created_at)
FROM media;
                                    
-- Шаг 2 - Сгруппируем записи по месяцам создания новостей и выведем их кол-во
SELECT
    count(*),
    monthname(created_at) AS month_create
FROM media
GROUP BY month_create
ORDER BY month(created_at);
-- WITH ROLLUP;

-- Шаг 3 - Сортировка по кол-ву новостей за месяц
SELECT
    count(*),
    monthname(created_at) AS month_create
FROM media
GROUP BY month_create
ORDER BY count(*) DESC;

/*----------------Сколько новостей у каждого пользователя----------------*/
-- Шаг 1
SELECT
    user_id,
    count(id) AS total
FROM media
GROUP BY user_id
ORDER BY total desc;

/*--------Количество новостей пользователей, у кот. оно больше 1--------*/
-- Шаг 1
SELECT
    user_id,
    count(id) AS total
FROM media
GROUP BY user_id
HAVING total > 1
ORDER BY total desc;

/*-----------------Вывести список id друзей пользователя-----------------*/
-- Шаг 1 - выведем всю таблицу friend_requests
SELECT *
FROM friend_requests;

-- Шаг 2


























