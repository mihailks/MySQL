CREATE DATABASE `CJMS`;

USE `CJMS`;

CREATE TABLE `planets`
(
    `id`   INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(30) NOT NULL
);

CREATE TABLE `spaceports`
(
    `id`        INT PRIMARY KEY AUTO_INCREMENT,
    `name`      VARCHAR(50) NOT NULL,
    `planet_id` INT,
    CONSTRAINT `fk_spacesport_planets`
        FOREIGN KEY (`planet_id`) REFERENCES `planets` (`id`)
);

CREATE TABLE `spaceships`
(
    `id`               INT PRIMARY KEY AUTO_INCREMENT,
    `name`             VARCHAR(50) NOT NULL,
    `manufacturer`     VARCHAR(30) NOT NULL,
    `light_speed_rate` INT DEFAULT 0

);

CREATE TABLE `colonists`
(
    `id`         INT PRIMARY KEY AUTO_INCREMENT,
    `first_name` VARCHAR(20) NOT NULL,
    `last_name`  VARCHAR(20) NOT NULL,
    `ucn`        CHAR(10)    NOT NULL UNIQUE,
    `birth_date` DATE        NOT NULL
);

CREATE TABLE `journeys`
(
    `id`                       INT PRIMARY KEY                                          NOT NULL,
    `journey_start`            DATETIME                                                 NOT NULL,
    `journey_end`              DATETIME                                                 NOT NULL,
    `purpose`                  ENUM ('Medical', 'Technical', 'Educational', 'Military') NOT NULL,
    `destination_spaceport_id` INT,
    `spaceship_id`             INT,
    CONSTRAINT `fk_journeys_spaceports`
        FOREIGN KEY (`destination_spaceport_id`) REFERENCES `spaceports` (`id`),
    CONSTRAINT `fk_journeys_planets`
        FOREIGN KEY (`spaceship_id`) REFERENCES `spaceships` (`id`)
);

CREATE TABLE `travel_cards`
(
    `id`                 INT PRIMARY KEY AUTO_INCREMENT,
    `card_number`        CHAR(10)                                                NOT NULL UNIQUE,
    `job_during_journey` ENUM ('Pilot','Engineer', 'Trooper', 'Cleaner', 'Cook') NOT NULL,
    `colonist_id`        INT,
    `journey_id`         INT,
    CONSTRAINT `fk_travel_cards_colonist`
        FOREIGN KEY (`colonist_id`) REFERENCES `colonists` (`id`),
    CONSTRAINT `fk_travel_cards_journeys`
        FOREIGN KEY (`journey_id`) REFERENCES `journeys` (`id`)
);


-- 01. Insert

SELECT CASE
           WHEN `birth_date` > 1980 - 01 - 01 THEN CONCAT(YEAR(`birth_date`), DAY(`birth_date`), SUBSTRING(`ucn`, 1, 4))
           ELSE CONCAT(YEAR(`birth_date`), MONTH(`birth_date`), SUBSTRING(`ucn`, 1, 4))
           END,
       CASE
           WHEN `id` % 2 = 0 THEN 'Pilot'
           WHEN `id` % 3 = 0 THEN 'Cook'
           ELSE 'Engineer'
           END,
       SUBSTRING(`ucn`, 1, 1)
FROM `colonists`;

INSERT INTO `travel_cards`(`card_number`, `job_during_journey`, `colonist_id`, `journey_id`)
SELECT(
          CASE
              WHEN `c`.`birth_date` > '1980-01-01' THEN CONCAT_WS('', YEAR(`c`.`birth_date`), DAY(`c`.`birth_date`),
                                                                  SUBSTR(`c`.`ucn`, 1, 4))
              ELSE CONCAT_WS('', YEAR(`c`.`birth_date`), MONTH(`c`.`birth_date`), SUBSTR(`c`.`ucn`, 7, 10))
              END)          AS `card_number`,
      (
          CASE
              WHEN `id` % 2 = 0 THEN 'Pilot'
              WHEN `id` % 3 = 0 THEN 'Cook'
              ELSE 'Engineer'
              END)          AS `job_during_journey`,
      `c`.`id`,
      (SUBSTR(`ucn`, 1, 1)) AS `journey_id`
FROM `colonists` AS `c`
WHERE `c`.`id` BETWEEN 96 AND 100;


-- 02. Update

UPDATE `journeys`
SET `purpose` = (
    CASE
        WHEN `id` % 2 = 0 THEN 'Medical'
        WHEN `id` % 3 = 0 THEN 'Technical'
        WHEN `id` % 5 = 0 THEN 'Educational'
        WHEN `id` % 7 = 0 THEN 'Military'
        ELSE `purpose`
        END
    );


--  03.	Data Deletion

DELETE `c`
FROM `colonists` AS `c`
         LEFT JOIN `travel_cards` AS `tc` ON `c`.`id` = `tc`.`colonist_id`
WHERE `colonist_id` IS NULL;


-- 04.Extract all travel cards


SELECT `card_number`, `job_during_journey`
FROM `travel_cards`
ORDER BY `card_number`;


-- 05. Extract all colonists

SELECT `id`,
       CONCAT(`first_name`, ' ', `last_name`) AS `full_name`,
       `ucn`
FROM `colonists`
ORDER BY `first_name`, `last_name`, `id`;

-- 06. Extract all military journeys

SELECT `j`.`id`,
       `j`.`journey_start`,
       `j`.`journey_end`
FROM `journeys` AS `j`
WHERE `j`.`purpose` = 'Military'
ORDER BY `j`.`journey_start`;

-- 07. Extract all pilots

SELECT `c`.`id`,
       CONCAT(`c`.`first_name`, ' ', `c`.`last_name`) AS `full_name`
FROM `colonists` AS `c`
         JOIN `travel_cards` AS `tc` ON `c`.`id` = `tc`.`colonist_id`
WHERE `tc`.`job_during_journey` = 'Pilot'
ORDER BY `id`;

-- 08. Count all colonists

SELECT COUNT(*)
FROM `colonists` AS `c`
         JOIN `travel_cards` AS `tc` ON `c`.`id` = `tc`.`colonist_id`
         JOIN `journeys` AS `j` ON `tc`.`journey_id` = `j`.`id`
WHERE `purpose` = 'Technical';

-- 09.Extract the fastest spaceship

SELECT `ship`.`name` AS 'spaceship_name',
       `sp`.`name`   AS 'spaceport_name'
FROM `spaceships` AS `ship`
         JOIN `journeys` AS `j` ON `ship`.`id` = `j`.`spaceship_id`
         JOIN `spaceports` AS `sp` ON `j`.`destination_spaceport_id` = `sp`.`id`
ORDER BY `ship`.`light_speed_rate` DESC
LIMIT 1;

-- 10. Extract - pilots younger than 30 years

SELECT `s`.`name`         AS `name`,
       `s`.`manufacturer` AS `manufacturer`
FROM `colonists` AS `c`
         JOIN `travel_cards` AS `tc` ON `c`.`id` = `tc`.`colonist_id`
         JOIN `journeys` AS `j` ON `tc`.`journey_id` = `j`.`id`
         JOIN `spaceships` AS `s` ON `j`.`spaceship_id` = `s`.`id`
WHERE YEAR(`c`.`birth_date`) > YEAR(DATE_SUB('2019-01-01', INTERVAL 30 YEAR))
  AND `tc`.`job_during_journey` = 'Pilot'
ORDER BY `s`.`name`;


-- 11. Extract all educational mission

SELECT `p`.`name` AS 'planet_name',
       `s`.`name` AS 'spaceport_name'
FROM `planets` AS `p`
         JOIN `spaceports` AS `s` ON `p`.`id` = `s`.`planet_id`
         JOIN `journeys` AS `j` ON `s`.`id` = `j`.`destination_spaceport_id`
WHERE `purpose` = 'Educational'
ORDER BY `s`.`name` DESC;

-- 12. Extract all planets and their journey count


SELECT `p`.`name` AS 'planet_name', COUNT(`j`.`id`) AS `journeys_count`
FROM `planets` AS `p`
         JOIN `spaceports` AS `s` ON `p`.`id` = `s`.`planet_id`
         JOIN `journeys` AS `j` ON `s`.`id` = `j`.`destination_spaceport_id`
GROUP BY `planet_name`
ORDER BY `journeys_count` DESC, `planet_name`;

-- 13. Extract the shortest journey

SELECT `j`.`id`, `p`.`name` `planet_name`, `sp`.`name` `spaceport_name`, `j`.`purpose` `journey_purpose`
FROM `journeys` `j`
         JOIN `spaceports` `sp` ON `j`.`destination_spaceport_id` = `sp`.`id`
         JOIN `planets` `p` ON `sp`.`planet_id` = `p`.`id`
ORDER BY DATEDIFF(`j`.`journey_end`, `j`.`journey_start`)
LIMIT 1;

-- 14. Extract the less popular job

SELECT `tc`.`job_during_journey` AS `job_name`
FROM `travel_cards` AS `tc`
         JOIN `journeys` AS `j` ON `tc`.`journey_id` = `j`.`id`
WHERE timediff(j.`journey_start`, j.`journey_end`)
GROUP BY `tc`.`job_during_journey`

