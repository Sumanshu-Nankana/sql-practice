-- Create Type
CREATE TYPE trip_status AS ENUM ('completed', 'cancelled_by_driver', 'cancelled_by_client');
CREATE TYPE user_role AS ENUM ('client', 'driver', 'partner');

-- Create Table
Create table If Not Exists Trips (id int, client_id int, driver_id int, city_id int, status trip_status, request_at varchar(50));
Create table If Not Exists Users (users_id int, banned varchar(50), role user_role);

-- Insert Data
Truncate table Trips
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('1', '1', '10', '1', 'completed', '2013-10-01')
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('2', '2', '11', '1', 'cancelled_by_driver', '2013-10-01')
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('3', '3', '12', '6', 'completed', '2013-10-01')
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('4', '4', '13', '6', 'cancelled_by_client', '2013-10-01')
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('5', '1', '10', '1', 'completed', '2013-10-02')
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('6', '2', '11', '6', 'completed', '2013-10-02')
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('7', '3', '12', '6', 'completed', '2013-10-02')
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('8', '2', '12', '12', 'completed', '2013-10-03')
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('9', '3', '10', '12', 'completed', '2013-10-03')
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('10', '4', '13', '12', 'cancelled_by_driver', '2013-10-03')
Truncate table Users
insert into Users (users_id, banned, role) values ('1', 'No', 'client')
insert into Users (users_id, banned, role) values ('2', 'Yes', 'client')
insert into Users (users_id, banned, role) values ('3', 'No', 'client')
insert into Users (users_id, banned, role) values ('4', 'No', 'client')
insert into Users (users_id, banned, role) values ('10', 'No', 'driver')
insert into Users (users_id, banned, role) values ('11', 'No', 'driver')
insert into Users (users_id, banned, role) values ('12', 'No', 'driver')
insert into Users (users_id, banned, role) values ('13', 'No', 'driver')

-- Write your PostgreSQL query statement below
--SELECT * FROM USERS;
--SELECT * FROM TRIPS;

-- Write your PostgreSQL query statement below
with client_information as(
SELECT t.*, u.users_id, u.banned as client_status FROM TRIPS t
LEFT JOIN
USERS u
ON t.client_id = u.users_id),
client_driver_information as(
SELECT cte1.*, u.banned as driver_status FROM client_information cte1
LEFT JOIN USERS u ON
cte1.driver_id = u.users_id),
filtered_table as(
select * from client_driver_information where client_status = 'No' and driver_status = 'No' and
request_at >= '2013-10-01' and request_at <= '2013-10-03'),
almost_final_table as(
select  request_at, count(*) as total_rides, count(CASE WHEN status in ('cancelled_by_client', 'cancelled_by_driver') THEN 1 END) as cancelled_rides
 from filtered_table group by request_at)
 select request_at as Day, ROUND(CAST(cancelled_rides AS DECIMAL) / CAST(total_rides AS DECIMAL),2) as "Cancellation Rate" from almost_final_table;