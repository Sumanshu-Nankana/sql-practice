-- Create Table
Create table If Not Exists Person (Id int, Email varchar(255))

-- Insert Data
Truncate table Person
insert into Person (id, email) values ('1', 'john@example.com')
insert into Person (id, email) values ('2', 'bob@example.com')
insert into Person (id, email) values ('3', 'john@example.com')

-- Write your PostgreSQL query statement below
with cte as(
SELECT *, ROW_NUMBER() OVER(partition by email order by id) as rnk from person)
DELETE FROM person where id in (select id from cte where rnk > 1)

-- Method-2
with cte as
(select email, min(id) as id_to_keep from person group by email)
delete from person where id not in (select id_to_keep from cte )