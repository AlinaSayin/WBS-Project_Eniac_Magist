USE magist;

SELECT *
FROM orders;

select COUNT(order_id) 
FROM orders;
-- A.How many orders were delivered ?
SELECT order_status, COUNT(*) AS Order_Status_numbers
FROM orders
GROUP BY order_status
ORDER BY Order_Status_numbers DESC;

SELECT year(order_purchase_timestamp), month(order_purchase_timestamp), COUNT(customer_id)
FROM orders
GROUP BY year(order_purchase_timestamp), month(order_purchase_timestamp)
ORDER BY year(order_purchase_timestamp), month(order_purchase_timestamp);

-- What categories of tech products does Magist have?
SELECT *
FROM products;

SELECT COUNT(distinct product_id) AS SUM_Products
FROM products;

SELECT product_category_name, COUNT(distinct product_id)
FROM products
GROUP BY product_category_name
Order BY COUNT(product_id) DESC;

SELECT product_category_name_english, COUNT(*)
FROM products
	INNER JOIN product_category_name_translation ON products.product_category_name = product_category_name_translation.product_category_name
GROUP BY product_category_name_english
Order BY product_id DESC;

-- END of What categories of tech products does Magist have?

SELECT *
FROM order_items;

SELECT order_item_id, COUNT(order_id)
FROM order_items
GROUP BY order_item_id;

SELECT 
	count(DISTINCT product_id) AS n_products
FROM
	order_items;
    
-- What’s the average price of the products being sold?
SELECT MIN(price), MAX(price)
FROM order_items;

SELECT MIN(payment_value), MAX(payment_value)
FROM order_payments;
-- END of What’s the average price of the products being sold?

SELECT product_category_name_english, COUNT(distinct product_category_name)
FROM product_category_name_translation
GROUP BY product_category_name_english
Order BY COUNT(product_category_name) DESC;

SELECT 
	product_category_name_translation.product_category_name_english, orders.order_id, orders.order_purchase_timestamp
FROM
	product_category_name_translation
		LEFT JOIN 
	products ON product_category_name_translation.product_category_name = products.product_category_name
		LEFT JOIN 
	order_items ON products.product_id = order_items.product_id
		LEFT JOIN
	orders ON order_items.order_id = orders.order_id
WHERE
	product_category_name_translation.product_category_name_english in ("computers_accessories", "electronics", "pc_gamer", "security_and_services", "signaling_and_security", "telephony", "computers");
 
 SELECT 
	AVG(price)
FROM 
	order_items;
 
-- How many months of data are included in the magist database?

SELECT 
	sellers.seller_id, order_items.order_id, shipping_limit_date
FROM 
	sellers
		INNER JOIN
	order_items ON sellers.seller_id = order_items.seller_id;
-- F. How many months of data are included in the magist database? Try 2
SELECT 
	COUNT(DISTINCT sellers.seller_id), order_items.order_id, shipping_limit_date
FROM 
	sellers
		RIGHT JOIN
	order_items ON sellers.seller_id = order_items.seller_id
GROUP BY sellers.seller_id
ORDER BY sellers.seller_id ASC;
-- How many sellers are there? 
SELECT COUNT(seller_id)
FROM sellers;

-- How many Tech Sellers are there?
SELECT seller_id, product_category_name_english, COUNT(*)
FROM products
	LEFT JOIN order_items ON products.product_id = order_items.product_id
    LEFT JOIN product_category_name_translation ON products.product_category_name = product_category_name_translation.product_category_name
WHERE product_category_name_english IN ("computers_accessories", "electronics", "pc_gamer", "security_and_services", "signaling_and_security", "telephony", "computers")
GROUP BY seller_id;


-- C. Most popular categories?

SELECT COUNT(distinct products.product_id), product_category_name_english, COUNT(*) AS Popularity
FROM order_items
	RIGHT JOIN products ON order_items.product_id = products.product_id
    RIGHT JOIN product_category_name_translation ON products.product_category_name = product_category_name_translation.product_category_name
GROUP BY product_category_name_english
ORDER BY Popularity DESC;

-- How many Tech sellers are there? What percentage of overall sellers are Tech sellers?

-- SELECT "Category_NT",
-- CASE 
	-- WHEN product_category_name_translation.product_category_name_english = "computers_accessories" THEN "Tech"
	-- WHEN product_category_name_translation.product_category_name_english = "electronics" THEN "Tech"
	-- WHEN product_category_name_translation.product_category_name_english = "pc_gamer" THEN "Tech"
	-- WHEN product_category_name_translation.product_category_name_english = "security_and_services" THEN "Tech"
	-- WHEN product_category_name_translation.product_category_name_english = "signaling_and_security" THEN "Tech"
	-- WHEN product_category_name_translation.product_category_name_english = "telephony" THEN "Tech"
	-- WHEN product_category_name_translation.product_category_name_english = "computers" THEN "Tech"
	-- ELSE "Not Tech"
	-- END AS Category_NT
-- FROM product_category_name_translation;

-- In relation to the delivery time:
-- What’s the time between the order being placed and the product being delivered?
SELECT *
FROM orders;

SELECT order_id, timestampdiff(DAY, (order_purchase_timestamp), (order_delivered_customer_date)) AS "TIMEDIFF"
FROM orders
group by order_id;

-- B. How many orders are delivered on time vs orders delivered with a delay?

SELECT order_id, timestampdiff(DAY, (order_estimated_delivery_date), (order_delivered_customer_date)) AS "TIMEDIFF"
FROM orders
group by order_id;

-- How many orders are delivered on time vs orders delivered with a delay? Different approach NO.2

SELECT *
FROM orders
WHERE order_estimated_delivery_date AND order_delivered_customer_date IS NOT NULL;

-- How many orders are delivered on time vs orders delivered with a delay? Different approach NO.3

SELECT order_delivered_customer_date - order_estimated_delivery_date AS delay 
FROM orders;

