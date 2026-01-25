-- Silver Layer:
-- Method: Truncate & Insert
-- Description: Ingesting from 'Bronze' layer to 'Silver' layer and also performing neccessary transformations.


CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN

		-- Truncate Data 
		TRUNCATE TABLE silver.crm_cust_info;

		-- 1. Silver Layer - crm_cust_info
		Insert INTO silver.crm_cust_info(
			cst_id,
			cst_key,
			cst_firstname,
			cst_lastname,
			cst_marital_status,
			cst_gndr,
			cst_create_date
		)
		-- Note: Handling Null Values in the cst_id, using rank method -  row number ()
		Select cst_id,
			   cst_key,
			   TRIM(cst_firstname) as cst_firstname,
			   TRIM(cst_lastname) AS cst_lastname,
			   CASE When UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single' -- Normalize Marial Status
					When UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
					ELSE 'n/a'
				END cst_marital_status,
			   CASE When UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'          -- -- Normalize Gender
					When UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
					ELSE 'n/a'
				END cst_gndr,
			   cst_create_date
		From 
		(Select *,            -- Remove Duplicates
			   ROW_NUMBER() Over(Partition By cst_id Order BY cst_create_date DESC) as flag_last  
		From bronze.crm_cust_info
		where cst_id is not null) as t
		Where flag_last = 1 


		-- 2. Silver Layer - crm_prd_info

		-- Truncate Data 
		TRUNCATE TABLE silver.crm_prd_info;

		Insert Into silver.crm_prd_info(
			prd_id,
			cat_id,
			prd_key,
			prd_nm,
			prd_cost,
			prd_line,
			prd_start_dt,
			prd_end_dt
		)

		select prd_id,
			   REPLACE(SUBSTRING(prd_key,1,5), '-', '_' ) as cat_id, -- Extract Category ID
			   SUBSTRING(prd_key, 7, len(prd_key)) as prd_key,   -- Extract Product Key
			   prd_nm,
			   ISNULL(prd_cost, 0) as prd_cost,
			   Case UPPER(TRIM(prd_line))
					WHEN 'M' THEN 'Mountain'
					WHEN 'R' Then 'Road'
					WHEN 'T' Then 'Touring'
					when 'S' THEN 'Other Sales'
					ELSE 'n/a'
			   END AS prd_line, -- Map Product Line codes to descriptive Values
			   CAST(prd_start_dt as DATE) as prd_start_dt,
			   CAST(
			   LEAD(prd_start_dt) OVER (PARTITION by prd_key order by prd_start_dt)
			   AS DATE) as prd_end_dt	-- Calculate end date as one day before the next start date   
		from bronze.crm_prod_info


		-- 3. Silver Layer - crm_sales_details

		-- Truncate Data 
		TRUNCATE TABLE silver.crm_sales_details;


		Insert INTO silver.crm_sales_details (
					sls_ord_num,
					sls_prd_key,
					sls_cust_id,
					sls_order_dt,
					sls_ship_dt,
					sls_due_dt,
					sls_sales,
					sls_quantity,
					sls_price
		)

		Select sls_ord_num,
			   sls_prd_key,
			   sls_cust_id,
			   Case When sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NUll
					Else CAST(CAST(sls_order_dt AS varchar) As DATE)
			   ENd AS sls_order_dt,
			   Case When sls_ship_dt = 0 OR LEN(sls_ship_dt) != 8 THEN NUll
					Else CAST(CAST(sls_ship_dt AS varchar) As DATE)
			   ENd AS sls_ship_dt,
			   Case When sls_due_dt = 0 OR LEN(sls_due_dt) != 8 THEN NUll
					Else CAST(CAST(sls_due_dt AS varchar) As DATE)
			   ENd AS sls_due_dt,
			   CASE WHEN sls_sales Is NULL or sls_sales <= 0 OR sls_sales != sls_quantity*ABS(sls_price)
					THEN sls_quantity * ABS(sls_price)
					ELSE sls_sales
			   END AS sls_sales,
			   sls_quantity,
			   CASE WHEN sls_price Is NULL or sls_price <= 0 
					THEN sls_sales/NULLIF(sls_quantity,0) 
					ELSE sls_price
			   END AS sls_price
		from bronze.crm_sales_details

		-- 4. Silver Layer - erp_cust_az12

		-- Truncate Data 
		TRUNCATE TABLE silver.erp_cust_az12;

		INSERT INTO silver.erp_cust_az12(
					cid,
					bdate,
					gen
		)

		Select 
		CASE when cid LIKE 'NAS%' THEN SUBSTRING(cid,4,len(cid))
			 else cid
		END as cid,
		CASE when bdate > GETDATE() THEN NULL
			 ELSE bdate
		END as bdate,
		CASE WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'FEMALE'
			 WHEN UPPER(TRIM(gen)) IN ('M','MALE') THEN 'MALE'
			 ELSE 'n/a'
		END AS gen
		from bronze.erp_cust_az12


		-- 5. Silver Layer - erp_cust_loc_a101

		-- Truncate Data 
		TRUNCATE TABLE silver.erp_loc_a101;

		INSERT INTO silver.erp_loc_a101(
					cid,
					cntry
		)

		SELECT 
		REPLACE (cid, '-','') as cid,
		Case WHEN UPPER(TRIM(cntry)) IN ('DE', 'GERMANY') THEN 'GERMANY'
			 WHEN LEN(UPPER(TRIM(cntry))) <=0 OR TRIM(cntry) IS NULL THEN 'n/a'
			 WHEN UPPER(TRIM(cntry)) IN ('US', 'UNITED STATES', 'USA') THEN 'USA'
			 ELSE UPPER(TRIM(cntry))
		END as cntry
		FROM bronze.erp_loc_a101

		-- 6. Silver Layer - erp_px_cat_g1v2

		-- Truncate Data 
		TRUNCATE TABLE silver.erp_px_cat_g1v2;

		INSERT INTO silver.erp_px_cat_g1v2(
					id,
					cat,
					subcat,
					maintenance
		)

		Select 
				id,
				cat,
				subcat,
				maintenance
		From bronze.erp_px_cat_g1v2

END