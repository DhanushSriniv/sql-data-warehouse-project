--- Data Warehouse: Basic EDA Approach 

-- Creating a new database by exporting the gold layer as a new database

-- Creating new Database
USE master;
GO


-- Drop and recreate the 'DataWarehouseAnalytics' database
IF EXISTS (Select 1 FROM sys.databases WHERE name = 'DataWarehosueAnalytics')
BEGIN 
	  ALTER DATABASE DataWarehosueAnalytics SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	  DROP DATABASE DataWarehosueAnalytics;
END;
GO

-- Create the 'DataWarehosueAnalytics' database
CREATE DATABASE DataWarehosueAnalytics;
GO

USE DataWarehosueAnalytics;
GO

-- Create Schemas

CREATE SCHEMA gold;
GO

CREATE SCHEMA customer_report;
GO

CREATE SCHEMA product_report;
Go

CREATE TABLE gold.dim_customers(
	customer_key nvarchar(50),
	customer_id nvarchar(50),
	customer_number nvarchar(50),
	first_name nvarchar(50),
	last_name nvarchar(50),
	country nvarchar(50),
	marital_status nvarchar(50),
	gender nvarchar(50),
	birthdate nvarchar(50),
	create_date nvarchar(50)
);
GO

CREATE TABLE gold.dim_products(
	product_key nvarchar(50) ,
	product_id nvarchar(50) ,
	product_number nvarchar(50) ,
	product_name nvarchar(50) ,
	category_id nvarchar(50) ,
	category nvarchar(50) ,
	subcategory nvarchar(50) ,
	cost int,
	product_line nvarchar(50),
	product_start_date date,
	maintenance nvarchar(50) ,
);
GO

CREATE TABLE gold.fact_sales(
	order_number nvarchar(50),
	product_key nvarchar(50),
	customer_key nvarchar(50),
	order_date nvarchar(50),
	shipping_date nvarchar(50),
	delivery_due_date nvarchar(50),
	price int,
	sales_amount int,
	sales_quantity int
);
GO

TRUNCATE TABLE gold.dim_customers;
GO

BULK INSERT gold.dim_customers
FROM 'C:\Users\Administrator\OneDrive\Desktop\Portfolio Building\Data Engineer\Projects\1. SQL Warehouse Project\2. GitHub Repository\sql-data-warehouse-project\sql-data-warehouse-project\gold_layer_datasets\gold.dim_customer.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	FORMAT = 'CSV',
	CODEPAGE = '65001',
	KEEPNULLS,
	TABLOCK
);
GO


TRUNCATE TABLE gold.dim_products;
GO

BULK INSERT gold.dim_products
FROM 'C:\Users\Administrator\OneDrive\Desktop\Portfolio Building\Data Engineer\Projects\1. SQL Warehouse Project\2. GitHub Repository\sql-data-warehouse-project\sql-data-warehouse-project\gold_layer_datasets\gold.dim_products.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);
GO

TRUNCATE TABLE gold.fact_sales;
GO

BULK INSERT gold.fact_sales
FROM 'C:\Users\Administrator\OneDrive\Desktop\Portfolio Building\Data Engineer\Projects\1. SQL Warehouse Project\2. GitHub Repository\sql-data-warehouse-project\sql-data-warehouse-project\gold_layer_datasets\gold.fact_sales.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);
GO



