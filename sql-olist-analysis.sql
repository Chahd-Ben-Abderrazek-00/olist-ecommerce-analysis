
-- Query 1: Preview the orders table
SELECT * 
FROM orders
LIMIT 5;

-- Query 2: Order status distribution
SELECT order_status, COUNT(*) as count
FROM orders
GROUP BY order_status
ORDER BY count DESC;

-- Query 3: Review score distribution
SELECT review_score, COUNT(*) as count
FROM order_reviews
GROUP BY review_score
ORDER BY review_score ASC;

-- Query 4: Average review score by order status 
SELECT orders.order_status, 
       AVG(order_reviews.review_score) AS average, 
       COUNT(*)
FROM orders
JOIN order_reviews ON orders.order_id = order_reviews.order_id
GROUP BY order_status
ORDER BY average DESC;

-- Query 5: Average review score : late vs on time
SELECT 
    CASE WHEN orders.order_delivered_customer_date > orders.order_estimated_delivery_date 
        THEN 'Late' 
        ELSE 'On Time' 
    END AS delivery_status,
    ROUND(AVG(order_reviews.review_score), 2) AS avg_review,
    COUNT(*) AS order_count
FROM orders
JOIN order_reviews ON orders.order_id = order_reviews.order_id
WHERE orders.order_status = 'delivered'
GROUP BY delivery_status
ORDER BY avg_review DESC;

-- Query 6: How bad are the delays?
SELECT 
    CASE 
        WHEN DATEDIFF(order_delivered_customer_date, order_estimated_delivery_date) BETWEEN 1 AND 7 THEN '1-7 days late'
        WHEN DATEDIFF(order_delivered_customer_date, order_estimated_delivery_date) BETWEEN 8 AND 14 THEN '8-14 days late'
        WHEN DATEDIFF(order_delivered_customer_date, order_estimated_delivery_date) >= 15 THEN '15+ days late'
    END AS delay_bucket,
    COUNT(*) AS order_count,
    AVG(DATEDIFF(order_delivered_customer_date, order_estimated_delivery_date)) AS avg_delay_days,
    MAX(DATEDIFF(order_delivered_customer_date, order_estimated_delivery_date)) AS max_delay_days
FROM orders
WHERE order_status = 'delivered' 
AND order_delivered_customer_date > order_estimated_delivery_date
AND DATEDIFF(order_delivered_customer_date, order_estimated_delivery_date) >= 1
GROUP BY delay_bucket;

-- Query 7: Late rate by seller
SELECT 
    seller_id,
    COUNT(*) AS total_orders,
    SUM(CASE WHEN order_delivered_customer_date > order_estimated_delivery_date 
        THEN 1 ELSE 0 END) AS late_orders,
    ROUND(SUM(CASE WHEN order_delivered_customer_date > order_estimated_delivery_date 
        THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS late_rate_pct
FROM orders
JOIN order_items USING(order_id)
WHERE order_status = 'delivered'
GROUP BY seller_id
HAVING total_orders > 30
ORDER BY late_rate_pct DESC;

-- Query 8: Late rate by product category
SELECT 
    product_category_name_english,
    COUNT(*) AS total_orders,
    SUM(CASE WHEN order_delivered_customer_date > order_estimated_delivery_date 
        THEN 1 ELSE 0 END) AS late_orders,
    ROUND(SUM(CASE WHEN order_delivered_customer_date > order_estimated_delivery_date 
        THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS late_rate_pct
FROM orders
JOIN order_items USING(order_id)
JOIN products USING(product_id)
JOIN category_translation USING(product_category_name)
WHERE order_status = 'delivered'
GROUP BY product_category_name_english
HAVING total_orders > 30
ORDER BY late_rate_pct DESC;