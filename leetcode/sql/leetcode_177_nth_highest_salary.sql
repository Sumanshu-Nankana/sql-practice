-- We need to give e.salary, because SALARY is a output variable as well in Function statement
-- if we normally use SELECT salary, DENSE_RANK....
-- Then query will give error as - column reference "salary" is ambiguous
-- Because query get confuse which 'salary' we are referring
-- PostgreSQL can’t tell if salary refers to: the table column employee.salary, or
-- the output variable salary from your function’s RETURNS TABLE (salary INT) clause.

CREATE OR REPLACE FUNCTION NthHighestSalary(N INT) RETURNS TABLE (Salary INT) AS $$
BEGIN
  RETURN QUERY (
    -- Write your PostgreSQL query statement below.
    with cte as (SELECT e.salary, DENSE_RANK() OVER (ORDER BY e.SALARY DESC) AS RANKING FROM EMPLOYEE e)
    SELECT DISTINCT COALESCE(e.SALARY, NULL) FROM CTE e WHERE RANKING = N
  );
END;
$$ LANGUAGE plpgsql;

---

CREATE OR REPLACE FUNCTION NthHighestSalary(N INT) RETURNS TABLE (Salary INT) AS $$
BEGIN
  RETURN QUERY (
    -- Write your PostgreSQL query statement below.
    with cte as (SELECT e.salary, DENSE_RANK() OVER (ORDER BY e.SALARY DESC) AS RANKING FROM EMPLOYEE e)
    SELECT(SELECT DISTINCT e.SALARY FROM CTE e WHERE RANKING = N)
  );
END;
$$ LANGUAGE plpgsql;

---

CREATE OR REPLACE FUNCTION NthHighestSalary(N INT) RETURNS TABLE (Salary INT) AS $$
BEGIN
  RETURN QUERY (
    -- Write your PostgreSQL query statement below.
    with cte as (SELECT e.salary, DENSE_RANK() OVER (ORDER BY e.SALARY DESC) AS RANKING FROM EMPLOYEE e)
    SELECT COALESCE((SELECT DISTINCT e.SALARY FROM CTE e WHERE RANKING = N), NULL)
  );
END;
$$ LANGUAGE plpgsql;