-- Create Table
CREATE TABLE If not exists user_content (
    content_id INT,
    content_text VARCHAR(255)
);

-- Insert Data
Truncate table user_content;
insert into user_content (content_id, content_text) values ('1', 'hello world of SQL');
insert into user_content (content_id, content_text) values ('2', 'the QUICK-brown fox');
insert into user_content (content_id, content_text) values ('3', 'modern-day DATA science');
insert into user_content (content_id, content_text) values ('4', 'web-based FRONT-end development');

-- Write your PostgreSQL query statement below
with cte1 as(
select  content_id, content_text, string_to_array(content_text, ' ') as word_array from user_content),
cte2 as (
select * from cte1, unnest(word_array) WITH ORDINALITY as t(word, word_pos)),
cte3 as(
select *, string_to_array(word, '-') as word_array_2 from cte2),
cte4 as(
select * from cte3, unnest(word_array_2) WITH ORDINALITY as t(hyphen_part, part_pos)),
cte5 as(
select *, upper(left(hyphen_part, 1)) || lower(substring(hyphen_part from 2)) as converted_word from cte4),
cte6 as(
select content_id, content_text, word, word_pos, string_agg(converted_word, '-' ORDER BY part_pos) as strings from cte5
group by content_id, content_text, word, word_pos)
select content_id, content_text as original_text, string_agg(strings, ' ' ORDER BY word_pos) as converted_text from cte6 group by content_id, content_text
