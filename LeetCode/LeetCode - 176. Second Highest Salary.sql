/*
Write a SQL query to get the second highest salary from the Employee table.

+----+--------+
| Id | Salary |
+----+--------+
| 1  | 100    |
| 2  | 200    |
| 3  | 300    |
+----+--------+
For example, given the above Employee table, the query should return 200 as the second highest salary. If there is no second highest salary, then the query should return null.

+---------------------+
| SecondHighestSalary |
+---------------------+
| 200                 |
+---------------------+
*/

IF (SELECT COUNT(DISTINCT Salary) FROM Employee) = 1

BEGIN

SELECT TOP 1 NULL AS SecondHighestSalary FROM Employee

END

ELSE

WITH CTE AS (
    SELECT TOP 2 Salary FROM Employee
    WHERE Salary IN (SELECT DISTINCT SALARY FROM Employee)
    ORDER BY Salary DESC)

SELECT TOP 1 Salary AS SecondHighestSalary
FROM CTE
ORDER BY Salary
