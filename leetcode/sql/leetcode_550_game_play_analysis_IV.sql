-- Create Table
Create table If Not Exists Activity (player_id int, device_id int, event_date date, games_played int);

-- Insert Data
Truncate table Activity;
insert into Activity (player_id, device_id, event_date, games_played) values ('1', '2', '2016-03-01', '5');
insert into Activity (player_id, device_id, event_date, games_played) values ('1', '2', '2016-03-02', '6');
insert into Activity (player_id, device_id, event_date, games_played) values ('2', '3', '2017-06-25', '1');
insert into Activity (player_id, device_id, event_date, games_played) values ('3', '1', '2016-03-02', '0');
insert into Activity (player_id, device_id, event_date, games_played) values ('3', '4', '2018-07-03', '5');

-- Write your PostgreSQL query statement below
with cte as(
select *,
    LEAD(event_date) over(partition by player_id order by event_date) as next_login_date,
    DENSE_RANK() OVER(PARTITION BY player_id order by event_date) as rnk from activity)
select
    round(cast(COUNT(CASE WHEN next_login_date - event_date = 1 THEN 1 END) as decimal) / count(*),2) as fraction
from cte where rnk = 1
