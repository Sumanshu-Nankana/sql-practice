-- Create Table
Create table If Not Exists Triangle (x int, y int, z int);

-- Insert Data
Truncate table Triangle;
insert into Triangle (x, y, z) values ('13', '15', '30');
insert into Triangle (x, y, z) values ('10', '20', '15');

-- Write your PostgreSQL query statement below
-- Write your PostgreSQL query statement below
SELECT *, (CASE
			WHEN x+y > z and y+z > x and x+z > y THEN 'Yes' ELSE 'No' END
) as triangle
FROM TRIANGLE