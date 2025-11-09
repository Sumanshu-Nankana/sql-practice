-- Create Table
CREATE TABLE if not exists students (
    student_id INT,
    student_name VARCHAR(255),
    major VARCHAR(100)
);
CREATE TABLE study_sessions (
    session_id INT,
    student_id INT,
    subject VARCHAR(100),
    session_date DATE,
    hours_studied DECIMAL(4, 2)
);

-- Insert Data
Truncate table students;
insert into students (student_id, student_name, major) values ('1', 'Alice Chen', 'Computer Science');
insert into students (student_id, student_name, major) values ('2', 'Bob Johnson', 'Mathematics');
insert into students (student_id, student_name, major) values ('3', 'Carol Davis', 'Physics');
insert into students (student_id, student_name, major) values ('4', 'David Wilson', 'Chemistry');
insert into students (student_id, student_name, major) values ('5', 'Emma Brown', 'Biology');
Truncate table study_sessions;
insert into study_sessions (session_id, student_id, subject, session_date, hours_studied) values ('1', '1', 'Math', '2023-10-01', '2.5');
insert into study_sessions (session_id, student_id, subject, session_date, hours_studied) values ('2', '1', 'Physics', '2023-10-02', '3.0');
insert into study_sessions (session_id, student_id, subject, session_date, hours_studied) values ('3', '1', 'Chemistry', '2023-10-03', '2.0');
insert into study_sessions (session_id, student_id, subject, session_date, hours_studied) values ('4', '1', 'Math', '2023-10-04', '2.5');
insert into study_sessions (session_id, student_id, subject, session_date, hours_studied) values ('5', '1', 'Physics', '2023-10-05', '3.0');
insert into study_sessions (session_id, student_id, subject, session_date, hours_studied) values ('6', '1', 'Chemistry', '2023-10-06', '2.0');
insert into study_sessions (session_id, student_id, subject, session_date, hours_studied) values ('7', '2', 'Algebra', '2023-10-01', '4.0');
insert into study_sessions (session_id, student_id, subject, session_date, hours_studied) values ('8', '2', 'Calculus', '2023-10-02', '3.5');
insert into study_sessions (session_id, student_id, subject, session_date, hours_studied) values ('9', '2', 'Statistics', '2023-10-03', '2.5');
insert into study_sessions (session_id, student_id, subject, session_date, hours_studied) values ('10', '2', 'Geometry', '2023-10-04', '3.0');
insert into study_sessions (session_id, student_id, subject, session_date, hours_studied) values ('11', '2', 'Algebra', '2023-10-05', '4.0');
insert into study_sessions (session_id, student_id, subject, session_date, hours_studied) values ('12', '2', 'Calculus', '2023-10-06', '3.5');
insert into study_sessions (session_id, student_id, subject, session_date, hours_studied) values ('13', '2', 'Statistics', '2023-10-07', '2.5');
insert into study_sessions (session_id, student_id, subject, session_date, hours_studied) values ('14', '2', 'Geometry', '2023-10-08', '3.0');
insert into study_sessions (session_id, student_id, subject, session_date, hours_studied) values ('15', '3', 'Biology', '2023-10-01', '2.0');
insert into study_sessions (session_id, student_id, subject, session_date, hours_studied) values ('16', '3', 'Chemistry', '2023-10-02', '2.5');
insert into study_sessions (session_id, student_id, subject, session_date, hours_studied) values ('17', '3', 'Biology', '2023-10-03', '2.0');
insert into study_sessions (session_id, student_id, subject, session_date, hours_studied) values ('18', '3', 'Chemistry', '2023-10-04', '2.5');
insert into study_sessions (session_id, student_id, subject, session_date, hours_studied) values ('19', '4', 'Organic', '2023-10-01', '3.0');
insert into study_sessions (session_id, student_id, subject, session_date, hours_studied) values ('20', '4', 'Physical', '2023-10-05', '2.5');


-- Write your PostgreSQL query statement below
with combined as(
SELECT ss.*, s.student_name, s.major
FROM study_sessions ss
JOIN students s ON ss.student_id = s.student_id),
cte AS (
    -- Only students with at least 6 sessions, and bring student_name & major
    SELECT * from combined where student_id NOT IN (
        SELECT student_id
        FROM study_sessions
        GROUP BY student_id
        HAVING COUNT(session_id) < 6
    )
),
cte1 AS (
    -- Compute previous session date
    SELECT *,
           LAG(session_date) OVER (PARTITION BY student_id ORDER BY session_date) AS prev_session_date
    FROM cte
),
cte2 AS (
    -- Mark gaps > 2 days
    SELECT *,
           CASE WHEN prev_session_date IS NOT NULL AND session_date - prev_session_date > 2 THEN 1 ELSE 0 END AS validate_dates
    FROM cte1
),
cte3 AS (
    -- Keep only students without any >2 day gaps
    SELECT session_id, student_id, student_name, major, subject, session_date, hours_studied
    FROM cte2
    WHERE student_id NOT IN (
        SELECT student_id
        FROM cte2
        GROUP BY student_id
        HAVING SUM(validate_dates) >= 1
    )
),
cte4 AS (
    -- Assign sequential row numbers
    SELECT *, ROW_NUMBER() OVER (PARTITION BY student_id ORDER BY session_date) AS rn
    FROM cte3
),
cte5 AS (
    -- Determine cycle length (distinct subjects)
    SELECT student_id, COUNT(DISTINCT subject) AS cycle_length
    FROM cte4
    GROUP BY student_id
),
cte6 AS (
    -- Combine row info with cycle length
    SELECT cte4.*, cte5.cycle_length
    FROM cte4
    JOIN cte5 ON cte4.student_id = cte5.student_id
),
cte7 AS (
    -- Compare subject with next cycle subject
    SELECT s1.student_id,
           s1.student_name,
           s1.major,
           s1.cycle_length,
           s1.subject,
           s1.hours_studied,
           s1.rn,
           s2.subject AS subject_next_cycle
    FROM cte6 s1
    JOIN cte6 s2
      ON s1.student_id = s2.student_id
     AND s1.rn + s1.cycle_length = s2.rn
),
cte8 AS (
    -- Mark mismatches
    SELECT student_id,
           student_name,
           major,
           cycle_length,
           hours_studied,
           rn,
           CASE WHEN subject = subject_next_cycle THEN 0 ELSE 1 END AS vaid_or_not
    FROM cte7
),
cte9 AS (
    -- Keep only students whose entire cycle repeats correctly
    SELECT student_id, student_name, major, cycle_length
    FROM cte8
    GROUP BY student_id, student_name, major, cycle_length
    HAVING SUM(vaid_or_not) = 0
       AND cycle_length >= 3
)
-- Final aggregation
SELECT cte9.student_id,
       cte9.student_name,
       cte9.major,
       cte9.cycle_length,
       SUM(cte3.hours_studied) AS total_study_hours
FROM cte9
JOIN cte3 ON cte9.student_id = cte3.student_id
GROUP BY cte9.student_id, cte9.student_name, cte9.major, cte9.cycle_length
ORDER BY cte9.cycle_length DESC, total_study_hours DESC;
