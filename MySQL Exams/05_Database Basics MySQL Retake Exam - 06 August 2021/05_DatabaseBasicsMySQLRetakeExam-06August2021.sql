CREATE DATABASE `sgd`;

USE `sgd`;

CREATE TABLE `addresses`
(
    `id`   INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL
);

CREATE TABLE `categories`
(
    `id`   INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(10) NOT NULL
);

CREATE TABLE `offices`
(
    `id`                 INT PRIMARY KEY AUTO_INCREMENT,
    `workspace_capacity` INT NOT NULL,
    `website`            VARCHAR(50),
    `address_id`         INT NOT NULL,
    CONSTRAINT `fk_offices_addresses`
        FOREIGN KEY (`address_id`) REFERENCES `addresses` (`id`)

);


CREATE TABLE `employees`
(
    `id`              INT PRIMARY KEY AUTO_INCREMENT,
    `first_name`      VARCHAR(30)    NOT NULL,
    `last_name`       VARCHAR(30)    NOT NULL,
    `age`             INT            NOT NULL,
    `salary`          DECIMAL(10, 2) NOT NULL,
    `job_title`       VARCHAR(20)    NOT NULL,
    `happiness_level` CHAR(1)        NOT NULL
);

CREATE TABLE `teams`
(
    `id`        INT PRIMARY KEY AUTO_INCREMENT,
    `name`      VARCHAR(40) NOT NULL,
    `office_id` INT         NOT NULL,
    `leader_id` INT         NOT NULL UNIQUE,
    CONSTRAINT `fk_teams_offices`
        FOREIGN KEY (`office_id`) REFERENCES `offices` (`id`),
    CONSTRAINT `fk_teams_employees`
        FOREIGN KEY (`leader_id`) REFERENCES `employees` (`id`)

);

CREATE TABLE `games`
(
    `id`           INT PRIMARY KEY AUTO_INCREMENT,
    `name`         VARCHAR(50)    NOT NULL UNIQUE,
    `description`  TEXT,
    `rating`       FLOAT          NOT NULL DEFAULT 5.5,
    `budget`       DECIMAL(10, 2) NOT NULL,
    `release_date` DATE,
    `team_id`      INT            NOT NULL,
    CONSTRAINT `fk_games_teams`
        FOREIGN KEY (`team_id`) REFERENCES `teams` (`id`)
);


CREATE TABLE `games_categories`
(
    `game_id`     INT NOT NULL,
    `category_id` INT NOT NULL,
    PRIMARY KEY (`game_id`, `category_id`),

    CONSTRAINT `fk_games_categories_games`
        FOREIGN KEY (`game_id`) REFERENCES `games` (`id`),
    CONSTRAINT `fk_games_categories_categories`
        FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`)
);

-- 02. Insert


INSERT INTO `games`(`name`, `rating`, `budget`, `team_id`)
SELECT REVERSE(LOWER(SUBSTRING(`name`, 2))),
       `id`,
       `leader_id` * 1000,
       `id`

FROM `teams`
WHERE `teams`.`id` BETWEEN 1 AND 9;

SELECT *
FROM `teams`;

-- 03. Update

UPDATE `employees` AS `e`
    JOIN `teams` AS `t` ON `e`.`id` = `t`.`leader_id`
SET `e`.`salary` = `salary` + 1000
WHERE `age` <= 40
  AND `salary` <= 5000;

-- 04. Delete

DELETE `g`
FROM `games` AS `g`
         LEFT JOIN `games_categories` AS `gs` ON `g`.`id` = `gs`.`game_id`
WHERE `g`.`release_date` IS NULL
  AND `gs`.`category_id` IS NULL;

-- 05. Employees

SELECT `first_name`, `last_name`, `age`, `salary`, `happiness_level`
FROM `employees`
ORDER BY `salary`, `id`;

-- 06. Addresses of the teams

SELECT `t`.`name`              AS `team_name`,
       `a`.`name`              AS `address_name`,
       CHAR_LENGTH(`a`.`name`) AS `count_of_characters`
FROM `teams` AS `t`
         JOIN `offices` AS `o` ON `t`.`office_id` = `o`.`id`
         JOIN `addresses` AS `a` ON `o`.`address_id` = `a`.`id`
WHERE `o`.`website` IS NOT NULL
ORDER BY `team_name`, `address_name`;

-- 07. Categories Info


SELECT `c`.`name`,
       COUNT(*)          AS        `games_count`,
       ROUND(AVG(`g`.`budget`), 2) `avg_budget`,
       MAX(`g`.`rating`) AS        `max_rating`
FROM `games_categories` AS `gc`
         JOIN `games` AS `g` ON `gc`.`game_id` = `g`.`id`
         JOIN `categories` AS `c` ON `gc`.`category_id` = `c`.`id`
GROUP BY `category_id`, `c`.`name`
HAVING `max_rating` >= 9.5
ORDER BY `games_count` DESC, `c`.`name`;


-- 08. Games of 2022





