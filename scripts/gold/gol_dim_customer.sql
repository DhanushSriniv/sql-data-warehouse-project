USE [sqldatawarehouse]
GO

/****** Object:  View [gold].[dim_customer]    Script Date: 1/31/2026 2:35:05 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- Gold Layer

-- Creating Views

CREATE VIEW [gold].[dim_customer] AS
Select 
		ROW_NUMBER() OVER(ORDER BY cst_id) AS customer_key,
		ci.cst_id as customer_id,
		ci.cst_key as customer_number,
		ci.cst_firstname as first_name,
		ci.cst_lastname as last_name,
		loc.cntry as country,
		ci.cst_marital_status as marital_status,
		CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr  -- CRM is the master for gender info
			 ELSE COALESCE(ca.gen, 'n/a')
		END AS gender,
		ca.bdate as birth_date,
		ci.cst_create_date as create_date
From silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca 
ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 loc
ON ci.cst_key = loc.cid





GO

