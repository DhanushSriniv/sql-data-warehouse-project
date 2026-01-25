-- Silver Layer: Altering Specified Tables
-- Description: Altering the Silver Layer Tables As Per Requirement and Based on Transformations

-- Silver Layer -  crm_prd_info

-- Dropping & Updating the silver.crm_prd_info table
		IF OBJECT_ID('silver.crm_prd_info', 'U') IS NOT NULL
			DROP TABLE silver.crm_prd_info;
		GO

		CREATE TABLE silver.crm_prd_info (
			prd_id       INT,
			cat_id       NVARCHAR(50),
			prd_key      NVARCHAR(50),
			prd_nm       NVARCHAR(50),
			prd_cost     INT,
			prd_line     NVARCHAR(50),
			prd_start_dt DATE,
			prd_end_dt   DATE,
			dwh_create_date DATETIME2 DEFAULT GETDATE()

		);


-- Silver Layer - crm_sales_details

		-- Dropping & Updating the Silver Layer - crm_sales_details
		IF OBJECT_ID('silver.crm_sales_details', 'U') IS NOT NULL
			DROP TABLE silver.crm_sales_details;
		GO

		CREATE TABLE silver.crm_sales_details (
			sls_ord_num  NVARCHAR(50),
			sls_prd_key  NVARCHAR(50),
			sls_cust_id  INT,
			sls_order_dt Date,
			sls_ship_dt  Date,
			sls_due_dt   Date,
			sls_sales    INT,
			sls_quantity INT,
			sls_price    INT,
			dwh_create_date DATETIME2 DEFAULT GETDATE()
		);
	
