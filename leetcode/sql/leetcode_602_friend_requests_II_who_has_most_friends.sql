-- Create Table
Create table If Not Exists RequestAccepted (requester_id int not null, accepter_id int null, accept_date date null);

-- Insert Data
Truncate table RequestAccepted;
insert into RequestAccepted (requester_id, accepter_id, accept_date) values ('1', '2', '2016/06/03');
insert into RequestAccepted (requester_id, accepter_id, accept_date) values ('1', '3', '2016/06/08');
insert into RequestAccepted (requester_id, accepter_id, accept_date) values ('2', '3', '2016/06/08');
insert into RequestAccepted (requester_id, accepter_id, accept_date) values ('3', '4', '2016/06/09');

-- Write your PostgreSQL query statement below
with cte as(
SELECT requester_id from RequestAccepted
UNION ALL
SELECT accepter_id from RequestAccepted
)
SELECT requester_id as id, count(*) as num from cte
group by requester_id
order by num desc limit 1


-- Follow UP : Write your PostgreSQL query statement below
with cte as (
SELECT requester_id from RequestAccepted
UNION ALL
SELECT accepter_id from RequestAccepted),
cte2 as(
select requester_id as id, count(*) as num from cte group by requester_id
),
cte3 as (
select id, num, dense_rank() over (order by num desc) as rnk from cte2)
select id, num from cte3 where rnk = 1