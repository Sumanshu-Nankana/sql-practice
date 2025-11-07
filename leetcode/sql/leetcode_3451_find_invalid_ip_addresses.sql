-- Create Table
CREATE TABLE logs (
    log_id INT,
    ip VARCHAR(255),
    status_code INT
);

-- Insert Data
Truncate table logs;
insert into logs (log_id, ip, status_code) values ('1', '192.168.1.1', '200');
insert into logs (log_id, ip, status_code) values ('2', '256.1.2.3', '404');
insert into logs (log_id, ip, status_code) values ('3', '192.168.001.1', '200');
insert into logs (log_id, ip, status_code) values ('4', '192.168.1.1', '200');
insert into logs (log_id, ip, status_code) values ('5', '192.168.1', '500');
insert into logs (log_id, ip, status_code) values ('6', '256.1.2.3', '404');
insert into logs (log_id, ip, status_code) values ('7', '192.168.001.1', '200');

-- Write your PostgreSQL query statement below
with cte as(
SELECT ip, count(*) as total_ip_count from logs group by ip),
cte1 as(
select *, STRING_TO_ARRAY(ip, '.') as octet_array from cte),
cte2 as(
SELECT *, UNNEST(octet_array) as octet from cte1),
cte3 as(
select *, (CASE WHEN CAST(octet  AS INT) > 255  or octet like '0%' THEN 0 ELSE 1 END) AS is_octet_valid from cte2),
cte4 as(
select ip, total_ip_count , sum(is_octet_valid) as octet_sum from cte3 group by ip, total_ip_count)
select ip, total_ip_count as invalid_count from cte4 where octet_sum <> 4 order by invalid_count desc, ip desc
