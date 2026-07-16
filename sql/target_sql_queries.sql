/*======================================================================================================
Target Brazil E-Commerce SQL Analysis
========================================================================================================*/

/*======================================================================================================
I. Exploratory Analysis
========================================================================================================*/

-- Q1. Get the time range between which the orders were placed

SELECT MIN(order_purchase_timestamp) AS first_order,
       MAX(order_purchase_timestamp) AS last_order,
       DATE_DIFF(MAX(order_purchase_timestamp)),
                 MIN(order_purchase_timestamp)), DAY) AS total_span_days
FROM `Target.orders`;

-- Insight: 
-- The dataset contains orders placed between 4th September 2016 and 17th October 2018.

--------------------------------------------------------------------------------------------------------

-- Q2. 3.	Count the Cities & States of customers who ordered during the given period

SELECT COUNT(DISTINCT customer_city) AS number_of_cities,
       COUNT(DISTINCT customer_state) AS number_of_states
FROM `Target.customers` c JOIN `Target.orders` o
     ON c.customer_id = o.customer_id;

-- Insights: 
-- Number of cities: 4119
-- Number of states: 27

/*======================================================================================================
II. In-depth Exploration
========================================================================================================*/

--Q1. Is there a growing trend in the no. of orders placed over the past years?

SELECT EXTRACT (YEAR FROM order_purchase_timestamp) AS year,
       COUNT(order_id) AS number_of_orders
FROM `Target.orders`
GROUP BY year
ORDER BY year;

-- Insights:
-- Order volume increased significantly between 2016 and 2018.
-- However, growth slowed in 2018 compared to the sharp increase observed in 2017.

---------------------------------------------------------------------------------------------------------

--Q2. Can we see some kind of monthly seasonality in terms of no. of orders being placed? 

SELECT FORMAT_DATE('%Y-%m', DATE(order_purchase_timestamp)) AS order_month,
      COUNT(order_id) AS num_orders
FROM `Target.orders`
GROUP BY order_month
ORDER BY order_month;

-- Insights:
-- The business experienced rapid growth throughout 2017, with monthly orders increasing from 800 in January 2017 to over 7,500 in November 2017. 
-- A significant spike in November 2017 suggests the presence of seasonal effects. 
-- Order volumes stabilized during 2018 at around 6,000–7,000 orders per month.  
-- By the end of 2018, order count is very low. 

----------------------------------------------------------------------------------------------------------

--Q3. During what time of the day, do the Brazilian customers mostly place their orders? (Dawn, Morning, Afternoon or Night)

SELECT
  CASE
    WHEN EXTRACT(HOUR FROM order_purchase_timestamp) BETWEEN 0  AND 6  THEN 'Dawn'
    WHEN EXTRACT(HOUR FROM order_purchase_timestamp) BETWEEN 7  AND 12 THEN 'Morning'
    WHEN EXTRACT(HOUR FROM order_purchase_timestamp) BETWEEN 13 AND 18 THEN 'Afternoon'
    ELSE 'Night'
  END AS time_of_day,
  COUNT(order_id) AS num_orders
FROM `Target.orders`
GROUP BY time_of_day
ORDER BY num_orders DESC;

-- Insight:
-- Brazilian customers place their orders mostly in the afternoon.

/*======================================================================================================
III. Evolution of E-commerce orders in the Brazil region
========================================================================================================*/

--Q1. Get the month on month no. of orders placed in each state

SELECT c.customer_state,
       FORMAT_DATE('%Y-%m', DATE(o.order_purchase_timestamp)) AS order_month,
       COUNT(o.order_id) AS number_of_orders
FROM `Target.orders` o JOIN `Target.customers` c 
      ON o.customer_id = c.customer_id
GROUP BY c.customer_state,
         order_month
ORDER BY c.customer_state,
         order_month;

----------------------------------------------------------------------------------------------------------

-- Q2. How are the customers distributed across all the states?

SELECT customer_state,
       COUNT(DISTINCT customer_id) AS number_of_customers
FROM `Target.customers`
GROUP BY customer_state
ORDER BY number_of_customers;

/*======================================================================================================
IV. Impact on Economy: Analyze the money movement by e-commerce by looking at order prices, freight and others
========================================================================================================*/

--Q1. Calculate the Total & Average value of order price for each state.

SELECT c.customer_state,
       ROUND(SUM(p.payment_value),2) AS total_value,
       ROUND(AVG(p.payment_value),2) AS avg_value
FROM `Target.customers` c JOIN `Target.orders` o 
     ON c.customer_id = o.customer_id 
     JOIN `Target.payments` p 
     ON p.order_id = o.order_id
GROUP BY c.customer_state
ORDER BY c.customer_state;

----------------------------------------------------------------------------------------------------------

--Q2. Calculate the Total & Average value of order freight for each state.

SELECT c.customer_state,
       ROUND(SUM(oi.freight_value),2) AS total_freight,
       ROUND(AVG(oi.freight_value),2) AS avg_freight
FROM `Target.order_items` oi JOIN `Target.orders` o 
     ON oi.order_id = o.order_id
     JOIN `Target.customers` c 
     ON o.customer_id = c.customer_id
GROUP BY c.customer_state
ORDER BY total_freight DESC;

/*======================================================================================================
V. Analysis based on sales, freight and delivery time:
========================================================================================================*/

--Q1. Find the number of days taken to deliver each order from the order’s purchase date as delivery time. 
-- Also, calculate the difference (in days) between the estimated & actual delivery date of an order. Do this in a single query

SELECT order_id,
       DATE_DIFF(DATE(order_delivered_customer_date), DATE(order_purchase_timestamp), DAY) AS time_to_deliver,
       DATE_DIFF(DATE(order_delivered_customer_date), DATE(order_estimated_delivery_date), DAY) AS esti_delivery_diff
FROM `Target.orders`
WHERE order_delivered_customer_date IS NOT NULL;

---------------------------------------------------------------------------------------------------------

--Q2. Find out the top 5 states with the highest & lowest average freight value.

WITH freight_state AS 
                      (SELECT c.customer_state,
                              ROUND(AVG(oi.freight_value),2) AS freight_avg
                      FROM `Target.order_items` oi JOIN `Target.orders` o 
                            ON oi.order_id = o.order_id
                            JOIN `Target.customers` c
                            ON o.customer_id = c.customer_id
                      GROUP BY c.customer_state
                      ),
      ranks AS 
              (SELECT *,
              DENSE_RANK() OVER(ORDER BY freight_avg DESC) AS highest_rank,
              DENSE_RANK() OVER(ORDER BY freight_avg ASC) AS lowest_rank
              FROM freight_state)
SELECT customer_state,
       freight_avg,
       'Highest' AS category
FROM ranks
WHERE highest_rank <= 5

UNION ALL

SELECT customer_state,
       freight_avg,
       'Lowest' AS category
FROM ranks
WHERE lowest_rank <= 5

ORDER BY category DESC, freight_avg DESC;

---------------------------------------------------------------------------------------------------------

--Q3. Find out the top 5 states with the highest & lowest average delivery time.

WITH state_delivery AS (
  SELECT
    c.customer_state,
    ROUND(AVG(DATE_DIFF(
      DATE(o.order_delivered_customer_date),
      DATE(o.order_purchase_timestamp), DAY
    )), 1) AS avg_delivery_days
  FROM `Target.orders` o JOIN `Target.customers` c 
       ON o.customer_id = c.customer_id
  WHERE o.order_delivered_customer_date IS NOT NULL
  GROUP BY c.customer_state
)
(SELECT *, 'Slowest' AS category FROM state_delivery ORDER BY avg_delivery_days DESC LIMIT 5)
UNION ALL
(SELECT *, 'Fastest' AS category FROM state_delivery ORDER BY avg_delivery_days ASC  LIMIT 5);

/*======================================================================================================
VI. Analysis based on the payments
========================================================================================================*/

--Q1. Find the month on month no. of orders placed using different payment types.

SELECT
  FORMAT_DATE('%Y-%m', DATE(o.order_purchase_timestamp)) AS order_month,
  p.payment_type,
  COUNT(o.order_id) AS num_orders
FROM `Target.orders` o
JOIN `Target.payments` p ON o.order_id = p.order_id
GROUP BY order_month, p.payment_type
ORDER BY order_month, num_orders DESC;

--------------------------------------------------------------------------------------------------------

--Q2. Find the no. of orders placed on the basis of the payment instalments that have been paid.

SELECT
  payment_installments,
  COUNT(order_id) AS num_orders
FROM `Target.payments`
GROUP BY payment_installments
ORDER BY payment_installments;

--------------------------------------------------------------------------------------------------------







