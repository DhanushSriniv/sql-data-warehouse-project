-- Silver Layer - crm_cust_info
Insert INTO silver.crm_cust_info(
	cst_id,
	cst_key,
	cst_firstname,
	cst_lastname,
	cst_marital_status,
	cst_gndr,
	cst_create_date
)
-- 1. Handling Null Values in the cst_id, using rank method -  row number ()
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
