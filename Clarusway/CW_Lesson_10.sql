 ---- Window Functions -----


 SELECT DISTINCT category_id, brand_id, 
		count(*) over(partition by category_id, brand_id) num_of_product
 FROM product.product

 --- Analitical Navigation Functions

-- First Value Function

-- Write a query that returns most stocked product in each store

SELECT *
FROM product.stock
ORDER BY store_id, quantity DESC


SELECT DISTINCT store_id, 
		FIRST_VALUE(product_id) OVER(PARTITION BY store_id ORDER BY quantity DESC) most_stocked_prod
FROM product.stock


--Write a query that returns customers and their most valuable order with total amount of it.

SELECT	customer_id, B.order_id, SUM(quantity * list_price* (1-discount)) net_price
FROM	sale.order_item A, sale.orders B
WHERE	A.order_id = B.order_id
GROUP BY customer_id, B.order_id
ORDER BY 1,3 DESC;


WITH T1 AS (
SELECT so.customer_id, soi.order_id,  SUM(soi.list_price *soi.quantity *(1-discount)) net_price
FROM sale.orders so, sale.order_item soi
WHERE so.order_id = soi.order_id
GROUP BY so.customer_id, soi.order_id
)
SELECT DISTINCT customer_id, 
	   FIRST_VALUE(order_id) OVER (PARTITION BY customer_id ORDER BY net_price DESC) most_valuable_order,
	   FIRST_VALUE(net_price) OVER (PARTITION BY customer_id ORDER BY net_price DESC) most_valuable_price
FROM T1


SELECT DISTINCT customer_id,
	  FIRST_VALUE(I.order_id) OVER (PARTITION BY customer_id ORDER BY list_price * quantity * (1 - discount) DESC) AS order_id,
	  FIRST_VALUE(list_price * quantity * (1 - discount))
	  OVER(PARTITION BY customer_id ORDER BY list_price * quantity * (1 - discount) DESC) AS total_amount
FROM sale.orders O, sale.order_item I
WHERE O.order_id = I.order_id



-- Write a query that returns first order date bt month


SELECT DISTINCT YEAR(order_date) YEAR_, MONTH(order_date) MONTH_,
		FIRST_VALUE(order_date) OVER (PARTITION BY YEAR(order_date), MONTH(order_date) ORDER BY order_date) first_order_date
FROM sale.orders


--- LAST_VALUE

-- Write a query that returns most stocked in each store


SELECT	DISTINCT store_id,
		LAST_VALUE(product_id) OVER (PARTITION BY store_id ORDER BY quantity ASC, product_id DESC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) most_stocked_prod
FROM	product.stock

-------

SELECT	DISTINCT store_id,
		LAST_VALUE(product_id) OVER (PARTITION BY store_id ORDER BY quantity ASC, product_id DESC RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) most_stocked_prod
FROM	product.stock



---  LAG() FUNCTION

--Write a query that returns the order date of the one previous sale of each staff(use the LAG function).

SELECT DISTINCT so.order_id, ss.staff_id, ss.first_name, ss.last_name, so.order_date,
		LAG(order_date) OVER (PARTITION BY ss.staff_id ORDER BY order_date) previous_order_date
FROM sale.orders so, sale.staff ss
WHERE so.staff_id = ss.staff_id

