-- Create Table
Create table If Not Exists MyNumbers (num int);

-- Insert Data
Truncate table MyNumbers;
insert into MyNumbers (num) values ('8');
insert into MyNumbers (num) values ('8');
insert into MyNumbers (num) values ('3');
insert into MyNumbers (num) values ('3');
insert into MyNumbers (num) values ('1');
insert into MyNumbers (num) values ('4');
insert into MyNumbers (num) values ('5');
insert into MyNumbers (num) values ('6');

-- Write your PostgreSQL query statement below
SELECT (
  (SELECT num FROM mynumbers GROUP BY num HAVING COUNT(*) = 1 ORDER BY num DESC LIMIT 1)
) AS num;

--
-- Reason (to use outer SELECT)
SELECT num from mynumbers where num = 100 --> This will not return anything (no-rows)
-- But if we wrap under SELECT
SELECT(SELECT num from mynumbers where num = 100) -- This will return 1 row (null - if inner query not return anything)