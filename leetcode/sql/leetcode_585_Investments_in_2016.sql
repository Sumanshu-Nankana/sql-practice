-- Create Table
Create Table If Not Exists Insurance (pid int, tiv_2015 float, tiv_2016 float, lat float, lon float)

-- Insert Data
Truncate table Insurance
insert into Insurance (pid, tiv_2015, tiv_2016, lat, lon) values ('1', '10', '5', '10', '10')
insert into Insurance (pid, tiv_2015, tiv_2016, lat, lon) values ('2', '20', '20', '20', '20')
insert into Insurance (pid, tiv_2015, tiv_2016, lat, lon) values ('3', '10', '30', '20', '20')
insert into Insurance (pid, tiv_2015, tiv_2016, lat, lon) values ('4', '10', '40', '40', '40')

-- Write your PostgreSQL query statement below
-- Write your PostgreSQL query statement below

WITH UniqueLocations AS (
    SELECT lat, lon
    FROM Insurance
    GROUP BY lat, lon
    HAVING COUNT(*) = 1
),
DuplicateTIV AS (
    SELECT tiv_2015
    FROM Insurance
    GROUP BY tiv_2015
    HAVING COUNT(*) > 1
)
SELECT
    ROUND(CAST(SUM(tiv_2016) AS DECIMAL), 2) AS tiv_2016
FROM Insurance
WHERE
    (lat, lon) IN (SELECT lat, lon FROM UniqueLocations)
    AND
    tiv_2015 IN (SELECT tiv_2015 FROM DuplicateTIV);