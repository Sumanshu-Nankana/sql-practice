Create table If Not Exists Sales (sale_id int, product_id int, year int, quantity int, price int);
Truncate table Sales;
insert into Sales (sale_id, product_id, year, quantity, price) values ('1', '100', '2008', '10', '5000');
insert into Sales (sale_id, product_id, year, quantity, price) values ('2', '100', '2009', '12', '5000');
insert into Sales (sale_id, product_id, year, quantity, price) values ('7', '200', '2011', '15', '9000');

-- Write your PostgreSQL query statement below
SELECT product_id, year as first_year, quantity, price from sales where
(product_id, year) in (
SELECT product_id, min(year) as first_year from sales group by product_id)

-- Using RANK()
with cte as(
SELECT *, RANK() OVER (PARTITION BY product_id ORDER BY year) as rnk from sales)
select product_id, year as first_year, quantity, price from cte where rnk = 1

-- Using JOIN
with cte as (
SELECT product_id, min(year) as first_year from sales group by product_id)
SELECT cte.product_id, cte.first_year, sales.quantity, sales.price FROM cte JOIN sales
ON
cte.product_id = sales.product_id and
cte.first_year = sales.year