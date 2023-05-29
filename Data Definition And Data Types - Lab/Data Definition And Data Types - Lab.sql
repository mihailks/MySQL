create database gamebar;
use gamebar;

-- 01. Create Tables
CREATE TABLE employees (
    id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL
);

CREATE TABLE categories (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL
);

CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    category_id INT NOT NULL
);

use gamebar;

-- 02. Insert Data in Tables
insert into employees (first_name, last_name)
values  ('test', 'test'),
		('test', 'test'),
		('test', 'test');
     
     
-- 03. Alter Tables
alter table employees 
add column 
middle_name varchar(50);


-- 04. Adding Constraints
ALTER TABLE `products` 
ADD CONSTRAINT `fk_id_products_categories`
FOREIGN KEY (`category_id`)
REFERENCES `categories` (`id`);


 -- 05. Modifying Columns
 alter table employees
 change column middle_name
 middle_name varchar(100);


        
