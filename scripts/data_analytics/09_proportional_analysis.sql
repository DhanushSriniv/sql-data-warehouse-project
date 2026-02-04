/*
	Part-To-Whole Analysis (Proportional Analysis)

	- Analyzing how an individual part is performing compared to the overall
	  allowing ust to understand which category has the greatest impact on the business.

	Measure:
			* ([Measure]/Total[Measure]) * 100 By [Dimension]
			* Example -
						(Sales/Total Sales) * 100 By Category
						(Quantity/Total Sales) * 100 By Country
*/

-- Which Categories contribute the most to overall sales?

WITH category_by_sales AS(
Select 
		dp.category,
		SUM(fs.sales_amount) as total_sales
From gold.fact_sales fs
Left Join gold.dim_products dp
ON fs.product_key = dp.product_key
Group By dp.category )

Select 
		category,
		total_sales,
		SUM(total_sales) OVER() as overall_sales,
		CONCAT(ROUND((CAST (total_sales AS FLOAT)/ (SUM(total_sales) OVER()))*100, 2), '%') as perc_of_total_sales
from category_by_sales
Where category is not null

