USE vk;

-- INSERT
-- отправка запроса в друзья

INSERT INTO friend_requests (from_user_id, to_user_id, status)
VALUES ('1', '2', 'requested');

INSERT INTO friend_requests (from_user_id, to_user_id, status)
VALUES ('1', '3', 'requested');

INSERT INTO friend_requests (from_user_id, to_user_id, status)
VALUES ('1', '4', 'requested');

INSERT INTO friend_requests (from_user_id, to_user_id, status)
VALUES ('1', '5', 'requested');

-- SELECT

SELECT 50 + 50;

SELECT *
FROM users;

SELECT *
FROM users
LIMIT 5;

SELECT *
FROM users
LIMIT 5 offset 5;

SELECT *
FROM users
WHERE first_name = 'sasha';

SELECT DISTINCT first_name
FROM users;

SELECT DISTINCT first_name, last_name
FROM users;

-- UPDATE
-- подтвердить запрос в друзья

UPDATE friend_requests
SET
	status = 'approved',
	reacted_at = now()
WHERE
	from_user_id = '1' AND to_user_id = '2' AND status = 'requested'
;

-- отклонить запрос в друзья

UPDATE friend_requests
SET
	status = 'declined',
	reacted_at = now()
WHERE
	from_user_id = '1' AND to_user_id = '3' AND status = 'requested'
;

-- DELETE

DELETE FROM communities;
DELETE FROM users_communities;

-- TRUNCATE

truncate TABLE communities;
truncate TABLE users_communities;


