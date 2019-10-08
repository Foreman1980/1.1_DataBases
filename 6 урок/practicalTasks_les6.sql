/*-------------------Приктическое задание к уроку № 6-------------------*/

/* 1. Проанализировать запросы, которые выполнялись на занятии, определить возможные
 * корректировки и/или улучшения (JOIN пока не применять).
 *    см. BDVkSelection_les6.sql*/

/* 2. Пусть задан некоторый пользователь.
 * Из всех друзей этого пользователя найдите человека, который больше всех общался с нашим
 * пользователем.*/

-- Шаг 1
-- выяснилось, что по сгенерированным данным пользователи пишут сами себе...см. DBVkDataFiling_les6.sql
SELECT *
FROM messages;

-- исправим это для получателей
UPDATE messages
SET to_user_id = floor(1 + rand()*100);

-- исправим это для отправителей
UPDATE messages
SET from_user_id = floor(1 + rand()*100);

-- проверка оставшихся равными id автора сообщения и получателя
SELECT *
FROM messages
WHERE from_user_id >= 1 AND from_user_id < 20 AND from_user_id = to_user_id;

-- исправление оставшихся сообщений
UPDATE messages
SET from_user_id = IF(from_user_id = to_user_id, floor(1 + rand()*100), from_user_id);

-- Шаг 2 - определим пользователя, который чаще всего писал пользователю с id = 3
SELECT
    from_user_id,
    count(*)
FROM messages
WHERE to_user_id = 3
GROUP BY from_user_id
ORDER BY count(*) DESC
LIMIT 1;

/*3. Подсчитать общее количество лайков, которые получили 10 самых молодых пользователей*/
-- Шаг 1 - добавим записей в таблицу "likes"
truncate likes;
INSERT INTO
    likes(user_id, media_id)
VALUES 
    ((1 + rand() * 30), (1 + rand() * 30)),
    ((1 + rand() * 30), (1 + rand() * 30)),
    ((1 + rand() * 30), (1 + rand() * 30)),
    ((1 + rand() * 30), (1 + rand() * 30)),
    ((1 + rand() * 30), (1 + rand() * 30)),
    ((1 + rand() * 30), (1 + rand() * 30)),
    ((1 + rand() * 30), (1 + rand() * 30)),
    ((1 + rand() * 30), (1 + rand() * 30)),
    ((1 + rand() * 30), (1 + rand() * 30)),
    ((1 + rand() * 30), (1 + rand() * 30)),
    ((1 + rand() * 30), (1 + rand() * 30)),
    ((1 + rand() * 30), (1 + rand() * 30)),
    ((1 + rand() * 30), (1 + rand() * 30)),
    ((1 + rand() * 30), (1 + rand() * 30)),
    ((1 + rand() * 30), (1 + rand() * 30)),
    ((1 + rand() * 30), (1 + rand() * 30)),
    ((1 + rand() * 30), (1 + rand() * 30)),
    ((1 + rand() * 30), (1 + rand() * 30)),
    ((1 + rand() * 30), (1 + rand() * 30)),
    ((1 + rand() * 30), (1 + rand() * 30)),
    ((1 + rand() * 30), (1 + rand() * 30)),
    ((1 + rand() * 30), (1 + rand() * 30)),
    ((1 + rand() * 30), (1 + rand() * 30)),
    ((1 + rand() * 30), (1 + rand() * 30)),
    ((1 + rand() * 30), (1 + rand() * 30)),
    ((1 + rand() * 30), (1 + rand() * 30)),
    ((1 + rand() * 30), (1 + rand() * 30)),
    ((1 + rand() * 30), (1 + rand() * 30)),
    ((1 + rand() * 30), (1 + rand() * 30)),
    ((1 + rand() * 30), (1 + rand() * 30)),
    ((1 + rand() * 30), (1 + rand() * 30)),
    ((1 + rand() * 30), (1 + rand() * 30)),
    ((1 + rand() * 30), (1 + rand() * 30)),
    ((1 + rand() * 30), (1 + rand() * 30)),
    ((1 + rand() * 30), (1 + rand() * 30)),
    ((1 + rand() * 30), (1 + rand() * 30)),
    ((1 + rand() * 30), (1 + rand() * 30)),
    ((1 + rand() * 30), (1 + rand() * 30)),
    ((1 + rand() * 30), (1 + rand() * 30)),
    ((1 + rand() * 30), (1 + rand() * 30)),
    ((1 + rand() * 30), (1 + rand() * 30)),
    ((1 + rand() * 30), (1 + rand() * 30)),
    ((1 + rand() * 30), (1 + rand() * 30)),
    ((1 + rand() * 30), (1 + rand() * 30)),
    ((1 + rand() * 30), (1 + rand() * 30)),
    ((1 + rand() * 30), (1 + rand() * 30)),
    ((1 + rand() * 30), (1 + rand() * 30)),
    ((1 + rand() * 30), (1 + rand() * 30)),
    ((1 + rand() * 30), (1 + rand() * 30)),
    ((1 + rand() * 30), (1 + rand() * 30)),
    ((1 + rand() * 30), (1 + rand() * 30));
    
-- нужно проверить, чтобы небыло дублей, т.е. лайков одного пользователя одного и того же сообщения
-- проверим записи в табл. "likes" на дублирование
SELECT
    group_concat(id SEPARATOR ', ') AS ids,
    user_id,
    media_id,
    count(*)
FROM likes
GROUP BY user_id, media_id
HAVING count(*) > 1;
-- обнаружено, что в посте с media_id=24 за пользователем c id=9 числятся два лайка...исправим это
UPDATE likes
SET user_id = (1 + rand() * 30)
WHERE id = 8;
-- повторная проверка прошла успешно

-- Шаг 2 - выведем кол-во лайков для каждого поста (у кот. есть лайки...)
SELECT
    media_id,
    count(*) AS 'кол-во лайков'
FROM likes
GROUP BY media_id;

-- Шаг 3 - из таблицы "media" определим авторов постов, которым поставлены лайки
SELECT
    id,
    user_id
FROM media
WHERE id IN (   SELECT media_id
                FROM likes);

-- Шаг 4 - определим десятку самых молодых авторов постов
SELECT
    user_id,
    timestampdiff(YEAR, birthday, now()) AS age
FROM profiles
WHERE user_id IN (  SELECT user_id
                    FROM media
                    WHERE id IN (   SELECT media_id
                                    FROM likes))
ORDER BY age
LIMIT 10;
-- получили возраст от 4 до 21 года

-- Шаг 5 - выведем все посты этих авторов
SELECT id
FROM media
WHERE user_id IN (  SELECT user_id
                    FROM profiles
                    WHERE user_id IN (  SELECT user_id
                                        FROM media
                                        WHERE id IN (   SELECT media_id
                                                        FROM likes)) AND timestampdiff(YEAR, birthday, now()) <= 21);


-- Шаг 6 - получим ответ на задание № 3
SELECT count(*)
FROM likes
WHERE media_id IN ( SELECT id
                    FROM media
                    WHERE user_id IN (  SELECT user_id
                                        FROM profiles
                                        WHERE user_id IN (  SELECT user_id
                                                            FROM media
                                                            WHERE id IN (   SELECT media_id
                                                                            FROM likes)) AND timestampdiff(YEAR, birthday, now()) <= 21));

/*4. Определить кто больше поставил лайков (всего) - мужчины или женщины?*/
SELECT
    CASE (gender)
        WHEN 'f' THEN 'женщины'
        ELSE 'мужчины'
    END AS gender
FROM profiles
WHERE user_id IN (  SELECT DISTINCT user_id
                    FROM likes)
GROUP BY gender
ORDER BY count(user_id) desc
LIMIT 1;

/*5. Найти 10 пользователей, которые проявляют наименьшую активность в использовании
социальной сети.*/
-- Это пользователи у которых сумма кол-ва сообщений, постов и лайков, авторами которых они являются - минимальна
SELECT
    id,
    first_name,
    last_name,
    'message_count',
    'post_count',
    'like_count',
    'activity indicator'
FROM users
ORDER BY 'activity indicator'
LIMIT 10;

SELECT 
    from_user_id, count(id)
FROM messages
GROUP BY from_user_id
ORDER BY count(id);

-- пока не разобрался как выполнить это задание...