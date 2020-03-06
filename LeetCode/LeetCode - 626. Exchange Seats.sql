/*
Mary is a teacher in a middle school and she has a table seat storing students' names and their corresponding seat ids.

The column id is continuous increment.
 

Mary wants to change seats for the adjacent students.
 

Can you write a SQL query to output the result for Mary?
 

+---------+---------+
|    id   | student |
+---------+---------+
|    1    | Abbot   |
|    2    | Doris   |
|    3    | Emerson |
|    4    | Green   |
|    5    | Jeames  |
+---------+---------+
For the sample input, the output is:
 

+---------+---------+
|    id   | student |
+---------+---------+
|    1    | Doris   |
|    2    | Abbot   |
|    3    | Green   |
|    4    | Emerson |
|    5    | Jeames  |
+---------+---------+
*/

SELECT
    id
    , CASE
        WHEN id%2 = 0 THEN lag_value
        WHEN id%2 != 0 AND lead_value IS NULL THEN student
        ELSE lead_value
    END AS student
FROM (
SELECT
    id
    , student
    , LAG(student) OVER(ORDER BY id) AS lag_value
    , LEAD(student) OVER(ORDER BY id) AS lead_value
FROM seat) tbl
ORDER BY id
