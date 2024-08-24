#7. which item was purchased just before the customer became a member?

SELECT s.userid, s.product_id, s.created_date
FROM sys.sales s
JOIN sys.goldusers_signup u ON s.userid = u.userid
WHERE s.created_date = (
    SELECT MIN(s1.created_date)
    FROM sys.sales s1
    WHERE s1.userid = s.userid
      AND s1.created_date <= u.gold_signup_date
)
ORDER BY s.userid;

###############################################################################################################################################

#8. what is total orders and amount spent for each member before they become a member?

select s.userid, count(s.product_id) as total_orders, 
sum(p.price) as amount_spent
from sys.sales s left join sys.goldusers_signup g
on s.userid = g.userid and s.created_date <= g.gold_signup_date
join sys.product p 
on s.product_id = p.product_id
group by s.userid
order by s.userid;

##############################################################################################################################################

#9.Given a pricing model where Product p3 generates 1 Zomato point for every 5 INR spent on the first 330 INR and 
#1 Zomato point for every 2 INR spent on any remaining amount beyond 330 INR, 
#calculate the total points collected by each customer for each product, 
#and determine which product has generated the most points overall.

SELECT 
    s.userid,
    s.product_id,
    SUM(
        CASE 
            WHEN s.product_id = 1 THEN p.price / 5
            WHEN s.product_id = 2 THEN p.price / 10
            WHEN s.product_id = 3 THEN 
                CASE 
                    WHEN p.price <= 330 THEN p.price / 5
                    ELSE 330 / 5 + (p.price - 330) / 2
                END
        END
    ) AS total_points
FROM sys.sales s
JOIN sys.product p ON s.product_id = p.product_id
GROUP BY s.userid, s.product_id
order by s.userid, s.product_id;

#############################################################################################################################################
