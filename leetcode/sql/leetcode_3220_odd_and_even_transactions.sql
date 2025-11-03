-- Create Table
Create table if not exists transactions ( transaction_id int, amount int, transaction_date date);

-- Insert Data
Truncate table transactions;
insert into transactions (transaction_id, amount, transaction_date) values ('1', '150', '2024-07-01');
insert into transactions (transaction_id, amount, transaction_date) values ('2', '200', '2024-07-01');
insert into transactions (transaction_id, amount, transaction_date) values ('3', '75', '2024-07-01');
insert into transactions (transaction_id, amount, transaction_date) values ('4', '300', '2024-07-02');
insert into transactions (transaction_id, amount, transaction_date) values ('5', '50', '2024-07-02');
insert into transactions (transaction_id, amount, transaction_date) values ('6', '120', '2024-07-03');

-- Write your PostgreSQL query statement below
SELECT transaction_date,
SUM(CASE WHEN amount%2=1 THEN amount ELSE 0 END) as odd_sum,
SUM(CASE WHEN amount%2=0 THEN amount ELSE 0 END) as even_sum
FROM transactions
group by transaction_date
ORDER BY transaction_date