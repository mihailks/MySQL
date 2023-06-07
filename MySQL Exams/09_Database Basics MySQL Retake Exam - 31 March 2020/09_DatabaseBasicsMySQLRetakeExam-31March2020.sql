CREATE DATABASE `instd`;

USE `instd`;

CREATE TABLE `users`
(
    `id`        INT PRIMARY KEY NOT NULL,
    `username`  VARCHAR(30)     NOT NULL UNIQUE,
    `password`  VARCHAR(30)     NOT NULL,
    `email`     VARCHAR(50)     NOT NULL,
    `gender`    CHAR(1)         NOT NULL,
    `age`       INT             NOT NULL,
    `job_title` VARCHAR(40)     NOT NULL,
    `ip`        VARCHAR(30)     NOT NULL
);

CREATE TABLE `addresses`
(
    `id`      INT PRIMARY KEY AUTO_INCREMENT,
    `address` VARCHAR(30) NOT NULL,
    `town`    VARCHAR(30) NOT NULL,
    `country` VARCHAR(30) NOT NULL,
    `user_id` INT         NOT NULL,
    CONSTRAINT `fk_1`
        FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
);


CREATE TABLE `photos`
(
    `id`          INT PRIMARY KEY AUTO_INCREMENT,
    `description` TEXT     NOT NULL,
    `date`        DATETIME NOT NULL,
    `views`       INT      NOT NULL DEFAULT 0
);

CREATE TABLE `comments`
(
    `id`       INT PRIMARY KEY AUTO_INCREMENT,
    `comment`  VARCHAR(255) NOT NULL,
    `date`     DATETIME     NOT NULL,
    `photo_id` INT          NOT NULL,
    CONSTRAINT `fk_2`
        FOREIGN KEY (`photo_id`) REFERENCES `photos` (`id`)

);

CREATE TABLE `users_photos`
(
    `user_id`  INT NOT NULL,
    `photo_id` INT NOT NULL,
    CONSTRAINT `fk_3`
        FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
    CONSTRAINT `fk_4`
        FOREIGN KEY (`photo_id`) REFERENCES `photos` (`id`)
);


CREATE TABLE `likes`
(
    `id`       INT PRIMARY KEY AUTO_INCREMENT,
    `photo_id` INT,
    `user_id`  INT,
    CONSTRAINT `fk_5`
        FOREIGN KEY (`photo_id`) REFERENCES `photos` (`id`),
    CONSTRAINT `fk_6`
        FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
);

-- 02. Insert

INSERT INTO `addresses`(`address`, `town`, `country`, `user_id`)
SELECT `username`,
       `password`,
       `ip`,
       `age`
FROM `users`
WHERE `gender` = 'M';

SELECT *
FROM `addresses`;

UPDATE `addresses`
SET `country` = (
    CASE
        WHEN `country` LIKE 'B%' THEN 'Blocked'
        WHEN `country` LIKE 'T%' THEN 'Test'
        WHEN `country` LIKE 'P%' THEN 'In Progress'
        ELSE `country`
        END
    );


-- 04. Delete

DELETE
FROM `addresses`
WHERE `id` % 3 = 0;



SELECT *
FROM `addresses`;

-- 05. Users

SELECT `username`, `gender`, `age`
FROM `users`
ORDER BY `age` DESC, `username`;

-- 06. Extract 5 most commented photos

SELECT `p`.`id`,
       `p`.`date`            AS `date_and_time`,
       `p`.`description`,
       COUNT(`c`.`photo_id`) AS `commentsCount`
FROM `photos` AS `p`
         JOIN `comments` AS `c` ON `p`.`id` = `c`.`photo_id`
GROUP BY `p`.`id`
ORDER BY `commentsCount` DESC, `p`.`id`
LIMIT 5;

-- 07. Lucky users

SELECT *
FROM `users_photos`
WHERE `photo_id` = `user_id`;


SELECT CONCAT(`u`.`id`, ' ', `u`.`username`) AS `id_username`,
       `u`.`email`
FROM `users` AS `u`
         JOIN `users_photos` AS `up` ON `u`.`id` = `up`.`user_id`
WHERE `photo_id` = `user_id`
ORDER BY `id`;

-- 08. Count likes and comments

SELECT *
FROM `comments` AS `c`
         LEFT JOIN `likes` AS `l` ON `c`.`photo_id` = `l`.`photo_id`;


SELECT `p`.`id`                 AS `photo_id`,
       COUNT(DISTINCT `l`.`id`) AS `likes_count`,
       COUNT(DISTINCT `c`.`id`) AS `comments_count`

FROM `photos` AS `p`
         LEFT JOIN `comments` AS `c` ON `p`.`id` = `c`.`photo_id`
         LEFT JOIN `likes` AS `l` ON `p`.`id` = `l`.`photo_id`
GROUP BY `p`.`id`
ORDER BY `likes_count` DESC, `comments_count` DESC, `p`.`id`;


SELECT *
FROM `photos` AS `p`
         JOIN `comments` AS `c` ON `p`.`id` = `c`.`photo_id`
         JOIN `likes` AS `l` ON `p`.`id` = `l`.`photo_id`;

SELECT *
FROM `photos` AS `p`
         LEFT JOIN `comments` AS `c` ON `p`.`id` = `c`.`photo_id`
         LEFT JOIN `likes` AS `l` ON `p`.`id` = `l`.`photo_id`;


SELECT `photo_id`, COUNT(`c`.`id`)
FROM `photos` AS `p`
         JOIN `comments` AS `c` ON `p`.`id` = `c`.`photo_id`
GROUP BY `photo_id`;

-- 09. The photo on the tenth day of the month

