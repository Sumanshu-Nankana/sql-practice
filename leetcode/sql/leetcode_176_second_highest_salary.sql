-- Creating the table
CREATE TABLE IF NOT EXISTS EMPLOYEE (
	id int PRIMARY KEY,  -- PRIMARY KEY implies NOT NULL
	salary int NOT NULL  -- Enforces every employee must have a Salary value
);

-- Empty the table if data exists
TRUNCATE TABLE EMPLOYEE;

-- insert the sample records
INSERT INTO EMPLOYEE (id, salary) VALUES
(1, 100),
(2, 200),
(3, 100);

-- Answer Query (Using DENSE_RANK and LIMIT)
WITH employee_salary AS (SELECT id, salary, DENSE_RANK() OVER (ORDER BY SALARY DESC) as ranking
from employee)
SELECT(
SELECT salary as SecondHighestSalary FROM employee_salary WHERE ranking = 2
LIMIT 1  -- Ensures the subquery returns only one value, even with ties
);

-- Answer (using DENSE_RANK and Distinct)
WITH employee_salary AS (SELECT id,  salary, DENSE_RANK() OVER (ORDER BY SALARY DESC) as ranking
from employee)
SELECT(
SELECT DISTINCT salary as SecondHighestSalary FROM employee_salary WHERE ranking = 2
);

-- Answer using COALESCE
with cte as (SELECT id, salary, dense_rank() over (order by salary desc) as ranking FROM EMPLOYEE)
SELECT COALESCE((SELECT distinct salary  FROM CTE where ranking = 2), NULL) as SecondHighestSalary


-- Answer (Using OFFSET and LIMIT)
SELECT (
    SELECT DISTINCT SALARY as secondhighestsalary from employee
    order by salary desc
    offset 1 LIMIT 1);