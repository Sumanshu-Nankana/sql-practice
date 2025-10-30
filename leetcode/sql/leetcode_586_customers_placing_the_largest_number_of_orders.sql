-- Create Table
Create table If Not Exists orders (order_number int, customer_number int)

-- Insert Data
Truncate table orders
insert into orders (order_number, customer_number) values ('1', '1')
insert into orders (order_number, customer_number) values ('2', '2')
insert into orders (order_number, customer_number) values ('3', '3')
insert into orders (order_number, customer_number) values ('4', '3')

-- Write your PostgreSQL query statement below
-- Method 1
with cte as(
select customer_number, count(*) as total_orders from orders group by customer_number)
select customer_number from cte order by total_orders desc limit 1

-- Method 2
SELECT customer_number
FROM orders
GROUP BY customer_number
ORDER BY COUNT(*) DESC
LIMIT 1;