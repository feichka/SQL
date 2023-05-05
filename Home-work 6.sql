-- 1. Создайте функцию, которая принимает кол-во сек и формат их в кол-во дней часов.
-- Пример: 123456 ->'1 days 10 hours 17 minutes 36 seconds '

DROP DATABASE if EXISTS hw6;
CREATE DATABASE if not EXISTS hw6;
USE hw6;

DROP FUNCTION IF EXISTS seconds_formate;

DELIMITER $$
CREATE FUNCTION seconds_formate(s INT)  
RETURNS VARCHAR(100)
DETERMINISTIC 
READS SQL DATA
BEGIN
 SET @s = 123456;
	RETURN CONCAT(
		FLOOR(TIME_FORMAT(SEC_TO_TIME(@s), '%H') / 24), 'days ',
		MOD(TIME_FORMAT(SEC_TO_TIME(@s), '%H'), 24), 'h:',
		TIME_FORMAT(SEC_TO_TIME(@s), '%im:%ss')
		);
END $$

SELECT seconds_formate (@s) AS 'Трансформирование';


-- 2. Выведите только четные числа от 1 до 10.
-- Пример: 2,4,6,8,10

DROP PROCEDURE IF  EXISTS evan_numbers;
DELIMITER //

CREATE PROCEDURE evan_numbers (IN m INT)
BEGIN
	DECLARE n INT DEFAULT 0;
     DECLARE even_numbers VARCHAR(100) DEFAULT "";
		WHILE n <= m DO 
			IF n % 2 = 0 THEN
            SET even_numbers = CONCAT(even_numbers, " ", n);
            END IF;
            SET n = n + 1;
		END WHILE;
        SELECT even_numbers;
END //

DELIMITER ;

CALL evan_numbers (10);

/* создание процедуры, которая решает следующую задачу
Выбрать для одного пользователя 5 пользователей в случайной комбинации, которые удовлетворяют хотя бы одному критерию:
1) из одного города
2) состоят в одной группе
3) друзья друзей
*/

USE lesson_4;

-- обновим данные в базе, чтобы появились пользователи из одного города
UPDATE profiles
SET hometown = 'South Woodrowmouth'
WHERE birthday < '1990-01-01';

-- создание процедуры
DROP PROCEDURE IF EXISTS sp_friendship_offers;
DELIMITER //
CREATE PROCEDURE sp_friendship_offers(for_user_id BIGINT)
BEGIN
-- друзья
WITH friends AS (
SELECT initiator_user_id AS id
FROM friend_requests
WHERE status = 'approved' AND target_user_id = for_user_id
UNION
SELECT target_user_id
FROM friend_requests
WHERE status = 'approved' AND initiator_user_id = for_user_id
)
-- общий город
SELECT p2.user_id
FROM profiles p1
JOIN profiles p2 ON p1.hometown = p2.hometown
WHERE p1.user_id = for_user_id AND p2.user_id <> for_user_id
UNION
-- состоят в одной группе
SELECT uc2.user_id FROM users_communities uc1
JOIN users_communities uc2 ON uc1.community_id = uc2.community_id
WHERE uc1.user_id = for_user_id AND uc2.user_id <> for_user_id
-- друзья друзей
UNION
SELECT fr.initiator_user_id
FROM friends f
JOIN friend_requests fr ON fr.target_user_id = f.id
WHERE fr.initiator_user_id != for_user_id AND fr.status = 'approved'
UNION
SELECT fr.target_user_id
FROM friends f
JOIN friend_requests fr ON fr.initiator_user_id = f.id
WHERE fr.target_user_id != for_user_id AND status = 'approved'
ORDER BY rand()
LIMIT 5;

END//

DELIMITER ;

-- вызов процедуры
CALL sp_friendship_offers(1);

-- ФУНКЦИИ
-- создание функции, вычисляющей коэффициент популярности пользователя
DROP FUNCTION IF EXISTS friendship_direction;
DELIMITER //
CREATE FUNCTION friendship_direction(check_user_id BIGINT)
RETURNS FLOAT READS SQL DATA
BEGIN
DECLARE requests_to_user INT; -- заявок к пользователю
DECLARE requests_from_user INT; -- заявок от пользователя

SET requests_to_user = (
    SELECT count(*) 
    FROM friend_requests
    WHERE target_user_id = check_user_id 
    );

SELECT count(*)
INTO  requests_from_user
FROM friend_requests
WHERE initiator_user_id = check_user_id; 

RETURN requests_to_user / requests_from_user;
END//
DELIMITER ;

-- вызов функции
SELECT friendship_direction(1);
SELECT truncate(friendship_direction(1), 2)*100 AS user_popularity;