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

