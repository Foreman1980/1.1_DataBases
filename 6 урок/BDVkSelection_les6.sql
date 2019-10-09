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
SELECT file_name
FROM media
WHERE id = ( SELECT photo_id
             FROM profiles
             WHERE user_id = 1);

-- Шаг 5
SELECT
    first_name,
    last_name,
    (   SELECT home_town
        FROM profiles
        WHERE user_id = 1) AS 'city',
    (   SELECT file_name
        FROM media
        WHERE id = (    SELECT photo_id
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
ORDER BY total DESC;

/*--------Количество новостей пользователей, у кот. оно больше 1--------*/
-- Шаг 1
SELECT
    user_id,
    count(id) AS total
FROM media
GROUP BY user_id
HAVING total > 1
ORDER BY total DESC;

/*------------Вывести список id друзей пользователя с id = 1------------*/
-- Шаг 1 - выведем всю таблицу friend_requests
SELECT *
FROM friend_requests;

-- Шаг 2 - выведем список пользователей, кот. "взаимодействовали" с пользователем id = 1
SELECT
    from_user_id,
    to_user_id,
    status
FROM friend_requests
WHERE from_user_id = 1 OR to_user_id = 1;

-- Шаг 3 - выведем список всех друзей пользователя с id = 1
SELECT
    from_user_id,
    to_user_id,
    status
FROM friend_requests
WHERE (from_user_id = 1 OR to_user_id = 1) AND status = 'approved';

/*------------Вывести новости друзей пользователя с id = 1------------*/
-- Шаг 1
SELECT *
FROM media;
WHERE user_id = ;

-- Шаг 2
SELECT
    from_user_id
FROM friend_requests
WHERE to_user_id = 1 AND status = 'approved';

SELECT
    to_user_id
FROM friend_requests
WHERE from_user_id = 1 AND status = 'approved';

-- Шаг 3
SELECT *
FROM media
WHERE user_id IN (( SELECT
                        from_user_id
                    FROM friend_requests
                    WHERE to_user_id = 1 AND status = 'approved'), (SELECT
                                                                        to_user_id
                                                                    FROM friend_requests
                                                                    WHERE from_user_id = 1 AND status = 'approved'
                                                                    LIMIT 1), ( SELECT
                                                                                    to_user_id
                                                                                FROM friend_requests
                                                                                WHERE from_user_id = 1 AND status = 'approved'
                                                                                LIMIT 1 offset 1));

-- объединение выборок с помощью ключевого слвоа UNION
SELECT *
FROM media
WHERE user_id IN (( SELECT
                        from_user_id
                    FROM friend_requests
                    WHERE to_user_id = 1 AND status = 'approved') UNION (   SELECT
                                                                                to_user_id
                                                                            FROM friend_requests
                                                                            WHERE from_user_id = 1 AND status = 'approved'));

/*---------Объединить новости пользователя с id = 1 и его друзей---------*/
-- Шаг 1
SELECT *
FROM media
WHERE user_id = 1

UNION

SELECT *
FROM media
WHERE user_id IN (( SELECT
                        from_user_id
                    FROM friend_requests
                    WHERE to_user_id = 1 AND status = 'approved') UNION (   SELECT
                                                                                to_user_id
                                                                            FROM friend_requests
                                                                            WHERE from_user_id = 1 AND status = 'approved'));

-- Шаг 2 - отсортируем список новостей по дате создания
SELECT *
FROM media
WHERE user_id = 1

UNION

SELECT *
FROM media
WHERE user_id IN (( SELECT
                        from_user_id
                    FROM friend_requests
                    WHERE to_user_id = 1 AND status = 'approved') UNION (   SELECT
                                                                                to_user_id
                                                                            FROM friend_requests
                                                                            WHERE from_user_id = 1 AND status = 'approved'))
ORDER BY created_at desc;

/*------------Подсчитать лайки новостей пользователя с id = 1------------*/
-- Шаг 1
DESCRIBE likes;
SELECT *
FROM likes;

SELECT count(*)
FROM likes
WHERE media_id IN ( SELECT id
                    FROM media
                    WHERE user_id = 1);

/*--------Вывести все сообщения от пользователя с id = 1 и к нему--------*/
-- Шаг 1
SELECT
    body,
    created_at
FROM messages
WHERE from_user_id = 1 OR to_user_id = 1
ORDER BY created_at DESC;

/*-Вывести все непрочитанные сообщения от пользователя с id = 1 и к нему-*/
-- Шаг 1
SELECT
    body,
    created_at
FROM messages
WHERE (from_user_id = 1 OR to_user_id = 1) AND is_read = 0
ORDER BY created_at DESC;

/*-------Вывести друзей пользователя с id = 1 с указанием их пола-------*/
-- Шаг 1
SELECT
    user_id,
    CASE
        WHEN gender = 'f' THEN 'женщина'
        ELSE 'мужчина'
    END AS 'gender'
FROM profiles
WHERE user_id IN (  SELECT from_user_id
                    FROM friend_requests
                    WHERE to_user_id = 1 AND status = 'approved' UNION  SELECT to_user_id
                                                                        FROM friend_requests
                                                                        WHERE from_user_id = 1 AND status = 'approved');

-- альтернативный синтаксис (как в видео вебинара)
SELECT
    user_id,
    CASE (gender)
        WHEN 'f' THEN 'женщина'
        ELSE 'мужчина'
    END AS 'gender'
FROM profiles
WHERE user_id IN (  SELECT from_user_id
                    FROM friend_requests
                    WHERE to_user_id = 1 AND status = 'approved' UNION  SELECT to_user_id
                                                                        FROM friend_requests
                                                                        WHERE from_user_id = 1 AND status = 'approved');

-- Шаг 1 -добавим указание возраста друга
SELECT
    user_id,
    CASE (gender)
        WHEN 'f' THEN 'женщина'
        ELSE 'мужчина'
    END AS 'gender',
    timestampdiff(YEAR, birthday, now()) AS 'возраст'
FROM profiles
WHERE user_id IN (  SELECT from_user_id
                    FROM friend_requests
                    WHERE to_user_id = 1 AND status = 'approved' UNION  SELECT to_user_id
                                                                        FROM friend_requests
                                                                        WHERE from_user_id = 1 AND status = 'approved');

/*--------Определить является ли пользователь админом сообщества--------*/
-- Шаг 1
SELECT IF (1 = (SELECT admin_user_id
                FROM communities
                WHERE id = 2), 'admin', 'user') AS status;
