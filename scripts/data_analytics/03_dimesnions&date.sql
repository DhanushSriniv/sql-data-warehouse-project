/*
	Dimensions AND Date Exploration:

	This Script is all about exploring the dimensions in the data, and to 
	understand what values those dimensions bring to the insights. And also
	to analyze and understand the timeline of the data presented.

*/
-- 1. Explore All Countries our Customers Come From.
SELECT DISTINCT country FROM gold.dim_customers;
GO

-- 2. Explore All Categories Of Products The data is About
SELECT DISTINCT category FROM gold.dim_products;
GO

-- Date Exploration

-- 3. Find the date of the first order and last order
Use DataWarehosueAnalytics;
GO

Select
	   MIN(order_date) as first_order_date,
	   MAX(order_date) as last_order_date,
	   DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) as order_rnge_months,
	   DATEDIFF(YEAR, MIN(order_date), MAX(order_date)) as order_rnge_year
From gold.fact_sales

-- 4. Find Youngest and the oldest customer

Select 
		Min(birthdate) as oldest_bdate,
		MAX(birthdate) as youngest_bdate
From gold.dim_customers

