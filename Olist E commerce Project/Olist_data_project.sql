CREATE DATABASE PORTFOLIO_PROJECT;
USE PORTFOLIO_PROJECT;

select * from `olist_orders_dataset`;

set sql_safe_updates = 0;

#ADD NEW COLUMN FOR REAL DATES
alter table olist_orders_dataset
add column PURCHASE_DATE datetime;

UPDATE olist_orders_dataset
SET PURCHASE_DATE = STR_TO_DATE(order_purchase_timestamp, '%c/%e/%Y %H:%i');

SELECT order_purchase_timestamp, purchase_date
from olist_orders_dataset
limit 20;
#------------------------------------------------------------------------------------------------------------
#Operations Performed below
#Q1: 
#-----------------------------------------------------------------------------------------------------------
#Write a SQL query that shows:
#The Year (extract it from your new column).
#The Total Number of Orders for that year

SELECT 
    YEAR(purchase_date) AS Order_Year, 
    COUNT(order_id) AS Total_Orders
FROM olist_orders_dataset
GROUP BY YEAR(purchase_date)
ORDER BY Order_Year;
#-------------------------------------------------------------
#Q2: how many orders are late ?
#-------------------------------------------------------------
alter table `olist_orders_dataset`
add column Estimated_date datetime,
add column Delivered_date datetime;

select * from `olist_orders_dataset`;

update olist_orders_dataset
set Estimated_date = str_to_date(order_estimated_delivery_date, '%c/%e/%Y %H:%i'),
Delivered_date = str_to_date(order_delivered_customer_date, '%c/%e/%Y %H:%i');
#-----------------------Problem encountered of Missing Values --------------------------------
#------We Now use "NULLIF" to handle the missing vakues-----------
#again write the query down,

update olist_orders_dataset
set Estimated_date = str_to_date(nullif(order_estimated_delivery_date, ''), '%c/%e/%Y %H:%i');

update olist_orders_dataset
set Delivered_date = str_to_date(nullif(order_delivered_customer_date, ''), '%c/%e/%Y %H:%i');

#NOW, Go for late Orders query again

select count(*)
from olist_orders_dataset
where Delivered_date > Estimated_date;
#-----------------------------------------------------------------------------------------------------------------------
#Q3: JOINS
#-----------------------------------------------------------------------------------------------------------------------
SELECT 
    c.customer_state, 
    COUNT(*) as Late_Count
FROM olist_orders_dataset o
JOIN olist_customers_dataset c 
    ON o.customer_id = c.customer_id  -- The Zipper
WHERE 
    o.delivered_date > o.estimated_date  -- Only count the late ones
GROUP BY 
    c.customer_state
ORDER BY 
    Late_Count DESC
    limit 20;
#-----------------------------------------
#Adv level Query, Senior analyst query,
#Q: customer_state,total_orders,Late_orders and late percentage
#---------------------
SELECT 
    c.customer_state,
    COUNT(*) AS Total_Orders,
    -- Count only the late ones
    SUM(CASE WHEN o.delivered_date > o.estimated_date THEN 1 ELSE 0 END) AS Late_Orders,
    -- Calculate the Percentage (Late / Total * 100)
    ROUND((SUM(CASE WHEN o.delivered_date > o.estimated_date THEN 1 ELSE 0 END) / COUNT(*)) * 100, 2) AS Late_Percentage
FROM olist_orders_dataset o
JOIN olist_customers_dataset c 
    ON o.customer_id = c.customer_id
GROUP BY c.customer_state
HAVING Total_Orders > 1000  -- Only look at major states (ignore tiny ones)
ORDER BY Late_Percentage DESC;
#-------------------------------------------------------------------------------------------------------------------


#BASIC SQL OPERATIONS -------------

#Q: Find total number of orders were Cancelled !
select count(*) as Cancelled_orders
from olist_orders_dataset
where order_status = "Cancelled";

select * from `olist_orders_dataset`;
#--------------------------------------------------------------------------------------------------
#Q: What time of day do people buy the most?" The Logic: This is a Bucketing problem.
select 
hour(purchase_date) as hour_of_day,
count(*) as order_count
from olist_orders_dataset
group by hour(purchase_date)
order by Order_count desc;
#--------------------------------------------------------------------------------------------------

#Q: which cities has the most orders?

select c.customer_city, count(*) as Total_orders
from olist_orders_dataset o 
join
olist_customers_dataset c on
c.customer_id = o.customer_id
group by customer_city
order by Total_orders desc
limit 10;

#Q: Total orders of Sao paulo city only------

select count(*) as Sp_orders
from `olist_orders_dataset` o 
join 
`olist_customers_dataset` c on
c.customer_id = o.customer_id
where c.customer_city = "sao paulo";
#--------------------------------

#Q: How long does it take on average to deliver an order?
SELECT 
    AVG(DATEDIFF(delivered_date, purchase_date)) AS Avg_Delivery_Days
FROM olist_orders_dataset
WHERE delivered_date IS NOT NULL;
#----------------------------------------------------------------------------------------------
#------------------------------- END --------------------------------

select * from `olist_customers_dataset` as c
inner join `olist_orders_dataset` as o
on c.customer_id = o.customer_id
limit 10;

select * from olist_customers_dataset as c 
left join olist_orders_dataset as o
on c.customer_id = o.customer_id
limit 10;

select c.customer_id, o.order_status
from olist_customers_dataset as c
right join olist_orders_dataset as o
on c.customer_id = o.customer_id
limit 5;


select *
from olist_customers_dataset as c
full outer join olist_orders_dataset as o
on c.customer_id = o.customer_id
limit 5;