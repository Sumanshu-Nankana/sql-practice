-- Create Table
Create table If Not Exists Employee (id int, name varchar(255), salary int, departmentId int)
Create table If Not Exists Department (id int, name varchar(255))

-- Insert Data
Truncate table Employee
insert into Employee (id, name, salary, departmentId) values ('1', 'Joe', '70000', '1')
insert into Employee (id, name, salary, departmentId) values ('2', 'Jim', '90000', '1')
insert into Employee (id, name, salary, departmentId) values ('3', 'Henry', '80000', '2')
insert into Employee (id, name, salary, departmentId) values ('4', 'Sam', '60000', '2')
insert into Employee (id, name, salary, departmentId) values ('5', 'Max', '90000', '1')
Truncate table Department
insert into Department (id, name) values ('1', 'IT')
insert into Department (id, name) values ('2', 'Sales')

-- Write your PostgreSQL query statement below
with cte as(
SELECT *, DENSE_RANK() OVER(partition by departmentId  ORDER BY SALARY DESC) as ranking FROM EMPLOYEE),
cte2 as (select name as Employee, salary, departmentId from cte where ranking = 1)
select name as Department, Employee, salary  from cte2 join department on cte2.departmentId = department.id

--Write your PostgreSQL query statement below (JOIN earlier) to make it more efficient
WITH cte AS (
  SELECT
      e.name AS Employee,
      e.salary,
      d.name AS Department,
      DENSE_RANK() OVER (PARTITION BY e.departmentId ORDER BY e.salary DESC) AS rnk
  FROM Employee e
  JOIN Department d ON e.departmentId = d.id
)
SELECT Department, Employee, salary
FROM cte
WHERE rnk = 1;