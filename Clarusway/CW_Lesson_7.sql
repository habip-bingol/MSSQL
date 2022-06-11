           ----   SUBQUERÝES ---- 
-- SELECT ÝÇÝNDE 
SELECT order_id,
	   list_price,
	   (
	   SELECT AVG(list_price)
	    FROM sale.order_item
		) AS avg_price
FROM sale.order_item


--- WHERE ÝÇÝNDE 
SELECT	order_id, order_date
FROM	sale.orders
WHERE	order_date in (
					SELECT TOP 5 order_date
					FROM	sale.orders
					ORDER BY order_date DESC
					)

--- FROM ÝÇÝNDE 

SELECT	order_id, order_date
FROM	(
		SELECT	TOP 5 *
		FROM	sale.orders
		ORDER BY order_date DESC
		) A                     --- ALIAS OLMADAN ÇALIÞMAZ (SADECE FROM ÝÇÝN GEÇERLÝ)



		--- Single Row Subqueries

---  Write a query that returns the total list price by each order ids

SELECT order_id, SUM(list_price)
FROM sale.order_item
GROUP BY order_id

SELECT	so.order_id,
		(
		SELECT	sum(list_price)
		FROM	sale.order_item
		WHERE	order_id=so.order_id
		) AS total_price
FROM	sale.order_item so
GROUP BY so.order_id


---- Bring all the staff from the store that Davis Thomas

SELECT store_id
FROM sale.staff ss
WHERE first_name = 'Davis' and last_name = 'Thomas'

SELECT * 
FROM sale.staff
WHERE store_id = ( 
				  SELECT store_id
				  FROM sale.staff ss
				  WHERE first_name = 'Davis' and last_name = 'Thomas'
				  )

-- alternative 
select *
from (
    select store_id
    from sale.staff
    where first_name = 'Davis' and last_name= 'Thomas'
) as a, sale.staff b
where a.store_id = b.store_id


-- List the staff that Chaeles Cussona is the manager of

SELECT staff_id
FROM sale.staff
WHERE first_name = 'Charles' and last_name = 'Cussona'

SELECT	*
FROM	sale.staff
WHERE	manager_id = (
					SELECT	staff_id
					FROM	sale.staff
					WHERE	first_name = 'Charles' and last_name = 'Cussona'
					)

-- 'Pro-Series 49-Class Full HD Outdoor LED TV (Silver)' isimli üründen pahalý olan ürünleri listeleyin.
-- Product id, product name, model_year, fiyat, marka adý ve kategori adý alanlarýna ihtiyaç duyulmaktadýr.

SELECT list_price
FROM product.product
WHERE product_name = 'Pro-Series 49-Class Full HD Outdoor LED TV (Silver)'


SELECT pp.product_id, pp.product_name, pp.model_year, pp.list_price, pb.brand_name, pc.category_name
FROM product.product pp, product.brand pb, product.category pc
WHERE list_price > (SELECT list_price
					FROM product.product
					WHERE product_name = 'Pro-Series 49-Class Full HD Outdoor LED TV (Silver)'
					) and
					pp.brand_id = pb.brand_id and
					pp.category_id = pc.category_id



		  ---- Multiple Row Subqueries -----

--List all customers who orders on the same dates as Laurel Golddammer

SELECT order_date 
FROM sale.orders so, sale.customer SC
WHERE so.customer_id = sc.customer_id and
	  sc.first_name = 'Laurel' and last_name = 'Goldammer'

SELECT sc.customer_id, first_name, last_name, order_date
FROM sale.orders so, sale.customer SC
WHERE so.customer_id = sc.customer_id and
	  order_date in (SELECT order_date 
					FROM sale.orders so, sale.customer SC
					WHERE so.customer_id = sc.customer_id and
					sc.first_name = 'Laurel' and last_name = 'Goldammer'
					)

--- List products made in 2021 and their categories other than game, gps or home theater


SELECT *
FROM product.product pp, product.category pc
WHERE pp.category_id = pc.category_id and
	  pp.model_year = 2021 and
	  pp.category_id not in (select category_id
							 from product.category
							 where category_name in ('game', 'gps', 'home theater'))


-- 2020 model olup Receivers Amplifiers kategorisindeki en pahalý üründen daha pahalý ürünleri listeleyin.
-- Ürün adý, model_yýlý ve fiyat bilgilerini yüksek fiyattan düþük fiyata doðru sýralayýnýz.

SELECT MAX(pp.list_price)
FROM product.product pp, product.category pc
WHERE pp.category_id = pc.category_id anD
		category_name = 'Receivers Amplifiers'

SELECT pp.product_name, pp.model_year, pp.list_price
FROM product.product pp, product.category pc
WHERE pp.category_id = pc.category_id and
	 pp.model_year = 2020 and 
	 pp.list_price > (SELECT MAX(pp.list_price)
					  FROM product.product pp, product.category pc
					  WHERE pp.category_id = pc.category_id and
					  category_name = 'Receivers Amplifiers'
					  )

-- Alternative (ALL)
SELECT * 
FROM	product.product
WHERE	model_year = 2020 and
		list_price > ALL (
			SELECT	B.list_price
			FROM	product.category A, product.product B
			WHERE	A.category_name = 'Receivers Amplifiers' and
					A.category_id = B.category_id
			)

-- 2020 model olup Receivers Amplifiers kategorisindeki herhangi bir  üründen daha pahalý ürünleri listeleyin.

SELECT pp.product_name, pp.model_year, pp.list_price
FROM product.product pp, product.category pc
WHERE pp.category_id = pc.category_id and
	 pp.model_year = 2020 and 
	 pp.list_price > (SELECT MIN(pp.list_price)
					  FROM product.product pp, product.category pc
					  WHERE pp.category_id = pc.category_id anD
					  category_name = 'Receivers Amplifiers'
					  )

				
-- alternative (ANY)
SELECT * 
FROM	product.product
WHERE	model_year = 2020 and
		list_price > ANY (
			SELECT	B.list_price
			FROM	product.category A, product.product B
			WHERE	A.category_name = 'Receivers Amplifiers' and
					A.category_id = B.category_id
			)

