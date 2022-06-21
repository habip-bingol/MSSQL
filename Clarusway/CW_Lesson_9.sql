            ----- WÝNDOW FUNCTIONS-----

-- Write a query that returns stock amounts of products (only stock table)

SELECT product_id, SUM(quantity) total_stock
FROM product.stock
GROUP BY product_id
ORDER BY product_id

-- with WF
SELECT distinct product_id, 
	   SUM(quantity) over (partition by product_id) sumWF
FROM product.stock
ORDER BY product_id

-- Markalara göre ortalama ürün fiyatlarýný hem Group By hem de Window Functions ile hesaplayýnýz.

SELECT pb.brand_id, AVG(list_price)
FROM product.product pp, product.brand pb
WHERE pp.brand_id = pb.brand_id
GROUP BY pb.brand_id

-- with WF
SELECT distinct pb.brand_id, AVG(list_price) over(partition by pb.brand_id) avg_price
FROM product.product pp, product.brand pb
WHERE pp.brand_id = pb.brand_id


 ----------------------------------------------------------------
 ----------------------------------------------------------------

SELECT	*,
		count(*) over(partition by brand_id) CountOfProduct,
		max(list_price) over(partition by brand_id) MaxListPrice
FROM	product.product
ORDER BY  brand_id, product_id


SELECT product_id, brand_id, category_id, model_year,
	   count(*) over (partition by brand_id) countOfProductinBrand,
	   count(*) over (partition by category_id) countOfProductinCategory
FROM product.product
ORDER BY brand_id, category_id, model_year

----------------------------------------------------------------
----------------------------------------------------------------

-- Window Frames

-- Windows frame i anlamak için birkaç örnek:
-- Herbir satýrda iþlem yapýlacak olan frame in büyüklüðünü (satýr sayýsýný) tespit edip window frame in nasýl oluþtuðunu aþaðýdaki sorgu sonucuna göre konuþalým.


SELECT	category_id, product_id,
		COUNT(*) OVER() NOTHING,  
		COUNT(*) OVER(PARTITION BY category_id) countofprod_by_cat,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id) countofprod_by_cat_2,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) prev_with_current,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) current_with_following,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) whole_rows,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) specified_columns_1,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN 2 PRECEDING AND 3 FOLLOWING) specified_columns_2
FROM	product.product
ORDER BY category_id, product_id


-- Cheapest product price in each category

SELECT DISTINCT category_id, MIN(list_price) over(partition by category_id)
FROM product.product


-- How many different product in the product table?(use WF)

SELECT  distinct count(*) over() as num_of_product
FROM product.product


-- How many different product in the order_item  table?


SELECT COUNT(distinct product_id) UniqueProduct
FROM sale.order_item


-- Use of DISTINCT is not allowed with the OVER clause.
SELECT	count(distinct product_id) over() UniqueProduct
FROM	sale.order_item


SELECT distinct count(*) over()
FROM (select distinct product_id,  count(*) over(partition by product_id) as number_of_product
FROM sale.order_item) as a


-- Write a query that returns how many different products are in each order?

SELECT	order_id, COUNT( product_id) UniqueProduct,
		SUM(quantity) TotalProduct
FROM	sale.order_item
GROUP BY order_id


SELECT distinct order_id, 
		COUNT( product_id) over (partition by order_id) UniqueProduct,
		SUM(quantity) over(partition by order_id) count_of_product
FROM sale.order_item

-- How many different product are in each brand in each category?

SELECT distinct category_id, brand_id,
		count(*) over (partition by brand_id, category_id) count_of_product
FROM product.product

select	A.*, B.brand_name
from	(
		select	distinct category_id, brand_id,
				count(*) over(partition by brand_id, category_id) CountOfProduct
		from	product.product
		) A, product.brand B
where	A.brand_id = B.brand_id

select	distinct category_id, A.brand_id,
		count(*) over(partition by A.brand_id, A.category_id) CountOfProduct,
		B.brand_name
from	product.product A, product.brand B
where	A.brand_id = B.brand_id
