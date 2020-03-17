/*
Julia asked her students to create some coding challenges. Write a query to print the hacker_id, name, and the total number of challenges created by each student. Sort your results by the total number of challenges in descending order. If more than one student created the same number of challenges, then sort the result by hacker_id. If more than one student created the same number of challenges and the count is less than the maximum number of challenges created, then exclude those students from the result.
Input Format
The following tables contain challenge data:
Hackers: The hacker_id is the id of the hacker, and name is the name of the hacker. 
Challenges: The challenge_id is the id of the challenge, and hacker_id is the id of the student who created the challenge. 
Sample Input 0
Hackers Table: Challenges Table: 
Sample Output 0
21283 Angela 6
88255 Patrick 5
96196 Lisa 1
Sample Input 1
Hackers Table: Challenges Table: 
Sample Output 1
12299 Rose 6
34856 Angela 6
79345 Frank 4
80491 Patrick 3
81041 Lisa 1
Explanation
For Sample Case 0, we can get the following details: 

Students  and  both created  challenges, but the maximum number of challenges created is  so these students are excluded from the result.
For Sample Case 1, we can get the following details: 

Students  and  both created  challenges. Because  is the maximum number of challenges created, these students are included in the result.
*/

SELECT
    hacker_id
    , name
    , cnt
FROM (
        SELECT
            hacker_id
            , name
            , cnt
            , rnk
            , COUNT(rnk) OVER(PARTITION BY rnk) AS rnk_cnt
        FROM (
                SELECT
                    hacker_id
                    , name
                    , cnt
                    , RANK() OVER(ORDER BY cnt DESC) AS rnk
                FROM (
                        SELECT
                            H.hacker_id
                            , H.name
                            , COUNT(C.challenge_id) AS cnt
                        FROM Hackers H
                            JOIN Challenges C ON H.hacker_id=C.hacker_id
                        GROUP BY H.hacker_id, H.name
                     ) tbl
              ) tbl2
    ) tbl3
WHERE rnk_cnt = 1 OR rnk = 1
ORDER BY cnt DESC, hacker_id