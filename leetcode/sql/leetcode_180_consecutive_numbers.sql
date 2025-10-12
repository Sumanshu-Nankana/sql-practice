-- Create Table
Create table If Not Exists Logs (id int, num int)

-- Insert Data

Truncate table Logs
insert into Logs (id, num) values ('1', '1')
insert into Logs (id, num) values ('2', '1')
insert into Logs (id, num) values ('3', '1')
insert into Logs (id, num) values ('4', '2')
insert into Logs (id, num) values ('5', '1')
insert into Logs (id, num) values ('6', '2')
insert into Logs (id, num) values ('7', '2')

-- Write your PostgreSQL query statement below
with cte as (
SELECT *, LEAD(num, 1) OVER (ORDER BY id) as next_num, LEAD(num, 2) OVER( ORDER BY id) as next_to_next_num from logs)
select distinct num as ConsecutiveNums from cte where num = next_num and next_num = next_to_next_num