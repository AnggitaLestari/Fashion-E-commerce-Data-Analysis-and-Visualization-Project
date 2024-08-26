-- 1. Product Sales Performance

SELECT 
  i.name AS product_name,
  i.price,
  COUNT(*) AS total_quantity_sold,
  SUM(i.price) AS total_revenue
FROM sales_records sr
JOIN items i ON sr.item_id = i.id
GROUP BY i.name, i.price
ORDER BY total_quantity_sold DESC



-- 2. Daily Product Sales Report
SELECT
	DATE(sr.purchased_at) AS sale_date,
	sr.item_id, i.name, i.price,
	COUNT(*) AS quantity_sold,
	(price * count(*)) as total_sales
  FROM sales_records sr
  JOIN items i ON sr.item_id = i.id
  GROUP BY sr.purchased_at, sr.item_id, i.price, i.name

-- 3. User Activation Overview

SELECT
    COUNT(DISTINCT users.id) AS total_users,
    COUNT(DISTINCT sales_records.user_id) AS active_users,
    COUNT(DISTINCT sales_records.user_id) * 100.0 / 
			COUNT(DISTINCT users.id) AS active_user_percentage
FROM users
LEFT JOIN sales_records ON users.id = sales_records.user_id

-- 4. Customer Purchase Frequency by Age Group

SELECT
  u.name AS customer_name,
  COUNT(sr.id) AS total_purchases,
  u.age AS age_customer,
  CASE
    WHEN u.age BETWEEN 13 AND 22 THEN 'Teenagers'
    WHEN u.age BETWEEN 23 AND 34 THEN 'Young Adults'
    WHEN u.age BETWEEN 35 AND 49 THEN 'Middle-aged Adult'
	WHEN u.age >= 50 THEN 'Senior Adults'
    ELSE 'Unidentified'  
  END AS age_group
FROM users u
LEFT JOIN sales_records sr ON u.id = sr.user_id
GROUP BY u.name, u.age
ORDER BY total_purchases DESC

-- 5.  Customer Purchases by Gender

SELECT 
    gender,
    COUNT(DISTINCT user_id) AS num_customers,
    SUM(i.price) AS total_purchases
FROM sales_records sr
JOIN items i ON sr.item_id = i.id
GROUP BY gender
ORDER BY total_purchases DESC

-- 6. Product Profitability Analysis

WITH revenue AS (
  SELECT
    i.name AS product_name,
    i.price AS price,
    i.cost AS cost_per_unit,
    COUNT(*) AS total_quantity_sold,
    SUM(i.price) AS total_revenue
  FROM sales_records sr
  JOIN items i ON sr.item_id = i.id
  GROUP BY i.name, i.price, i.cost
   
)
SELECT
  product_name,
  price,
  cost_per_unit,
  total_quantity_sold,
  total_revenue,
  ROUND(total_revenue - (total_quantity_sold * cost_per_unit), 2) AS total_profit
FROM revenue
ORDER BY total_profit DESC


-- 7. User Database Summary
select * from users


