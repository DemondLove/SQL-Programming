/*
Table: Teams

+---------------+----------+
| Column Name   | Type     |
+---------------+----------+
| team_id       | int      |
| team_name     | varchar  |
+---------------+----------+
team_id is the primary key of this table.
Each row of this table represents a single football team.
Table: Matches

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| match_id      | int     |
| host_team     | int     |
| guest_team    | int     | 
| host_goals    | int     |
| guest_goals   | int     |
+---------------+---------+
match_id is the primary key of this table.
Each row is a record of a finished match between two different teams. 
Teams host_team and guest_team are represented by their IDs in the teams table (team_id) and they scored host_goals and guest_goals goals respectively.
 

You would like to compute the scores of all teams after all matches. Points are awarded as follows:
A team receives three points if they win a match (Score strictly more goals than the opponent team).
A team receives one point if they draw a match (Same number of goals as the opponent team).
A team receives no points if they lose a match (Score less goals than the opponent team).
Write an SQL query that selects the team_id, team_name and num_points of each team in the tournament after all described matches. Result table should be ordered by num_points (decreasing order). In case of a tie, order the records by team_id (increasing order).

The query result format is in the following example:

Teams table:
+-----------+--------------+
| team_id   | team_name    |
+-----------+--------------+
| 10        | Leetcode FC  |
| 20        | NewYork FC   |
| 30        | Atlanta FC   |
| 40        | Chicago FC   |
| 50        | Toronto FC   |
+-----------+--------------+

Matches table:
+------------+--------------+---------------+-------------+--------------+
| match_id   | host_team    | guest_team    | host_goals  | guest_goals  |
+------------+--------------+---------------+-------------+--------------+
| 1          | 10           | 20            | 3           | 0            |
| 2          | 30           | 10            | 2           | 2            |
| 3          | 10           | 50            | 5           | 1            |
| 4          | 20           | 30            | 1           | 0            |
| 5          | 50           | 30            | 1           | 0            |
+------------+--------------+---------------+-------------+--------------+

Result table:
+------------+--------------+---------------+
| team_id    | team_name    | num_points    |
+------------+--------------+---------------+
| 10         | Leetcode FC  | 7             |
| 20         | NewYork FC   | 3             |
| 50         | Toronto FC   | 3             |
| 30         | Atlanta FC   | 1             |
| 40         | Chicago FC   | 0             |
+------------+--------------+---------------+
*/

with cte as
(
select match_id, host_team, guest_team,
sum (case when host_goals > guest_goals then 3
when host_goals = guest_goals then 1
else 0 end) as host,
sum (case when guest_goals > host_goals then 3
when guest_goals = host_goals then 1
else 0 end)
as guest
FROM Matches
group by match_id, host_team, guest_team
)
select t.team_id, t.team_name, coalesce(sum(goals), 0) as num_points
FROM Teams t LEFT JOIN
(select host_team as team_name, sum(host) as goals
FROM cte
group by host_team
UNION ALL
select guest_team as team_name, sum(guest) as goals
FROM cte
group by guest_team) a
on t.team_id = a.team_name
group by t.team_id, t.team_name
order by num_points desc, t.team_id

# SELECT DISTINCT
#     T.team_id
#     , T.team_name
#     , ISNULL(tbl.num_points, 0) AS num_points
# FROM Teams T
#     LEFT JOIN (
#                 SELECT 
#                     H.host_team AS team_id
#                     , H.host_points+G.guest_points AS num_points
#                 FROM (
#                         SELECT
#                             host_team
#                             , SUM(host_points) AS host_points
#                         FROM (
#                                 SELECT 
#                                     M.match_id
#                                     , M.host_team
#                                     , M.guest_team
#                                     , M.host_goals
#                                     , M.guest_goals
#                                     , CASE 
#                                         WHEN M.host_goals > M.guest_goals THEN 3
#                                         WHEN M.host_goals = M.guest_goals THEN 1
#                                         ELSE 0
#                                       END AS host_points
#                                     , CASE
#                                         WHEN M.guest_goals > M.host_goals THEN 3
#                                         WHEN M.guest_goals = M.host_goals THEN 1
#                                         ELSE 0
#                                       END AS guest_points
#                                 FROM Matches M
#                               ) host_team_totals
#                         GROUP BY host_team
#                      ) H
#                     JOIN (
#                             SELECT
#                                 guest_team
#                                 , SUM(guest_points) AS guest_points
#                             FROM (
#                                     SELECT 
#                                         M.match_id
#                                         , M.host_team
#                                         , M.guest_team
#                                         , M.host_goals
#                                         , M.guest_goals
#                                         , CASE 
#                                             WHEN M.host_goals > M.guest_goals THEN 3
#                                             WHEN M.host_goals = M.guest_goals THEN 1
#                                             ELSE 0
#                                           END AS host_points
#                                         , CASE
#                                             WHEN M.guest_goals > M.host_goals THEN 3
#                                             WHEN M.guest_goals = M.host_goals THEN 1
#                                             ELSE 0
#                                           END AS guest_points
#                                     FROM Matches M
#                                   ) guest_team_totals
#                             GROUP BY guest_team
#                         ) G ON G.guest_team = H.host_team
#                ) tbl ON T.team_id = tbl.team_id
# ORDER BY num_points DESC, team_id
