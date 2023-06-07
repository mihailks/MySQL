CREATE DATABASE `ruk_database`;

USE `ruk_database`;


CREATE TABLE `branches`
(
    `id`   INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(30) NOT NULL UNIQUE
);

CREATE TABLE `employees`
(
    `id`         INT PRIMARY KEY AUTO_INCREMENT,
    `first_name` VARCHAR(20)    NOT NULL,
    `last_name`  VARCHAR(20)    NOT NULL,
    `salary`     DECIMAL(10, 2) NOT NULL,
    `started_on` DATE           NOT NULL,
    `branch_id`  INT            NOT NULL,
    CONSTRAINT `fk_employees_branches`
        FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`)
);


CREATE TABLE `clients`
(
    `id`        INT PRIMARY KEY AUTO_INCREMENT,
    `full_name` VARCHAR(50) NOT NULL,
    `age`       INT         NOT NULL
);

CREATE TABLE `employees_clients`
(
    `employee_id` INT,
    `client_id`   INT,
    CONSTRAINT `fk_employees_clients_employees`
        FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`),
    CONSTRAINT `fk_employees_clients_clients`
        FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`)
);

CREATE TABLE `bank_accounts`
(
    `id`             INT PRIMARY KEY AUTO_INCREMENT,
    `account_number` VARCHAR(10)    NOT NULL,
    `balance`        DECIMAL(10, 2) NOT NULL,
    `client_id`      INT            NOT NULL UNIQUE,
    CONSTRAINT `fk_banc_account_clients`
        FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`)

);

CREATE TABLE `cards`
(
    `id`              INT PRIMARY KEY AUTO_INCREMENT,
    `card_number`     VARCHAR(19) NOT NULL,
    `card_status`     VARCHAR(7)  NOT NULL,
    `bank_account_id` INT         NOT NULL,
    CONSTRAINT `fk_cards_bank_accounts`
        FOREIGN KEY (`bank_account_id`) REFERENCES `bank_accounts` (`id`)

);

SELECT *
FROM `cards`;



INSERT INTO `cards` (`card_number`, `card_status`, `bank_account_id`)
    (SELECT REVERSE(`full_name`),
            'Active',
            `id`
     FROM `clients`
     WHERE `id` BETWEEN 191 AND 200);


-- 03. Update

UPDATE `employees_clients` AS `ec`
    JOIN
    (SELECT `ec1`.`employee_id`, COUNT(`ec1`.`client_id`) AS 'count'
     FROM `employees_clients` AS `ec1`
     GROUP BY `ec1`.`employee_id`
     ORDER BY `count`, `ec1`.`employee_id`) AS `s`
SET `ec`.`employee_id` = `s`.`employee_id`
WHERE `ec`.`employee_id` = `ec`.`client_id`;

-- 04. Delete

DELETE `e`
FROM `employees` AS `e`
         LEFT JOIN `employees_clients` AS `ec` ON `e`.`id` = `ec`.`employee_id`
WHERE `ec`.`client_id` IS NULL;

-- 05. Clients

SELECT `id`, `full_name`
FROM `clients`
ORDER BY `id`;

-- 06. Newbies

SELECT `id`,
       CONCAT(`first_name`, ' ', `last_name`) AS `full_name`,
       CONCAT('$', `salary`)                  AS `salary`,
       `started_on`
FROM `employees`
WHERE `salary` >= 100000
  AND DATE(`started_on`) >= '2018-01-01'
ORDER BY `salary`
        DESC, `id`;

-- 07. Cards against Humanity

SELECT `cards`.`id` AS `id`,
       CONCAT(`card_number`, ' : ', `full_name`)
FROM `cards`
         JOIN `bank_accounts` AS `ba` ON `cards`.`bank_account_id` = `ba`.`id`
         JOIN `clients` AS `c` ON `ba`.`client_id` = `c`.`id`
ORDER BY `cards`.`id` DESC;

-- 08. Top 5 Employees

SELECT CONCAT(`e`.`first_name`, ' ', `e`.`last_name`) AS `name`,
       `e`.`started_on`,
       COUNT(`ec`.`client_id`)                        AS `count_of_clients`
FROM `employees` AS `e`
         JOIN `employees_clients` AS `ec`
              ON `e`.`id` = `ec`.`employee_id`
GROUP BY `name`, `e`.`started_on`, `e`.`id`
ORDER BY `count_of_clients` DESC, `e`.`id`
LIMIT 5;

#8
SELECT CONCAT_WS(' ', `e`.`first_name`, `e`.`last_name`) AS 'name',
       `e`.`started_on`,
       COUNT(`ec`.`client_id`)                           AS `count_of_clients`
FROM `employees` AS `e`
         JOIN `employees_clients` AS `ec`
              ON `e`.`id` = `ec`.`employee_id`
GROUP BY `ec`.`employee_id`
ORDER BY `count_of_clients` DESC, `ec`.`employee_id`
LIMIT 5;

-- 09. Branch cards

SELECT `b`.`name`,
       COUNT(`c`.`id`) AS `count_of_cards`
FROM `branches` AS `b`
         LEFT JOIN `employees` AS `e` ON `b`.`id` = `e`.`branch_id`
         LEFT JOIN `employees_clients` AS `em` ON `e`.`id` = `em`.`employee_id`
         LEFT JOIN `clients` AS `cl` ON `em`.`client_id` = `cl`.`id`
         LEFT JOIN `bank_accounts` AS `ba` ON `cl`.`id` = `ba`.`client_id`
         LEFT JOIN `cards` AS `c` ON `ba`.`id` = `c`.`bank_account_id`
GROUP BY `b`.`name`
ORDER BY `count_of_cards` DESC, `name`;

-- 10. Extract card's count

DELIMITER $$
CREATE FUNCTION `udf_client_cards_count`(`name` VARCHAR(30))
    RETURNS INT
BEGIN
    RETURN (SELECT COUNT(*)
            FROM `clients` AS `c`
                     JOIN `bank_accounts` AS `ba` ON `c`.`id` = `ba`.`client_id`
                     JOIN `cards` AS `ca` ON `ba`.`id` = `ca`.`bank_account_id`
            WHERE `c`.`full_name` = `name`);
END $$
DELIMITER ;


SELECT `c`.`full_name`,
       `udf_client_cards_count`('Baxy David') AS `cards`
FROM `clients` `c`
WHERE `c`.`full_name` = 'Baxy David';

-- 11. Client Info

DELIMITER $$
CREATE PROCEDURE `udp_clientinfo`(`full_name` VARCHAR(50))
BEGIN
    SELECT `c`.`full_name`,
           `c`.`age`,
           `ba`.`account_number`,
           CONCAT('$', `ba`.`balance`)
    FROM `clients` AS `c`
             JOIN `bank_accounts` AS `ba` ON `c`.`id` = `ba`.`client_id`
    WHERE `c`.`full_name` = `full_name`;
END $$
DELIMITER ;



