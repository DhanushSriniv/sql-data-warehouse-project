/*
	Measure/Data Segmentation

	Measure:
			* [Measure] By [Measure]
			* Example: 
						- Total products by sales range
						- Total customer by Age
*/

-- Segment products into cost ranges and count how products fall into each segment.

WITH product_segments AS ( 
		Select
				product_key,
				product_name,
				cost,
				CASE WHEN cost < 100 THEN 'Below 100'
				  WHEN cost BETWEEN 100 AND 500 THEN '100-500'
				  WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
				  WHEN cost BETWEEN 1000 AND 2000 THEN '1000-2000'
				  ElSE 'Above 2000'
				END cost_range
		From gold.dim_products
		Where cost != 0  and cost > 0 )

Select 
		cost_range,
		Count(product_key) as total_products
From product_segments
Group By cost_range
Order by total_products Desc;
GO

/*
		Group customers into three segments based on their spending behavior:
		
		Condition:
				* VIP: at least 12 months of history and spending more than 5000.
				* Regular: at least 12 months of history but spending 5000 or less.
				* New: lifespan less than 12 months.

		And find the total number of customers by each group.
*/
With customer_spending_span AS (
	Select
			customer_key,
			SUM(sales_amount) as total_spending,
			MIN(order_date) as first_order,
			Max(order_date) as last_order,
			DATEDIFF(month, MIN(order_date), MAX(order_date)) as life_span
	From gold.fact_sales
	Group By customer_key ),

customer_segmentation AS (
	Select 
			customer_key,
			total_spending,
			life_span,
			Case WHEN life_span >= 12 AND total_spending > 5000  THEN 'VIP'
				 WHEN life_span >= 12 AND total_spending <= 5000 THEN 'Regular'
				 ELSE 'New'
			END customer_seg
	From customer_spending_span )

SELECT 
		customer_seg,
		COUNT(customer_key) as total_customers
FROM customer_segmentation
Group By customer_seg
ORDER BY total_customers










