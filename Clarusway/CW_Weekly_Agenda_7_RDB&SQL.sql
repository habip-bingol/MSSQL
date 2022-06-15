---- RDB&SQL Exercise-2 

----1. By using view get the average sales by staffs and years using the AVG() aggregate function.

SELECT staff_id, YEAR(order_date), COUNT(*) AS count_of_sale
FROM sale.orders
GROUP BY staff_id, YEAR(order_date)
ORDER BY 1,2

CREATE VIEW sales AS (
	SELECT so.staff_id, ss.first_name, ss.last_name, 
	YEAR(order_date) year_, 
	CAST (AVG(soý.quantity* list_price *(1-soý.discount) ) AS NUMERIC (10,2) ) avg_
	FROM sale.orders so, sale.order_item soý,sale.staff ss
	WHERE so.order_id = soý.order_id and
		  ss.staff_id = so.staff_id 
	GROUP BY so.staff_id, ss.first_name, ss.last_name, YEAR(order_date)
)
SELECT * 
FROM sales
ORDER BY 1,3

----2. Select the annual amount of product produced according to brands (use window functions).

SELECT pb.brand_name, pb.brand_id, pp.model_year, COUNT(product_id) count_of_product
FROM product.product pp, product.brand pb
WHERE pp.brand_id = pb.brand_id 
GROUP BY pb.brand_name, pb.brand_id, pp.model_year


SELECT distinct pb.brand_name, pp.model_year, 
		COUNT(pp.product_id) OVER (PARTITION BY pb.brand_name, pp.model_year) AS annual_amount
FROM product.product pp, product.brand pb
WHERE pp.brand_id = pb.brand_id
ORDER BY 1


----3. Select the least 3 products in stock according to stores.

with cte AS(
SELECT *, ROW_NUMBER() OVER(PARTITION BY store_id order by quantity) as 'row_number'
FROM product.stock
WHERE quantity != 0
)
SELECT *
FROM cte
WHERE row_number <=3


----4. Return the average number of sales orders in 2020 sales

SELECT AVG(NumOfOrders)
FROM(SELECT O1.order_id, COUNT(O1.order_id) AS NumOfOrders
	 FROM sale.order_item AS O1 
		  JOIN sale.orders AS O2 ON O1.order_id=O2.order_id 
		  AND YEAR(order_date)=2020 
		  GROUP BY O1.order_id) AS SUBQ;

----5. Assign a rank to each product by list price in each brand and get products with rank less than or equal to three.

-- with dense_rank
SELECT * 
FROM(SELECT *, DENSE_RANK() OVER (PARTITION BY brand_id ORDER BY list_price) AS [rank] 
	 FROM product.product) AS SUBQ1
WHERE [rank] <= 3; 


-- with rank
SELECT * 
FROM(SELECT *, RANK() OVER (PARTITION BY brand_id ORDER BY list_price) AS [rank] 
	 FROM product.product) AS SUBQ1
WHERE [rank] <= 3;