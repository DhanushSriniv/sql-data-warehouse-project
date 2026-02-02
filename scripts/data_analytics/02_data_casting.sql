/*
Database Exploration:

This Script is all about database exploration and Exploring the database, tables 
and columns to understand, how data is structured or organized in the database.
*/


USE DataWarehosueAnalytics;
GO

-- Explore All Objects Inside the Database
SELECT * FROM INFORMATION_SCHEMA.TABLES


-- Explore All Columns in the "dim_customers"
SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers';
GO

/*
	Performing the data casting/manipulation for the Birth date
*/
-- Addding new column
ALTER TABLE gold.dim_customers          
ADD birthdate_dt DATE NULL;
GO

 -- Inserting Converted date into new column
UPDATE gold.dim_customers                              
SET birthdate_dt = TRY_CONVERT(date, birthdate);
GO

-- Performing Data Quality check
Select                                                
	Count(*),
	Count(birthdate),
	Count(TRY_CONVERT(date, birthdate, 101)) as new
From gold.dim_customers;
GO

Select birthdate,
	   TRY_CONVERT(date, birthdate) as new_o_d
From gold.dim_customers
Where birthdate IS NOT NULL 
	AND TRY_CONVERT(date, birthdate) IS NUll;
GO

-- Inspect Bad Values
SELECT DISTINCT birthdate
FROM gold.dim_customers
WHERE birthdate IS NOT NULL
  AND TRY_CONVERT(date, birthdate) IS NULL;
GO

-- Dropping the Column after Validation
ALTER TABLE gold.dim_customers
DROP COLUMN birthdate;
GO

-- Renaming the column 
EXEC sp_rename 'gold.dim_customers.birthdate_dt', 'birthdate', 'COLUMN';


-- Explore all the columns in "dim_products"
SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_products';
GO

/*
	Performing the data casting/manipulation for the Birth date
*/
-- Addding new column
ALTER TABLE gold.dim_products          
ADD start_date DATE NULL;
GO

 -- Inserting Converted date into new column
UPDATE gold.dim_products                              
SET start_date = TRY_CONVERT(date, product_start_date);
GO

-- Performing Data Quality check
Select                                                
	Count(*),
	Count(product_start_date),
	Count(TRY_CONVERT(date, product_start_date, 101)) as new
From gold.dim_products;
GO

-- Dropping the Column after Validation
ALTER TABLE gold.dim_products
DROP COLUMN product_start_date;
GO

-- Renaming the column 
EXEC sp_rename 'gold.dim_products.start_date', 'start_date', 'COLUMN';


-- Explore all the columns in "dim_products"
SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'fact_sales';
GO

/*
	Performing the data casting/manipulation for the Order date
*/
-- Addding new column
ALTER TABLE gold.fact_sales          
ADD order_date_dt DATE NULL;
GO

 -- Inserting Converted date into new column
UPDATE gold.fact_sales                              
SET order_date_dt = TRY_CONVERT(date, order_date);
GO

-- Performing Data Quality check
Select                                                
	Count(*),
	Count(order_date),
	Count(TRY_CONVERT(date, order_date, 101)) as new
From gold.fact_sales;
GO

Select order_date,
	   TRY_CONVERT(date, order_date) as new_o_d
From gold.fact_sales
Where order_date IS NOT NULL 
	AND TRY_CONVERT(date, order_date) IS NUll;
GO

-- Inspect Bad Values
SELECT DISTINCT order_date
FROM gold.fact_sales
WHERE order_date IS NOT NULL
  AND TRY_CONVERT(date, order_date) IS NULL;
GO

-- Dropping the Column after Validation
ALTER TABLE gold.fact_sales
DROP COLUMN order_date;
GO

EXEC sp_rename 'gold.fact_sales.order_date_dt', 'order_date', 'COLUMN';

/*
	Performing the data casting/manipulation for the Shipping date
*/
-- Addding new column
ALTER TABLE gold.fact_sales          
ADD shipping_date_dt DATE NULL;
GO

 -- Inserting Converted date into new column
UPDATE gold.fact_sales                              
SET shipping_date_dt = TRY_CONVERT(date, shipping_date);
GO

-- Performing Data Quality check
Select                                                
	Count(*),
	Count(shipping_date),
	Count(TRY_CONVERT(date, shipping_date, 101)) as new
From gold.fact_sales;
GO

-- Dropping the Column after Validation
ALTER TABLE gold.fact_sales
DROP COLUMN shipping_date;
GO

EXEC sp_rename 'gold.fact_sales.shipping_date_dt', 'shipping_date', 'COLUMN';

/*
	Performing the data casting/manipulation for the Delivery Due date
*/
-- Addding new column
ALTER TABLE gold.fact_sales          
ADD due_date DATE NULL;
GO

 -- Inserting Converted date into new column
UPDATE gold.fact_sales                              
SET due_date = TRY_CONVERT(date, delivery_due_date);
GO

-- Performing Data Quality check
Select                                                
	Count(*),
	Count(delivery_due_date),
	Count(TRY_CONVERT(date, delivery_due_date, 101)) as new
From gold.fact_sales;
GO

-- Dropping the Column after Validation
ALTER TABLE gold.fact_sales
DROP COLUMN delivery_due_date;
GO

