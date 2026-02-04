/*
	Change-Over-Time

	- Analyze how a measure evolves over time.
	- Helps track trends and identify seasonality in your data.

	Measure: 
			[Measure] By [Date Dimension]
			Example: Total Sales BY Year, Average cost By Month

    Tool Used: Window Function & Aggregate Window function
*/

Select 
		DATETRUNC(month, order_date) as order_date, 
		SUM(sales_amount) as total_sales,
		Count(Distinct customer_key) as total_customers,
		SUM(sales_quantity) as total_quantity
from gold.fact_sales
Where order_date is not null
group by DATETRUNC(MONTH, order_date)
order by DATETRUNC(MONTH, order_date)

CREATE OR ALTER VIEW gold.yearly_monthly_min_max_sales AS -- Creating a view for max, min for year, month sales

WITH monthly_sales AS (                                   --  Aggregating & Grouping Data 
    SELECT 
        YEAR(order_date)  AS order_year,
        MONTH(order_date) AS order_month,
        SUM(sales_amount) AS total_sales,
        COUNT(DISTINCT customer_key) AS total_customers,
        SUM(sales_quantity) AS total_quantity
    FROM gold.fact_sales
    GROUP BY
        YEAR(order_date),
        MONTH(order_date)
),
ranked_sales AS (                                         -- Ranking the data for max, min sales
    SELECT *,
        ROW_NUMBER() OVER (PARTITION BY order_year ORDER BY total_sales DESC) AS max_sales_rank,
        ROW_NUMBER() OVER (PARTITION BY order_year ORDER BY total_sales ASC) AS min_sales_rank,
        MAX(total_sales) OVER (PARTITION BY order_year) AS max_year_sales,
        MIN(total_sales) OVER (PARTITION BY order_year) AS min_year_sales
    FROM monthly_sales
)
SELECT                                                   -- Filtering the data
    order_year,
    order_month,
    total_sales,
    total_quantity,
    total_customers,
    max_year_sales - min_year_sales AS sales_difference
FROM ranked_sales
WHERE max_sales_rank = 1
   OR min_sales_rank = 1;
GO

-- Executing the View
SELECT *
FROM gold.yearly_monthly_min_max_sales
ORDER BY order_year, total_sales DESC;
