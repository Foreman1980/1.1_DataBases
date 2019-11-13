/*----------------------Взамодействие с БД "RLineShop" для курсового проекта----------------------*/

USE rlineshop;

DROP PROCEDURE IF EXISTS new_registration;
DELIMITER //
CREATE PROCEDURE new_registration(handle varchar(100), phone varchar(12), email varchar(100), vk_profile varchar(100), hometown varchar(100))
BEGIN
    DECLARE discount_card_id bigint;
    IF (0 = (SELECT count(*) FROM clients WHERE clients.phone = phone) + (SELECT count(*) FROM clients WHERE clients.email = email)) THEN
        START TRANSACTION;
            SET discount_card_id = (SELECT id FROM discount_card dc WHERE summ IS NULL ORDER BY id LIMIT 1);
            INSERT INTO clients (clients.handle, clients.phone, clients.email, clients.vk_profile, clients.hometown, clients.discount_card_id) VALUES
                (handle, phone, email, vk_profile, hometown, discount_card_id)
            ;
            UPDATE discount_card
            SET summ = 0
            WHERE id = discount_card_id;
        COMMIT;
    ELSE
        SELECT 'Покупатель с таким телефоном/email уже зарегистрирован.';
    END IF;
END//
DELIMITER ;

-- UPDATE discount_card
-- SET summ = NULL;
-- WHERE discount_card.id = 1;

truncate clients;
CALL new_registration('Reuben Nienow', '+79374071116', 'arlo50@example.org', NULL, 'Adriannaport');
CALL new_registration('Frederik Upton', '+79127498182', 'terrence.cartwright@example.org', NULL, 'Adriannaport');
CALL new_registration('Unique Windler', '+79921090703', 'rupert55@example.org', NULL, 'Adriannaport');
CALL new_registration('Norene West', '+79592139196', 'rebekah29@example.net', NULL, 'Adriannaport');
CALL new_registration('Frederick Effertz', '+79909791725', 'von.bridget@example.net', NULL, 'Adriannaport');
CALL new_registration('Victoria Medhurst', '+79456642385', 'sstehr@example.net', NULL, 'Adriannaport');
CALL new_registration('Austyn Braun', '+79448906606', 'itzel.beahan@example.com', NULL, 'Adriannaport');
CALL new_registration('Jaida Kilback', '+79290679311', 'johnathan.wisozk@example.com', NULL, 'Adriannaport');
CALL new_registration('Mireya Orn', '+79228624339', 'missouri87@example.org', NULL, 'Adriannaport');
CALL new_registration('Jordyn Jerde', '+79443126821', 'edach@example.com', NULL, 'Adriannaport');





