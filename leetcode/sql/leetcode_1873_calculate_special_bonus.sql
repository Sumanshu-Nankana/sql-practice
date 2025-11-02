-- Create Table
Create table If Not Exists Employees (employee_id int, name varchar(30), salary int)

-- Insert Data
Truncate table Employees
insert into Employees (employee_id, name, salary) values ('2', 'Meir', '3000')
insert into Employees (employee_id, name, salary) values ('3', 'Michael', '3800')
insert into Employees (employee_id, name, salary) values ('7', 'Addilyn', '7400')
insert into Employees (employee_id, name, salary) values ('8', 'Juan', '6100')
insert into Employees (employee_id, name, salary) values ('9', 'Kannon', '7700')

-- Write your PostgreSQL query statement below
-- We can use LEFT()
select employee_id, (case when employee_id%2 = 1 and LEFT(name,1) <> 'M' THEN salary ELSE 0 END) as bonus
from Employees order by employee_id

-- We can also use NOT LIKE
select employee_id, (case when employee_id%2 = 1 and name not like 'M%' THEN salary ELSE 0 END) as bonus
from Employees order by employee_id