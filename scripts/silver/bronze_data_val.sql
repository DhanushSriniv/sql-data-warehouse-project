-- 1. Silver Layer
-- crm_cst_info

-- Check For Nulls or Dupliocates In Primary key
-- Expectation: No result

Select cst_id, count(*)
from bronze.crm_cust_info
Group by bronze.crm_cust_info.cst_id
Having count(*) > 1

-- Data Standardization & Consisitency
Select Distinct bronze.crm_cust_info.cst_gndr
from bronze.crm_cust_info

Select Distinct bronze.crm_cust_info.cst_marital_status
from bronze.crm_cust_info

--crm_prd_info

Select prd_key, COUNT(*)
from bronze.crm_prod_info
Group By prd_key
Having Count(*) > 1 or prd_key is nUll

-- Check for unwanted spaces
Select prd_nm
from bronze.crm_prod_info
where prd_nm !=  TRIM(prd_nm)

-- Check for quality and end date
Select *
from bronze.crm_prod_info
where prd_end_dt < prd_start_dt

-- Check for data quality on Silver crm prd
Select * from silver.crm_prd_info
where prd_end_dt < prd_start_dt


-- Silver Layer - Sales Details
Select sls_order_dt
from bronze.crm_sales_details

Use sqldatawarehouse

Select NullIf(sls_order_dt, 0) sls_order_dt
from bronze.crm_sales_details
where sls_order_dt >20150101

Select sls_sales as old_sales,
	   sls_quantity,
	   sls_price as old_price,
	   CASE WHEN sls_sales Is NULL or sls_sales <= 0 OR sls_sales != sls_quantity*ABS(sls_price)
			THEN sls_quantity * ABS(sls_price)
			ELSE sls_sales
	   END AS sls_sales,
	   CASE WHEN sls_price Is NULL or sls_price <= 0 
			THEN sls_sales/NULLIF(sls_quantity,0) 
			ELSE sls_price
	   END AS sls_price
FROM bronze.crm_sales_details
where sls_sales != sls_quantity * sls_price
OR sls_sales Is Null OR sls_quantity IS NULL OR sls_price Is Null
OR sls_sales <= 0 Or sls_quantity <= 0 OR sls_price <= 0
--Order By sls_sales, sls_quantity, sls_price


Select * from silver.crm_sales_details
Where sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt

-- Silver layer - erp_cust_az12
Select * from bronze.erp_cust_az12
Select * from bronze.crm_cust_info
Select * from bronze.erp_loc_a101

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

Select Distinct gen
from silver.erp_cust_az12

Select *
from silver.erp_cust_az12
where bdate <= '1924-01-01' OR bdate >= GETDATE()

-- SILVER LAYER - erp_loc_a101
Select *
from bronze.erp_loc_a101

Select Distinct cntry
from bronze.erp_loc_a101

SELECT 
REPLACE (cid, '-','') as cid,
Case WHEN UPPER(TRIM(cntry)) IN ('DE', 'GERMANY') THEN 'GERMANY'
	 WHEN LEN(UPPER(TRIM(cntry))) <=0 OR TRIM(cntry) IS NULL THEN 'n/a'
	 WHEN UPPER(TRIM(cntry)) IN ('US', 'UNITED STATES', 'USA') THEN 'USA'
	 ELSE UPPER(TRIM(cntry))
END as cntry
FROM bronze.erp_loc_a101

Select Distinct 
Case WHEN UPPER(TRIM(cntry)) IN ('DE', 'GERMANY') THEN 'GERMANY'
	 WHEN LEN(UPPER(TRIM(cntry))) <=0 OR TRIM(cntry) IS NULL THEN 'n/a'
	 WHEN UPPER(TRIM(cntry)) IN ('US', 'UNITED STATES', 'USA') THEN 'USA'
	 ELSE UPPER(TRIM(cntry))
END as cntry
FROM bronze.erp_loc_a101

Select * from silver.erp_loc_a101

-- 6. Silver Layer - erp_px_cat_g1v2

Select 
		id,
		cat,
		subcat,
		maintenance
From bronze.erp_px_cat_g1v2

select * from bronze.erp_px_cat_g1v2
Select * from silver.crm_prd_info

Select * from silver.crm_prd_info
Where cat_id Not IN (Select id from bronze.erp_px_cat_g1v2)

Select Distinct(maintenance) 
from bronze.erp_px_cat_g1v2


Select Count(*) from silver.crm_cust_info
Select Count(*) from silver.crm_prd_info
Select Count(*) from silver.crm_sales_details
Select Count(*) from silver.erp_cust_az12
Select Count(*) from silver.erp_loc_a101
Select Count(*) from silver.erp_px_cat_g1v2
