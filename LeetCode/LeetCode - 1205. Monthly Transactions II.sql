/*
Table: Transactions

+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| id             | int     |
| country        | varchar |
| state          | enum    |
| amount         | int     |
| trans_date     | date    |
+----------------+---------+
id is the primary key of this table.
The table has information about incoming transactions.
The state column is an enum of type ["approved", "declined"].
Table: Chargebacks

+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| trans_id       | int     |
| charge_date    | date    |
+----------------+---------+
Chargebacks contains basic information regarding incoming chargebacks from some transactions placed in Transactions table.
trans_id is a foreign key to the id column of Transactions table.
Each chargeback corresponds to a transaction made previously even if they were not approved.
 

Write an SQL query to find for each month and country, the number of approved transactions and their total amount, the number of chargebacks and their total amount.

Note: In your query, given the month and country, ignore rows with all zeros.

The query result format is in the following example:

Transactions table:
+------+---------+----------+--------+------------+
| id   | country | state    | amount | trans_date |
+------+---------+----------+--------+------------+
| 101  | US      | approved | 1000   | 2019-05-18 |
| 102  | US      | declined | 2000   | 2019-05-19 |
| 103  | US      | approved | 3000   | 2019-06-10 |
| 104  | US      | approved | 4000   | 2019-06-13 |
| 105  | US      | approved | 5000   | 2019-06-15 |
+------+---------+----------+--------+------------+

Chargebacks table:
+------------+------------+
| trans_id   | trans_date |
+------------+------------+
| 102        | 2019-05-29 |
| 101        | 2019-06-30 |
| 105        | 2019-09-18 |
+------------+------------+

Result table:
+----------+---------+----------------+-----------------+-------------------+--------------------+
| month    | country | approved_count | approved_amount | chargeback_count  | chargeback_amount  |
+----------+---------+----------------+-----------------+-------------------+--------------------+
| 2019-05  | US      | 1              | 1000            | 1                 | 2000               |
| 2019-06  | US      | 3              | 12000           | 1                 | 1000               |
| 2019-09  | US      | 0              | 0               | 1                 | 5000               |
+----------+---------+----------------+-----------------+-------------------+--------------------+
*/

SELECT * FROM (
SELECT DISTINCT
    ISNULL(approved_tbl.month, CB.month) AS month
    , ISNULL(approved_tbl.country, CB.country) AS country
    , ISNULL(COUNT(approved_tbl.state) OVER(PARTITION BY approved_tbl.month, approved_tbl.country), 0) AS approved_count
    , ISNULL(SUM(approved_tbl.amount) OVER(PARTITION BY approved_tbl.month, approved_tbl.country), 0) AS approved_amount
    , ISNULL(CB.chargeback_count, 0) AS chargeback_count
    , ISNULL(CB.chargeback_amount, 0) AS chargeback_amount
FROM (
SELECT
    FORMAT(T.trans_date, 'yyyy-MM') AS month
    , T.id
    , T.country
    , T.state
    , T.amount
FROM Transactions T
WHERE state = 'approved') approved_tbl
FULL OUTER JOIN (
SELECT DISTINCT
    month
    , country
    , COUNT(trans_id) OVER(PARTITION BY month, country) AS chargeback_count
     , SUM(amount) OVER(PARTITION BY month, country) AS chargeback_amount
FROM (
SELECT 
    FORMAT(C.trans_date, 'yyyy-MM') AS month
    , T.country
    , C.trans_id
    , T.amount
FROM Chargebacks C
    JOIN Transactions T ON T.id = C.trans_id) chargeback_tbl
) CB ON CB.month = approved_tbl.month AND CB.country = approved_tbl.country
) result_tbl
WHERE approved_count > 0
OR approved_amount > 0
OR chargeback_count > 0
OR chargeback_amount > 0
ORDER BY month, country
