/*--------------Отработка запросов по материалам урока № 6--------------*/

USE vk;

-- Получить фото профиля, полное имя пользователя и город проживания
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

-- Получить все фото пользователя
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

-- Получить все фото пользователя по его e-mail ('smitham.demarcus@example.net')
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














