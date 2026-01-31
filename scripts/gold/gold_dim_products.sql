CREATE VIEW gold.dim_products AS

Select
	   ROW_NUMBER() OVER(Order By pn.prd_start_dt, pn.prd_key) as product_key,
	   pn.prd_id as product_id,
	   pn.prd_key as product_no,
	   pn.prd_nm as product_name,
	   pn.cat_id as category_id,
	   pc.cat as category,
	   pc.subcat as subcategory,
	   pn.prd_cost as cost,
	   pn.prd_line as product_line,
	   pn.prd_start_dt as product_start_date,
	   pc.maintenance
FROM silver.crm_prd_info pn
LEFT JOIN silver.erp_px_cat_g1v2 pc
ON pn.cat_id = pc.id
WHERE prd_end_dt IS NULL -- Filter only the current open data, leaving historical data