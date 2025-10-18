-- Create Table
Create table If Not Exists Employee (id int, name varchar(255), salary int, managerId int);

-- Insert Data
Truncate table Employee;
insert into Employee (id, name, salary, managerId) values ('1', 'Joe', '70000', '3');
insert into Employee (id, name, salary, managerId) values ('2', 'Henry', '80000', '4');
insert into Employee (id, name, salary, managerId) values ('3', 'Sam', '60000', NULL);
insert into Employee (id, name, salary, managerId) values ('4', 'Max', '90000', NULL);

-- Write your PostgreSQL query statement below
SELECT e1.name as Employee
FROM employee e1 JOIN
employee e2 on e1.managerid = e2.id
where e1.salary > e2.salary