SELECT 
    *
FROM
    `authors`;

USE `book_library`;

-- 1. Find Book Titles

SELECT 
    `title`
FROM
    `books`
WHERE
    `title` LIKE 'the%'
ORDER BY `id`;

-- 2. Replace Titles

SELECT 
    REPLACE(`title`, 'The', '***') AS `Title`
FROM
    `books`
WHERE
    SUBSTRING(`title`, 1, 3) = 'The'
ORDER BY `id`;

-- 03. Sum Cost of All Books

SELECT 
    SUM(`cost`)
FROM
    `books`;

SELECT 
    *
FROM
    `books`;


-- 04. Days Lived

SELECT 
    CONCAT(`first_name`, ' ', `last_name`) AS 'Full Name',
    DATEDIFF(`died`, `born`) AS 'Days Lived'
FROM
    `authors`;

-- 5. Harry Potter Books

SELECT 
    `title`
FROM
    `books`
WHERE
    `title` LIKE '%Harry Potter%'
ORDER BY `id`;



