#1.what is total amount each customer spent on zomato ?

select s.userid, sum(p.price) as total_amount
from sys.sales s inner join sys.product p 
on s.product_id=p.product_id
group by s.userid;

##########################################################################################################################################

#2.How many days has each customer visited zomato?

select s.userid, count(distinct s.created_date) as total_days 
from sys.sales s group by s.userid;

############################################################################################################################################

#3.what was the first product purchased by each customer?

select userid, created_date, product_id from 
(select *, dense_rank() over 
(partition by userid order by created_date) rn
from sys.sales) T
where rn=1;

#############################################################################################################################################

#4.what is most purchased item on menu & how many times was it purchased by all customers ?

SELECT userid, product_id, COUNT(product_id) AS cnt_product
FROM sys.sales
WHERE product_id = (
    SELECT product_id
    FROM sys.sales
    GROUP BY product_id
    ORDER BY COUNT(*) DESC
    LIMIT 1
)
GROUP BY userid, product_id;

############################################################################################################################################

#5.which item was most popular for each customer?

SELECT userid, product_id
FROM sys.sales
WHERE product_id = (
    SELECT product_id
    FROM sys.sales
    GROUP BY product_id
    ORDER BY COUNT(*) DESC
    LIMIT 1
)
GROUP BY userid, product_id;

############################################################################################################################################

#6.which item was purchased first by customer after they become a member ?

SELECT s.userid, s.product_id, s.created_date
FROM sys.sales s
JOIN sys.goldusers_signup u ON s.userid = u.userid
WHERE s.created_date = (
    SELECT MIN(s1.created_date)
    FROM sys.sales s1
    WHERE s1.userid = s.userid
      AND s1.created_date >= u.gold_signup_date
)
ORDER BY s.userid;

#############################################################################################################################################