#10.In the first year after joining the gold program (including the join date),
#where customers earn 5 Zomato points for every 10 INR spent, determine which customer (1 or 3) earned more Zomato points 
#and calculate their total earnings in INR, considering that 1 Zomato point equals 2 INR.

SELECT 
    s.userid,
    SUM(p.price) AS total_spent,
    SUM(p.price) / 10 * 5 AS total_zomato_points,
    (SUM(p.price) / 10 * 5) * 2 AS earnings_in_inr
FROM sys.sales s
JOIN sys.product p ON s.product_id = p.product_id
JOIN sys.goldusers_signup g ON s.userid = g.userid
WHERE 
    (s.userid = 1 AND s.created_date BETWEEN '2017-09-22' AND '2018-09-21')
    OR
    (s.userid = 3 AND s.created_date BETWEEN '2017-04-21' AND '2018-04-20')
GROUP BY s.userid;

################################################################################################################################################

#11. Rank all transactions for each customer based on the order in which they were made, with the earliest transaction ranked as 1.

SELECT 
    s.userid,
    s.created_date,
    s.product_id,
    RANK() OVER (PARTITION BY s.userid ORDER BY s.created_date) AS transaction_rank
FROM sys.sales s
ORDER BY s.userid, s.created_date;

#############################################################################################################################################

#12. Rank all transactions for each customer while they are a Zomato Gold member. 
#For transactions made when the customer was not a Gold member, mark the rank as 'NA'.

SELECT 
    s.userid,
    s.created_date,
    s.product_id,
    CASE
        WHEN g.userid IS NOT NULL AND s.created_date BETWEEN g.gold_signup_date AND DATE_ADD(g.gold_signup_date, INTERVAL 1 YEAR) 
        THEN RANK() OVER (PARTITION BY s.userid ORDER BY s.created_date)
        ELSE 'NA'
    END AS transaction_rank
FROM sys.sales s
LEFT JOIN sys.goldusers_signup g ON s.userid = g.userid
ORDER BY s.userid, s.created_date;

#############################################################################################################################################
