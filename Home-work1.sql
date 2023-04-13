-- 1. Создайте таблицу с мобильными телефонами, используя графический интерфейс. Заполните БД данными. 
DROP DATABASE IF EXISTS hw1;
CREATE DATABASE IF NOT EXISTS hw1; -- Создаем БД lesson1, если до этого такой БД не существовло

USE hw1;

CREATE TABLE IF NOT EXISTS telephone
(
	Id INT PRIMARY KEY AUTO_INCREMENT, 
    ProductName VARCHAR(45),
    Manufacturer VARCHAR(45),
    ProductCount INT(10),
    Price INT(10)
);

INSERT telephone (ProductName, Manufacturer, ProductCount, Price)
VALUES 
	("iPhone X", "Apple", 3, 76000), -- id = 1
	("iPhone 8", "Apple", 2, 51000), -- id = 2
    ("Galaxy S9", "Samsung", 2, 56000), -- id = 3
    ("Galaxy S8", "Samsung", 1, 41000), -- id = 4
    ("P20 Pro", "Huawei", 5, 36000); -- id = 5
    
SELECT * 
FROM telephone;

-- 2. Вывести название, производителя и цену для товаров, количество которых превышает 2
SELECT ProductName, Manufacturer, Price
FROM telephone
WHERE ProductCount >2;

-- 3. Выведите весь ассортимент марки Samsung
SELECT ProductName
FROM telephone
WHERE Manufacturer = 'Samsung';

-- 4. Выведите информацию о телефонах, где суммарный чек больше 100000 и меньше 145000
SELECT ProductName, Manufacturer
FROM telephone
WHERE ProductCount * Price  > 100000 AND ProductCount * Price < 145000;

-- 4.1. С помощью регулярных выражений найти товары, в которых есть упоминание "iPhone"
SELECT *
FROM telephone 
WHERE ProductName LIKE "iPhone%";

-- 4.2. С помощью регулярных выражений найти товары, в которых есть упоминание "Samsung"
SELECT *
FROM telephone 
WHERE Manufacturer LIKE "Samsung%";

-- 4.3. Товары, в которых есть цифры
SELECT *
FROM telephone 
WHERE ProductName RLIKE "[0-9]";

-- 4.4. Товары, в которых есть цифра 8
SELECT *
FROM telephone 
WHERE ProductName RLIKE "8";