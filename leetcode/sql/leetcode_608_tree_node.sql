-- Create Table
Create table If Not Exists Tree (id int, p_id int);

-- Insert Data
Truncate table Tree;
insert into Tree (id, p_id) values ('1', NULL);
insert into Tree (id, p_id) values ('2', '1');
insert into Tree (id, p_id) values ('3', '1');
insert into Tree (id, p_id) values ('4', '2');
insert into Tree (id, p_id) values ('5', '2');

-- Write your PostgreSQL query statement below
-- https://www.postgresql.org/docs/current/sql-syntax-lexical.html#SQL-SYNTAX-CONSTANTS
with cte as(
select t1.id, t1.p_id as parent, t2.id as child from tree t1
LEFT JOIN
tree t2 on
t1.id = t2.p_id)
select DISTINCT id, (CASE
			WHEN parent IS Null THEN 'Root'
			WHEN child IS Null THEN 'Leaf'
			ELSE 'Inner' END) as type
			from cte