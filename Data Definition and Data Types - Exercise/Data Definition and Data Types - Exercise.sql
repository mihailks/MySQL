create database minions;

use minions;
-- 1 Create Tables
CREATE TABLE minions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50),
    age INT
);

CREATE TABLE towns (
    town_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50)
);

alter table towns
rename column town_id to id; 

-- 2 Alter Minions Table

alter table minions
add column town_id int;

alter table minions
add constraint `fk_minions_towns`
foreign key minions(town_id)
references towns(id);


-- 3 Insert Records in Both Tables
use minions;

Insert into towns(id,name)
values
(1,'Sofia'),
(2,'Plovdiv'),
(3,'Varna');

insert into minions (id, name, age, town_id)
values
(1,'Kevin', 22,1),
(2,'Bob', 15,3),
(3,'Steward', null,2);

-- 4 Truncate Table Minions
truncate Table Minions;

-- 5 Drop All Tables
drop table minions;
drop table towns;

-- 6 Create Table People

CREATE TABLE people (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    picture BLOB,
    height DOUBLE(10 , 2 ),
    weight DOUBLE(10 , 2 ),
    gender CHAR(1) NOT NULL,
    birthdate DATE NOT NULL,
    biography TEXT
);

insert into people(name, gender, birthdate)
values
('testm','m',date(now())),
('testf','f',date(now())),
('testf','f',date(now())),
('testm','m',date(now())),
('testm','m',date(now()));

-- 7 Create Table Users

CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(30) UNIQUE NOT NULL,
    password VARCHAR(26) UNIQUE NOT NULL,
    profile_picture BLOB,
    last_login_time TIMESTAMP,
    is_deleted BOOLEAN
);

insert into users(username, password)
values
('test1','test6'),
('test2','test7'),
('test3','test8'),
('test4','test9'),
('test5','test10');


-- 8 Change Primary Key

alter table users
drop primary key,
add constraint pk_users2
primary key users(id, username);


-- 9 Set Default Value of a Field

alter table users
change column last_login_time last_login_time TIMESTAMP default now();

-- 10 Set Unique Field

alter table users
drop primary key,
add constraint pk_users
primary key users(id),
change column username
username varchar (30) unique;

-- 11 Movies Database

create database movies;
CREATE TABLE directors (
    id INT PRIMARY KEY AUTO_INCREMENT,
    director_name VARCHAR(50) NOT NULL,
    notes TEXT
);

CREATE TABLE genres (
    id INT PRIMARY KEY AUTO_INCREMENT,
    genre_name VARCHAR(50) NOT NULL,
    notes TEXT
);

CREATE TABLE categories (
    id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(50) NOT NULL,
    notes TEXT
);

CREATE TABLE movies (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(100) NOT NULL,
    director_id INT,
    copyright_year INT,
    length DOUBLE(5 , 2 ),
    genre_id INT,
    category_id INT,
    rating DOUBLE(10 , 1 ),
    notes TEXT
);


insert into directors(director_name)
values('test1'),
('test2'),
('test3'),
('test4'),
('test5');

insert into genres (genre_name)
values('test1'),
('test2'),
('test3'),
('test4'),
('test5');

insert into categories(category_name)
values('test1'),
('test2'),
('test3'),
('test4'),
('test5');

insert into movies(title)
values('test1'),
('test2'),
('test3'),
('test4'),
('test5');



--  Car Rental Database

create database car_rental;

use car_rental;

CREATE TABLE categories (
    id INT PRIMARY KEY AUTO_INCREMENT,
    category VARCHAR(30) NOT NULL,
    daily_rate DOUBLE(100 , 2 ),
    weekly_rate DOUBLE(100 , 2 ),
    monthly_rate DOUBLE(100 , 2 ),
    weekend_rate DOUBLE(100 , 2 )
);

insert into categories(category)
values('test1'),
('test2'),
('test3');

CREATE TABLE cars (
    id INT PRIMARY KEY AUTO_INCREMENT,
    plate_number VARCHAR(20),
    make VARCHAR(20),
    model VARCHAR(20),
    car_year INT,
    category_id INT,
    doors INT,
    picture BLOB,
    car_condition VARCHAR(20),
    available BOOLEAN NOT NULL
);

insert into cars(available)
values (true),
(true),
(false);

CREATE TABLE employee (
    id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    title VARCHAR(50),
    notes TEXT
);

insert into employee(first_name, last_name)
values('fname1','fname11'),
('fname2','fname22'),
('fname3','fname33');

CREATE TABLE customers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    driver_licence_number INT NOT NULL,
    full_name VARCHAR(70) NOT NULL,
    address VARCHAR(100),
    city VARCHAR(50),
    zip_code VARCHAR(10),
    notes TEXT
);

insert into customers(driver_licence_number,full_name )
values('111', 'test1'),
('222', 'test2'),
('333', 'test3');

CREATE TABLE rental_orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT,
    customer_id INT,
    car_id INT,
    car_condition VARCHAR(10),
    tank_level VARCHAR(10),
    kilometrage_start INT NOT NULL,
    kilometrage_end INT NOT NULL,
    total_kilometrage INT NOT NULL,
    start_date DATE,
    end_date DATE,
    total_days INT,
    rate_applied VARCHAR(20),
    tax_rate VARCHAR(10),
    order_status BOOLEAN,
    notes TEXT
);

INSERT INTO rental_orders(kilometrage_start,kilometrage_end,total_kilometrage)
VALUES('1','10','10'),
('2','20','20'),
('3','30','30');

-- 13 Basic Insert

create database soft_uni;
use soft_uni;

CREATE TABLE towns (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50)
);

CREATE TABLE addresses (
    id INT PRIMARY KEY AUTO_INCREMENT,
    address_text VARCHAR(100),
    town_id INT,
    FOREIGN KEY (town_id)
        REFERENCES towns (id)
);


CREATE TABLE departments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL
);

CREATE TABLE employees (
    id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    middle_name VARCHAR(50),
    last_name VARCHAR(50),
    job_title VARCHAR(50),
    department_id INT,
    hire_date VARCHAR(50),
    salary DOUBLE,
    address_id INT,
    FOREIGN KEY (department_id)
        REFERENCES departments (ID),
    FOREIGN KEY (address_id)
        REFERENCES addresses (id)
);

insert into towns(name)
values('Sofia'),
('Plovdiv'),
('Varna'),
('Burgas');

insert into departments(name)
values ('Engineering'),
('Sales'),
('Marketing'),
('Software Development'),
('Quality Assurance');


insert into employees(first_name, middle_name, last_name, job_title, department_id, hire_date, salary)
values  ('Ivan', 'Ivanov',' Ivanov','.NET Developer','4','01/02/2013','3500.00'),
		('Petar', 'Petrov ', 'Petrov','Senior Engineer','1','02/03/2004','4000.00'),
		('Maria', 'Petrova ', 'Ivanova','Intern','5','28/08/2016','525.25'),
		('Georgi', 'Terziev ','Ivanov','CEO','2','09/12/2007','3000.00'),
		('Peter', 'Pan',' Pan','Intern','3','28/08/2016',' 599.88');

-- 14 Basic Select All Fields

SELECT 
    *
FROM
    towns;
SELECT 
    *
FROM
    departments;
SELECT 
    *
FROM
    employees;


-- 15  Basic Select All Fields and Order Them

SELECT 
    *
FROM
    towns
ORDER BY name ASC;
SELECT 
    *
FROM
    departments
ORDER BY name ASC;
SELECT 
    *
FROM
    employees
ORDER BY salary DESC;



-- 16  Basic Select Some Fields

select name from towns order by name ASC;
select name from departments order by name asc;
select first_name, last_name, job_title, salary  from employees order by salary desc;

-- 17  Increase Employees Salary

update employees set salary = salary * 1.1 where id>0;
select salary from employees;





