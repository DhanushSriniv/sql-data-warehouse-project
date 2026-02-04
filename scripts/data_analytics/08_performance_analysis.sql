/*
	Performance Analysis

	Measure:
			* Current[Measure] - Target[Measure]
			* Current Sales - Average Sales
			* Current Year Sales -  Previous Year Sales  (<- YoY Analysis)
			* Current Sales - Lowest Sales

*/

-- Analyzing the yearly performance of products by comparing
-- each product's sales to both its average sales performance 
-- and the previous year's sales.
WITH yearly_product_sales AS(
Select 
		YEAR(fs.order_date) as order_year,
		dp.product_name,
		SUM(fs.sales_amount) as current_sales
from gold.fact_sales fs
LEFT JOIN gold.dim_products dp
ON fs.product_key = dp.product_key
Where fs.order_date is not null
GROUP BY YEAR(fs.order_date), dp.product_name)

Select 
		order_year,
		product_name,
		current_sales,
		AVG(current_sales) OVER(PArtition by product_name) as avg_sales,
		(current_sales - AVG(current_sales) OVER(PArtition by product_name)) as diff_Avg,
		CASE WHEN (current_sales - AVG(current_sales) OVER(PArtition by product_name)) > 0 THEN 'Above Avg'
			 WHEN (current_sales - AVG(current_sales) OVER(PArtition by product_name)) < 0 THEN 'Below Avg'
			 ELSE 'Avg'
		END avg_change,
		-- YoY Analysis
		LAG(current_sales) OVER(PARTITION BY product_name Order by order_year) as previous_year_sales,
		(current_sales - LAG(current_sales) OVER(PARTITION BY product_name Order by order_year)) as diff_prev_sales,
		CASE WHEN (current_sales - LAG(current_sales) OVER(PARTITION BY product_name Order by order_year)) > 0 THEN 'Increase'
			 WHEN (current_sales - LAG(current_sales) OVER(PARTITION BY product_name Order by order_year)) < 0 THEN 'Decrease'
			 ELSE 'Stable/No Change'
		END prev_change_sales
from yearly_product_sales
Where product_name is not null














