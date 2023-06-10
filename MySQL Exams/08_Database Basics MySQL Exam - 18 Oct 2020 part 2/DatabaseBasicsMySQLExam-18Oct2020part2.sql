CREATE DATABASE `softUni_stores_system`;

USE `softUni_stores_system`;

CREATE TABLE `pictures`
(
    `id`       INT PRIMARY KEY AUTO_INCREMENT,
    `url`      VARCHAR(100) NOT NULL,
    `added_on` DATETIME     NOT NULL
);

CREATE TABLE `categories`
(
    `id`   INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(40) NOT NULL UNIQUE
);

CREATE TABLE `products`
(
    `id`          INT PRIMARY KEY AUTO_INCREMENT,
    `name`        VARCHAR(40)    NOT NULL UNIQUE,
    `best_before` DATE,
    `price`       DECIMAL(10, 2) NOT NULL,
    `description` TEXT,
    `category_id` INT            NOT NULL,
    `picture_id`  INT            NOT NULL,
    CONSTRAINT `fk_products_categories`
        FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`),
    CONSTRAINT `fk_products_pictures`
        FOREIGN KEY (`picture_id`) REFERENCES `pictures` (`id`)

);

CREATE TABLE `towns`
(
    `id`   INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE `addresses`
(
    `id`      INT PRIMARY KEY AUTO_INCREMENT,
    `name`    VARCHAR(50) NOT NULL UNIQUE,
    `town_id` INT         NOT NULL,
    CONSTRAINT `fk_addresses_towns`
        FOREIGN KEY (`town_id`) REFERENCES `towns` (`id`)
);

CREATE TABLE `stores`
(
    `id`          INT PRIMARY KEY AUTO_INCREMENT,
    `name`        VARCHAR(20) NOT NULL UNIQUE,
    `rating`      FLOAT       NOT NULL,
    `has_parking` TINYINT(1) DEFAULT 0,
    `address_id`  INT         NOT NULL,
    CONSTRAINT `_stores_addresses`
        FOREIGN KEY (`address_id`) REFERENCES `addresses` (`id`)

);

CREATE TABLE `products_stores`
(
    `product_id` INT NOT NULL,
    `store_id`   INT NOT NULL,
    PRIMARY KEY (`product_id`, `store_id`),
    CONSTRAINT `fk_1`
        FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
    CONSTRAINT `fk_2`
        FOREIGN KEY (`store_id`) REFERENCES `stores` (`id`)
);

CREATE TABLE `employees`
(
    `id`          INT PRIMARY KEY AUTO_INCREMENT,
    `first_name`  VARCHAR(15)    NOT NULL,
    `middle_name` CHAR(1),
    `last_name`   VARCHAR(20)    NOT NULL,
    `salary`      DECIMAL(19, 2) NOT NULL DEFAULT 0,
    `hire_date`   DATE           NOT NULL,
    `manager_id`  INT,
    `store_id`    INT            NOT NULL,
    CONSTRAINT `fk_12`
        FOREIGN KEY (`store_id`) REFERENCES `stores` (`id`),
    CONSTRAINT `fk_11`
        FOREIGN KEY (`manager_id`) REFERENCES `employees` (`id`)
);

-- 02. Insert

INSERT INTO `products_stores`(`product_id`, `store_id`)
SELECT `p`.`id`,
       1
FROM `products` AS `p`
         LEFT JOIN `products_stores` AS `ps`
                   ON `p`.`id` = `ps`.`product_id`
WHERE `store_id` IS NULL;

-- 03. Update

UPDATE `employees` AS `e`
    JOIN `stores` AS `s` ON `e`.`store_id` = `s`.`id`
SET `e`.`manager_id` = 3,
    `salary`         = `salary` - 500
WHERE YEAR(`hire_date`) > 2003
  AND `s`.`name` != 'Cardguard'
  AND `s`.`name` != 'Veribet';

-- 04. Delete

DELETE `e1`
FROM `employees` AS `e1`
         LEFT JOIN `employees` AS `e2` ON `e1`.`id` = `e1`.`manager_id`
WHERE `e1`.`manager_id` IS NOT NULL
  AND `e1`.`salary` >= 6000;

-- 05. Employees


SELECT `first_name`, `middle_name`, `last_name`, `salary`, `hire_date`
FROM `employees`
ORDER BY `hire_date` DESC;

-- 06. Products with old pictures

SELECT `pro`.`name`                                         AS `product_name`,
       `pro`.`price`,
       `pro`.`best_before`,
       CONCAT(SUBSTRING(`pro`.`description`, 1, 10), '...') AS `short_description`,
       `pic`.`url`
FROM `products` AS `pro`
         JOIN `pictures` AS `pic` ON `pro`.`picture_id` = `pic`.`id`
WHERE CHAR_LENGTH(`description`) > 100
  AND YEAR(`pic`.`added_on`) < 2019
  AND `pro`.`price` > 20
ORDER BY `pro`.`price` DESC;

-- 07. Counts of products in stores

SELECT `s`.`name`,
       COUNT(`p`.`id`)            AS `product_count`,
       ROUND(AVG(`p`.`price`), 2) AS `avg`
FROM `stores` AS `s`
         LEFT JOIN `products_stores` AS `ps` ON `s`.`id` = `ps`.`store_id`
         LEFT JOIN `products` AS `p` ON `ps`.`product_id` = `p`.`id`
GROUP BY `s`.`name`
ORDER BY `product_count` DESC, `avg` DESC, `s`.`id`;

-- 08. Specific employee

SELECT CONCAT(`e`.`first_name`, ' ', `last_name`) AS `Full_name`,
       `s`.`name`                                 AS `store_name`,
       `a`.`name`                                 AS `address`,
       `e`.`salary`
FROM `employees` AS `e`
         JOIN `stores` AS `s` ON `e`.`store_id` = `s`.`id`
         JOIN `addresses` AS `a` ON `s`.`address_id` = `a`.`id`
WHERE `e`.`salary` < 4000
  AND `a`.`name` LIKE '%5%'
  AND CHAR_LENGTH(`s`.`name`) > 8
  AND `e`.`last_name` LIKE '%n'










