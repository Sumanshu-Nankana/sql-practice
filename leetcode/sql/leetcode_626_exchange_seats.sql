-- Create Table
Create table If Not Exists Seat (id int, student varchar(255));

-- Insert Data
Truncate table Seat;
insert into Seat (id, student) values ('1', 'Abbot');
insert into Seat (id, student) values ('2', 'Doris');
insert into Seat (id, student) values ('3', 'Emerson');
insert into Seat (id, student) values ('4', 'Green');
insert into Seat (id, student) values ('5', 'Jeames');

-- Write your PostgreSQL query statement below
SELECT id, (CASE
        WHEN id%2 = 0 THEN LAG(student, 1, student) OVER(ORDER BY id)
            ELSE LEAD(student, 1, student) OVER (ORDER BY id) end) as student
from seat;

