CREATE VIEW gold.fact_sales AS

SELECT 
	  sd.sls_ord_num As order_number,
	  pr.product_key,
	  cu.customer_id,
	  sd.sls_order_dt as order_date,
	  sd.sls_ship_dt as shipping_date,
	  sd.sls_due_dt as delivery_due_date,
	  sd.sls_price as price,
	  sd.sls_sales as sales_amount,
	  sd.sls_quantity as sales_quantity

FROM silver.crm_sales_details sd
LEFT JOIN gold.dim_products pr
ON sd.sls_prd_key = pr.product_no
LEFT JOIN gold.dim_customer cu
ON sd.sls_cust_id = cu.customer_id