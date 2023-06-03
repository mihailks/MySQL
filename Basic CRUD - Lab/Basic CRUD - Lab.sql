use hotel;

-- 01: Select Employee Information

SELECT 
    id, first_name, last_name, job_title
FROM
    employees
ORDER BY id;

-- 02. Select Employees with Filter

SELECT 
    id,
    CONCAT(first_name, ' ', last_name) AS full_name,
    job_title,
    salary
FROM
    employees
WHERE
    salary > 1000
ORDER BY id;

-- 03. Update Salary and Select

UPDATE employees 
SET 
    salary = salary + 100
WHERE
    job_title = 'Manager';

SELECT 
    salary
FROM
    employees;

-- 04. Top Paid Employee

CREATE VIEW employees_view AS
    SELECT 
        *
    FROM
        employees
    ORDER BY salary DESC
    LIMIT 1;

SELECT 
    *
FROM
    employees_view;

-- 05. Select Employees by Multiple Filters

SELECT 
    id, first_name, last_name, job_title, department_id, salary
FROM
    employees
WHERE
    department_id = 4 AND salary >= 1000;

-- 06. Delete from Table

DELETE FROM employees 
WHERE
    department_id IN (1 , 2);

SELECT 
    *
FROM
    employees
ORDER BY id;
