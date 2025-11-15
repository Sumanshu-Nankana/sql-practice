-- create table
CREATE TABLE restaurant_orders (
    order_id INT,
    customer_id INT,
    order_timestamp TIMESTAMP,
    order_amount DECIMAL(10,2),
    payment_method VARCHAR(10),
    order_rating INT
);

-- Insert Data
Truncate table restaurant_orders;
insert into restaurant_orders (order_id, customer_id, order_timestamp, order_amount, payment_method, order_rating) values ('1', '101', '2024-03-01 12:30:00', '25.5', 'card', '5');
insert into restaurant_orders (order_id, customer_id, order_timestamp, order_amount, payment_method, order_rating) values ('2', '101', '2024-03-02 19:15:00', '32.0', 'app', '4');
insert into restaurant_orders (order_id, customer_id, order_timestamp, order_amount, payment_method, order_rating) values ('3', '101', '2024-03-03 13:45:00', '28.75', 'card', '5');
insert into restaurant_orders (order_id, customer_id, order_timestamp, order_amount, payment_method, order_rating) values ('4', '101', '2024-03-04 20:30:00', '41.0', 'app', NULL);
insert into restaurant_orders (order_id, customer_id, order_timestamp, order_amount, payment_method, order_rating) values ('5', '102', '2024-03-01 11:30:00', '18.5', 'cash', '4');
insert into restaurant_orders (order_id, customer_id, order_timestamp, order_amount, payment_method, order_rating) values ('6', '102', '2024-03-02 12:00:00', '22.0', 'card', '3');
insert into restaurant_orders (order_id, customer_id, order_timestamp, order_amount, payment_method, order_rating) values ('7', '102', '2024-03-03 15:30:00', '19.75', 'cash', NULL);
insert into restaurant_orders (order_id, customer_id, order_timestamp, order_amount, payment_method, order_rating) values ('8', '103', '2024-03-01 19:00:00', '55.0', 'app', '5');
insert into restaurant_orders (order_id, customer_id, order_timestamp, order_amount, payment_method, order_rating) values ('9', '103', '2024-03-02 20:45:00', '48.5', 'app', '4');
insert into restaurant_orders (order_id, customer_id, order_timestamp, order_amount, payment_method, order_rating) values ('10', '103', '2024-03-03 18:30:00', '62.0', 'card', '5');
insert into restaurant_orders (order_id, customer_id, order_timestamp, order_amount, payment_method, order_rating) values ('11', '104', '2024-03-01 10:00:00', '15.0', 'cash', '3');
insert into restaurant_orders (order_id, customer_id, order_timestamp, order_amount, payment_method, order_rating) values ('12', '104', '2024-03-02 09:30:00', '18.0', 'cash', '2');
insert into restaurant_orders (order_id, customer_id, order_timestamp, order_amount, payment_method, order_rating) values ('13', '104', '2024-03-03 16:00:00', '20.0', 'card', '3');
insert into restaurant_orders (order_id, customer_id, order_timestamp, order_amount, payment_method, order_rating) values ('14', '105', '2024-03-01 12:15:00', '30.0', 'app', '4');
insert into restaurant_orders (order_id, customer_id, order_timestamp, order_amount, payment_method, order_rating) values ('15', '105', '2024-03-02 13:00:00', '35.5', 'app', '5');
insert into restaurant_orders (order_id, customer_id, order_timestamp, order_amount, payment_method, order_rating) values ('16', '105', '2024-03-03 11:45:00', '28.0', 'card', '4');

-- Write your PostgreSQL query statement below

with cte as(
SELECT *,
(CASE WHEN (CAST(order_timestamp as TIME) BETWEEN '11:00:00' and '14:00:00') or
(CAST(order_timestamp as TIME) BETWEEN '18:00:00' AND '21:00:00') THEN 1 ELSE 0 end)
as is_peak_order,
(CASE WHEN order_rating is null THEN 0 ELSE 1 end) as is_rated
from restaurant_orders),

cte1 as(
select customer_id, ROUND((sum(is_peak_order)*100.0/count(*)), 0) as peak_hour_percentage,
ROUND(sum(is_rated)*100.0/count(*), 0) as rating_percentage, ROUND(avg(order_rating ),2) as average_rating,
count(*) as total_orders
from cte group by customer_id)

select cte.customer_id, cte1.total_orders, cte1.peak_hour_percentage, cte1.average_rating
from cte left join cte1 on cte.customer_id = cte1.customer_id
group by cte.customer_id,cte1.peak_hour_percentage, cte1.rating_percentage, cte1.average_rating, cte1.total_orders
having cte1.peak_hour_percentage >= 60 and cte1.rating_percentage >= 50
and count(*) >= 3 and cte1.average_rating >= 4
ORDER BY cte1.average_rating desc, cte.customer_id desc