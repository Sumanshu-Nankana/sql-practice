-- create the scores table
create table if not exists scores(
id int primary key,
score decimal(3,2)
)

-- truncate the scores table
truncate table scores

-- insert some data
INSERT INTO SCORES(ID, SCORE) VALUES
(1, 3.5),
(2, 3.65),
(3, 4.0),
(4, 3.85),
(5, 4.0),
(6, 3.65);

-- query
SELECT score, dense_rank() over (order by score desc) as rank FROM SCORES order by score desc;