/*
	Cumulative Analysis

	- Aggragate the data progressively over time.
	- Helps to understand whether our business is growing or declining. 

	Measure:
			- [Cumulative Measure] By [Date Dimension]
			- Example: 
					* Running Total Sales By Year
					* Moving Average Of Sales By Month
	Tool Used: Aggregate Window Functions
*/

-- Calculate the total sales per Month & running total of sales over time
-- ** Running total is reseted to every year

Select 
		order_date,
		total_sales,
		SUM(total_sales) OVER(
							PARTITION BY YEAR(order_date)   -- Reset happens by year
							ORDER BY order_date
							) as runnning_sales,
		AVG(avg_price) OVER (
							PARTITIOn BY YEAR(order_date)
							ORDER BY order_date
							) as running_avg,
		SUM(total_quantity) OVER(
							PARTITION BY YEAR(order_date)   -- Reset happens by year
							ORDER BY order_date
							) as running_quantity
From (
Select 
		DATETRUNC(MONTH, order_date) as order_date,
		Sum(sales_amount) as total_sales,
		SUM(sales_quantity) as total_quantity,
		AVG(price) as avg_price
FROM gold.fact_sales
WHEre order_date is NOt null
Group by DATETRUNC(MONTH, order_date)
) t
Order by order_date;





