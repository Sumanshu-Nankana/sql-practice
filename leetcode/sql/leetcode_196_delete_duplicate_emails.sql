-- Write your PostgreSQL query statement below
with cte as(
SELECT *, ROW_NUMBER() OVER(partition by email order by id) as rnk from person)
DELETE FROM person where id in (select id from cte where rnk > 1)

-- Method-2
with cte as
(select email, min(id) as id_to_keep from person group by email)
delete from person where id not in (select id_to_keep from cte )