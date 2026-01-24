/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv Files to bronze tables.

Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;
===============================================================================
*/
EXEC bronze.load_bronze


-- Loading the Data And Making the Script as Stored Procedure

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN

	-- Loading the Bronze Layer CRM

	TRUNCATE TABLE bronze.crm_cust_info;

	BULK INSERT bronze.crm_cust_info
	FROM 'C:\Users\Administrator\OneDrive\Documents\Datasets\sql_warehouse\datasets\source_crm\cust_info.csv'
	With (
	FirstROW = 2,
	Fieldterminator = ',',
	TABLOCK);

	TRUNCATE TABLE bronze.crm_prod_info;

	BULK INSERT bronze.crm_prod_info
	FROM 'C:\Users\Administrator\OneDrive\Documents\Datasets\sql_warehouse\datasets\source_crm\prd_info.csv'
	With (
	FirstROW = 2,
	Fieldterminator = ',',
	TABLOCK);

	TRUNCATE TABLE bronze.crm_sales_details;

	BULK INSERT bronze.crm_sales_details
	FROM 'C:\Users\Administrator\OneDrive\Documents\Datasets\sql_warehouse\datasets\source_crm\sales_details.csv'
	With (
	FirstROW = 2,
	Fieldterminator = ',',
	TABLOCK);

	-- Loading Bronze Layer ERP Data
	TRUNCATE TABLE bronze.erp_cust_az12;

	BULK INSERT bronze.erp_cust_az12
	FROM 'C:\Users\Administrator\OneDrive\Documents\Datasets\sql_warehouse\datasets\source_erp\CUST_AZ12.csv'
	With (
	FirstROW = 2,
	Fieldterminator = ',',
	TABLOCK);

	TRUNCATE TABLE bronze.erp_loc_a101;

	BULK INSERT bronze.erp_loc_a101
	FROM 'C:\Users\Administrator\OneDrive\Documents\Datasets\sql_warehouse\datasets\source_erp\LOC_A101.csv'
	With (
	FirstROW = 2,
	Fieldterminator = ',',
	TABLOCK);

	TRUNCATE TABLE bronze.erp_px_cat_g1v2;

	BULK INSERT bronze.erp_px_cat_g1v2
	FROM 'C:\Users\Administrator\OneDrive\Documents\Datasets\sql_warehouse\datasets\source_erp\PX_CAT_G1V2.csv'
	With (
	FirstROW = 2,
	Fieldterminator = ',',
	TABLOCK);

	END TRY
	BEGIN CATCH
		PRINT 'Error Occured In The Process Of Loading Bronze Layer'
		Print 'Error Message ' + Error_Message();
		Print 'Error Message ' + CAST(Error_Number() AS NVARCHAR);
		PRINT 'Error Message ' + Cast(Error_State() AS NVARCHAR);
	END CATCH
END