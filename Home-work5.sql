use hw5;
CREATE TABLE IF NOT EXISTS cars
(
	id INT NOT NULL PRIMARY KEY,
    name VARCHAR(45),
    cost INT
);

INSERT cars
VALUES
	(1, "Audi", 52642),
    (2, "Mercedes", 57127 ),
    (3, "Skoda", 9000 ),
    (4, "Volvo", 29000),
	(5, "Bentley", 350000),
    (6, "Citroen ", 21000 ), 
    (7, "Hummer", 41400), 
    (8, "Volkswagen ", 21600);
    
SELECT *
FROM cars;

-- 1.	Создайте представление, в которое попадут автомобили стоимостью  до 25 000 долларов
CREATE OR REPLACE VIEW cars_25 AS
SELECT *
FROM cars
WHERE cost < 25000;

-- 2. Изменить в существующем представлении порог для стоимости: пусть цена будет до 30 000 долларов (используя оператор ALTER VIEW) 
ALTER VIEW cars_25 AS
SELECT `name`, cost
FROM cars
WHERE cost < 30000; 

-- 3. Создайте представление, в котором будут только автомобили марки “Шкода” и “Ауди”
CREATE OR REPLACE VIEW cars_model AS
SELECT *
FROM cars
WHERE `name` = 'Skoda' OR `name` = 'Audi';

/* 4. Добавьте новый столбец под названием «время до следующей станции». 
Чтобы получить это значение, мы вычитаем время станций для пар смежных станций. 
Мы можем вычислить это значение без использования оконной функции SQL, но это может быть очень сложно. 
Проще это сделать с помощью оконной функции LEAD . Эта функция сравнивает значения из одной строки 
со следующей строкой, чтобы получить результат. В этом случае функция сравнивает значения в столбце 
«время» для станции со станцией сразу после нее.
*/

DROP TABLE IF EXISTS train;
CREATE TABLE IF NOT EXISTS train
( 
train_id INT (5),
station VARCHAR (20),
station_time TIME
);

INSERT train (train_id, station, station_time) 
VALUES 
(110, 'San Francisco', '10:00:00'),
(110, 'Redwood City', '10:54:00'),
(110, 'Palo Alto', '11:002:00'),
(110, 'San Jose', '12:35:00'),
(120, 'San Francisco', '11:00:00'),
(120, 'Palo Alto', '12:49:00'),
(120, 'San Jose', '13:30:00');
SELECT * FROM train;

SELECT train_id, station, station_time,
timediff(LEAD(station_time) OVER(PARTITION BY train_id), station_time) AS 'time_to_next_station'
FROM train;


-- Для скрипта, поставленного в прошлом уроке.
-- Получите друзей пользователя с id=1

USE lesson_4;

SELECT 
initiator_user_id, 
CONCAT(u.firstname, ' ', u.lastname) AS 'Пользователь',
target_user_id,
CONCAT(u1.firstname, ' ', u1.lastname) AS 'Друг'
FROM friend_requests
JOIN users u
ON initiator_user_id = u.id 
JOIN users u1
ON target_user_id = u1.id 
WHERE `status` = 'approved' AND initiator_user_id = 1 OR `status` = 'approved' AND target_user_id = 1;


-- Или вывод только друзей
SELECT 
CASE (initiator_user_id)
	WHEN '1' THEN CONCAT(u1.firstname, ' ', u1.lastname) 
    END AS 'Друг',
CASE (target_user_id)
	WHEN '1' THEN CONCAT(u.firstname, ' ', u.lastname) 
    END AS 'Друг'
FROM friend_requests
JOIN users u
ON initiator_user_id = u.id 
JOIN users u1
ON target_user_id = u1.id 
WHERE `status` = 'approved' AND initiator_user_id = 1 OR `status` = 'approved' AND target_user_id = 1;

-- (решение задачи с помощью представления “друзья”)
-- Создайте представление, в котором будут выводится все сообщения, в которых принимал
-- участие пользователь с id = 1.

CREATE OR REPLACE VIEW friends AS
SELECT  body FROM messages
WHERE from_user_id = 1 OR to_user_id = 1;

-- Получите список медиафайлов пользователя с количеством лайков(media m, likes l ,users u)

SELECT 
CONCAT(u.firstname, ' ', u.lastname) AS 'Пользователь',
m.filename AS 'Список медиафайлов ',
COUNT(l.id) AS 'Количество лайков'
FROM media m
LEFT JOIN users u
ON m.user_id = u.id
LEFT JOIN likes l
ON l.media_id = m.id
GROUP BY m.id
ORDER BY CONCAT(u.firstname, ' ', u.lastname);

-- Получите количество групп у пользователей

SELECT 
CONCAT(u.firstname, ' ', u.lastname) AS 'Пользователь',
COUNT(community_id) AS 'Количество групп'
FROM users u, users_communities uc
WHERE user_id = u.id
GROUP BY u.id;

-- Вывести 3 пользователей с наибольшим количеством лайков за медиафайлы

SELECT 
CONCAT(u.firstname, ' ', u.lastname) AS 'Пользователь',
COUNT(l.id) AS 'Количество лайков'
FROM media m
LEFT JOIN users u
ON m.user_id = u.id
LEFT JOIN likes l
ON l.media_id = m.id
GROUP BY CONCAT(u.firstname, ' ', u.lastname)
ORDER BY COUNT(l.id) DESC
LIMIT 3;



