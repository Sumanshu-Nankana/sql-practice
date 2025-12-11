-- Create Table
CREATE TABLE if not exists Employees (
    employee_id INT,
    employee_name VARCHAR(100),
    manager_id INT,
    salary INT,
    department VARCHAR(50)
);
-- Insert Data
Truncate table Employees;
insert into Employees (employee_id, employee_name, manager_id, salary, department) values ('1', 'Alice', NULL, '12000', 'Executive');
insert into Employees (employee_id, employee_name, manager_id, salary, department) values ('2', 'Bob', '1', '10000', 'Sales');
insert into Employees (employee_id, employee_name, manager_id, salary, department) values ('3', 'Charlie', '1', '10000', 'Engineering');
insert into Employees (employee_id, employee_name, manager_id, salary, department) values ('4', 'David', '2', '7500', 'Sales');
insert into Employees (employee_id, employee_name, manager_id, salary, department) values ('5', 'Eva', '2', '7500', 'Sales');
insert into Employees (employee_id, employee_name, manager_id, salary, department) values ('6', 'Frank', '3', '9000', 'Engineering');
insert into Employees (employee_id, employee_name, manager_id, salary, department) values ('7', 'Grace', '3', '8500', 'Engineering');
insert into Employees (employee_id, employee_name, manager_id, salary, department) values ('8', 'Hank', '4', '6000', 'Sales');
insert into Employees (employee_id, employee_name, manager_id, salary, department) values ('9', 'Ivy', '6', '7000', 'Engineering');
insert into Employees (employee_id, employee_name, manager_id, salary, department) values ('10', 'Judy', '6', '7000', 'Engineering');

-- Write your PostgreSQL query statement below
WITH RECURSIVE cte AS (
    SELECT
        employee_id,
        employee_name,
        manager_id,
        salary,
        1 AS level
    FROM
        employees
    WHERE
        manager_id IS NULL
    UNION ALL
    SELECT
        e.employee_id,
        e.employee_name,
        e.manager_id,
        e.salary,
        cte.level + 1 AS level
    FROM
        employees e
    JOIN
        cte ON e.manager_id = cte.employee_id
),
cte1 AS (
    SELECT
        manager_id,
        employee_id AS subordinate_id,
        employee_name AS subordinate_name,
        salary AS subordinate_salary
    FROM
        employees
    WHERE
        manager_id IS NOT NULL

    UNION ALL

    SELECT
        cte1.manager_id,
        E.employee_id AS subordinate_id,
        E.employee_name AS subordinate_name,
        E.salary AS subordinate_salary
    FROM
        employees AS E
    INNER JOIN
        cte1  ON E.manager_id = cte1.subordinate_id
),
cte2 as(
SELECT manager_id, count(subordinate_id) as team_size,
sum(subordinate_salary) as total_subordinate_salary
from cte1
group by manager_id)
SELECT
    cte.employee_id,
    cte.employee_name,
    cte.level,
    COALESCE(cte2.team_size, 0) AS team_size,
    cte.salary + COALESCE(cte2.total_subordinate_salary, 0) AS budget
FROM
    cte
LEFT JOIN
    cte2 ON cte.employee_id = cte2.manager_id
ORDER BY
    level ASC,
    budget DESC,
    employee_name ASC;