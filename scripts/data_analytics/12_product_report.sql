/*
	================================================================================================
	Product Report
	================================================================================================

	Script Purpose: 
					This script consolidates the key product metrics and behaviours.
	Highlishts:
				1. Gathering the essential fields (product name, category, subcategory and cost).
				2. Aggregate product-level metrics:
					- total orders, total sales, total quantity sold, total customers,
					  lifespan (in months), average sales
				3. Segmenting product by revenue to identify High-Performers, Mid-Range, or Low-Performers.
				4. Calculate Valuable KPIs:
					- recency (months since last order)
					- average order revenue (AOR)
					- average monthly revenue (AMR),
					  Formula: Total Product Sales/ No.of Months the product has been selling
*/

CREATE VIEW gold.product_report AS 

-- 1. Base Query gathering essential field
WITH base_query AS (
Select 
		ds.product_key, ds.product_number, ds.product_name, 
		ds.category, ds.subcategory, ds.start_date, ds.cost, ds.maintenance,
		fs.order_number, fs.customer_key, fs.order_date, fs.sales_amount, fs.sales_quantity, fs.price
from gold.fact_sales fs
LEFT JOIN gold.dim_products ds
ON fs.product_key = ds.product_key
Where ds.product_key IS NOT NULL AND product_number IS NOT NULL),

-- 2. Aggregating Product Level Metrics
product_aggregation AS (
Select 
		product_key, product_number, product_name, category, subcategory, 
		start_date, cost, maintenance, MAx(order_date) as last_order_date,
		COUNT(Distinct order_number) as total_orders,
		SUM(sales_amount) as total_sales,
		SUM(sales_quantity) as total_quantity_sold,
		COUNT(Distinct customer_key) as total_customers,
		DATEDIFF(month, MIN(order_Date), MAX(order_date)) as lifespan,
		price,
		AVG(SUM(sales_amount)) OVER() AS avg_sales,
		0.30 * AVG(SUM(sales_amount)) OVER() As offset_Avg_sales_value
FROM base_query
GROUP BY product_key, product_number, product_name, category, 
		 subcategory, start_date, maintenance, cost, price

)

-- 3. Segementing Product By Revenue

Select 
		product_key, product_number, product_name, category, subcategory, maintenance,
		cost, price as selling_price,
		total_orders, total_quantity_sold, total_sales,
		CASE WHEN total_sales >= avg_sales + offset_Avg_sales_value THEN 'High Performer'
			 WHEN total_sales <= avg_sales - offset_Avg_sales_value THEN 'Low Performer'
			 ELSE 'Mid Performer'
		END as product_segment,
		DATEDIFF(month, last_order_Date, GETDATE()) AS recency_in_months,
		total_customers, lifespan,
		-- Compute Average Order Value (AVO)
	   CASE WHEN total_orders = 0 THEN 0
			ELSE (total_sales/total_orders) 
	   END avg_order_value,

	   -- Compute Average Monthly Revenue
	   -- Formula: Total Product Sales/ No.of Months the product has been selling
	   CASE WHEN lifespan = 0 Then total_sales
			Else total_sales/lifespan
	   END avg_monthly_revenue

from product_aggregation




