/*
	Ranking Analysis

	- Order the values of dimensions by measure.
	- Top N performers | Bottom N Performers

	Measure: 
			* Rank [Dimension] By [Measure]
			* Rank Countries By Total Sales
			* Top 5 Products By Quantity
			* Bottom 3 Customers BY Total Order
*/

-- Which 5 products generate the highest revenue?
SELECT TOP 5
		dp.product_name,
		SUM(fs.sales_amount) as total_revenue
FROM gold.fact_sales fs
LEFT JOIN gold.dim_products dp
ON dp.product_key = fs.product_key
GROUP BY dp.product_name
ORDER BY total_revenue DESC

-- *** Using Window Functions
SELECT * FROM 
	(SELECT 
			dp.product_name,
			SUM(fs.sales_amount) as total_revenue,
			ROW_NUMBER() OVER(ORDER BY SUM(fs.sales_amount) DESC) as product_ranks
	FROM gold.fact_sales fs
	LEFT JOIN gold.dim_products dp
	ON dp.product_key = fs.product_key
	GROUP BY dp.product_name) as t
WHERE product_ranks <= 5;

-- Find the top 10 customers who have generated the highest revenue
-- AND 3 Customer with the fewest Orders Placed
WITH rank_of_customers AS(
	SELECT 
			dc.customer_key,
			dc.first_name,
			dc.last_name,
			sum(fs.sales_amount) as total_revenue,
			Count(fs.order_number) as total_orders,
			DENSE_RANK() OVER(ORDER BY SUM(fs.sales_amount) DESC) as customer_rank_revenue,
			DENSE_RANK() OVER(ORDER BY COunt(fs.order_number) ASC) as customer_rank_by_order
	FROM gold.fact_sales fs
	LEFT JOIN gold.dim_customers dc
	ON dc.customer_key = fs.customer_key
	GROUP BY dc.customer_key, dc.first_name, dc.last_name
)

-- TOP 10 Customers in total revenue
SELECT *,
       'Top 10 by Revenue' AS category
FROM rank_of_customers
WHERE customer_rank_revenue <= 10

UNION ALL

-- Below 3 Customers with fewest orders
SELECT *,
       'Bottom 3 by Orders' AS category
FROM rank_of_customers
WHERE customer_rank_by_order <= 3
ORDER BY customer_rank_revenue;


-- What are the 5 worst-performing products in terms of sales?

SELECT TOP 5
		dp.product_name,
		SUM(fs.sales_amount) as total_revenue
FROM gold.fact_sales fs
LEFT JOIN gold.dim_products dp
ON dp.product_key = fs.product_key
GROUP BY dp.product_name
ORDER BY total_revenue ASC;
Go






