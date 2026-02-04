/*
	===================================================================================
	Customer Report
	===================================================================================

	Script Purpose: 
					This script consolidates the key customer metrics and behaviours.
	Highlishts:
				1. Gathering the essential fields (names, age, and transaction details).
				2. Aggregate customer-level metrics:
					- total orders, total sales, total quantity purchased, total products,
					  lifespan (in months)
				3. Segmenting customers into categories (VIP, Regular, New) and age groups.
				4. Calculate Valuable KPIs:
					- recency (months since last order)
					- average order value
					- average monthly spend
*/

CREATE VIEW gold.customer_report AS 

-- 1. Base Query: Retrieves Core columns from tables
WITH base_query AS (
Select
		fs.order_number, fs.product_key, fs.order_date, fs.sales_amount, 
		fs.sales_quantity, dc.customer_key, dc.customer_number, 
		CONCAT(dc.first_name,' ',dc.last_name) AS customer_name, DATEDIFF(year,dc.birthdate, GETDATE()) AS age
FROM gold.fact_sales fs
LEFT JOIN gold.dim_customers dc
ON fs.customer_key = dc.customer_key
WHERE fs.order_date IS NOT NULL),

-- 2. Customer Aggregation
customer_aggregation AS (
Select customer_key, customer_number, customer_name, age,
	   COUNT(Distinct order_number) AS total_orders,
	   SUM(sales_amount) AS total_sales,
	   SUM(sales_quantity) AS total_quantity,
	   COUNT(DISTINCT product_key) as total_products,
	   MAX(order_date) as last_order_Date,
	   DATEDIFF(month, MIN(order_Date), MAX(order_date)) as lifespan
FROM base_query
WHERE customer_key IS NOT NULL AND customer_number IS NOT NULL
GROUP BY customer_key, customer_number, customer_name, age
)

-- 3. Customer Segmentation & Calculating valuable KPI's
Select customer_key, customer_number, customer_name, 
	   CASE WHEN age < 20 THEN 'Under 20'
			WHEN age BETWEEN 20 AND 35 THEN '20-35'
			WHEN age BETWEEN 35 AND 50 THEN '35-50'
			ELSE 'Above 50'
	   END age_seg,
	   Case WHEN lifespan >= 12 AND total_sales > 5000  THEN 'VIP'
			WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'Regular'
			ELSE 'New'
	   END customer_seg,
	   last_order_Date,
	   DATEDIFF(month, last_order_Date, GETDATE()) AS recency,
	   total_orders,
	   total_sales,
	   total_quantity,
	   total_products,
	   lifespan,
	   -- Compute Average Order Value (AVO)
	   CASE WHEN total_orders = 0 THEN 0
			ELSE (total_sales/total_orders) 
	   END avg_order_value,
	   
	   -- Compute average monthly spend
	   CASE WHEN lifespan = 0 THEN total_sales
			ELSE total_sales/lifespan
		END AS avg_monthly_Spend
From customer_aggregation
