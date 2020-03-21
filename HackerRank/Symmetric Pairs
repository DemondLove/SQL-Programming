/*
You are given a table, Functions, containing two columns: X and Y.

Two pairs (X1, Y1) and (X2, Y2) are said to be symmetric pairs if X1 = Y2 and X2 = Y1.
Write a query to output all such symmetric pairs in ascending order by the value of X.
Sample Input

Sample Output
20 20
20 21
22 23
*/

SELECT
    F1.X
    , F1.Y
FROM
Functions F1
    JOIN Functions F2 ON F1.X=F2.Y AND F2.X=F1.Y
WHERE F1.X<=F1.Y
GROUP BY F1.X, F1.Y
HAVING COUNT(*) > 1 OR (F1.X != F1.Y) 
ORDER BY F1.X
