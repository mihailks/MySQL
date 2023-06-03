USE `camp`;

SELECT *
FROM `campers`;

-- 1. Mountains and Peaks

CREATE TABLE `mountains`
(
    `id`   INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(50)
);

CREATE TABLE `peaks`
(
    `id`          INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    `name`        VARCHAR(50),
    `mountain_id` INT,
    CONSTRAINT `fk_peaks_mountains`
        FOREIGN KEY (`mountain_id`)
            REFERENCES `mountains` (`id`)
);

-- 2. Trip Organization

SELECT *
FROM `campers`;

SELECT *
FROM `vehicles`;


SELECT `driver_id`, `vehicle_type`, CONCAT(`first_name`, ' ', `last_name`) AS `driver_name`
FROM `campers` AS `c`
         JOIN `vehicles` AS `v` ON `c`.`id` = `v`.`driver_id`;

-- 3. SoftUni Hiking

SELECT * from `routes`;

SELECT r.`starting_point` as 'route_starting_point',
r.end_point as 'route_ending_point',
`leader_id`,
concat_ws(' ', `first_name`, `last_name`) as leader_name
from `routes` as r
JOIN `campers` as c on r.`leader_id`=c.`id`;

-- 4. Delete Mountains

DROP TABLE `peaks`;
DROP TABLE `mountains`;

CREATE TABLE `mountains`
(
    `id`   INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(50)
);

CREATE TABLE `peaks`
(
    `id`          INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    `name`        VARCHAR(50),
    `mountain_id` INT,
    CONSTRAINT `fk_peaks_mountains`
        FOREIGN KEY (`mountain_id`)
            REFERENCES `mountains` (`id`)
on DELETE CASCADE
);










