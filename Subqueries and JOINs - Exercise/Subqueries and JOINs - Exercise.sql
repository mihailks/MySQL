use soft_uni;

-- 1. Employee Address

select e.employee_id,
       e.job_title,
       a.address_id,
       a.address_text
from employees as e
         join
     addresses as a on e.address_id = a.address_id
order by a.address_id asc
limit 5;

-- 2. Addresses with Towns
select e.first_name, e.last_name, t.name, a.address_text
from employees as e
         join addresses as a on e.address_id = a.address_id
         join towns as t on a.town_id = t.town_id
order by first_name, last_name
limit 5;

-- 3. Sales Employee