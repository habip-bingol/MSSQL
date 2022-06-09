               --- SET OPERATIONS ----


-- UNION and UNION ALL

-- Charlotte þehrindeki müþteriler ile Aurora þehrindeki müþterilerin soyisimlerini listeleyin

SELECT  last_name
FROM sale.customer
WHERE city = 'Charlotte'
UNION ALL
SELECT  last_name
FROM sale.customer
WHERE city = 'Aurora'

-- Çalýþanlarýn ve müþterilerin eposta adreslerinin unique olacak þekilde listeleyiniz.

SELECT email
FROM sale.customer
UNION
SELECT email
FROM sale.staff

-- Adý Thomas olan ya da soyadý Thomas olan müþterilerin isim soyisimlerini listeleyiniz.
SELECT first_name, last_name
FROM sale.customer
WHERE first_name = 'Thomas'
UNION ALL
SELECT first_name, last_name
FROM sale.customer
WHERE last_name = 'Thomas'


--- INTERSECT

-- Write a query that returns brands that have products for both 2018 and 2019.

SELECT  pp.brand_id, pb.brand_name
FROM product.product pp, product.brand pb
WHERE pp.brand_id = pb.brand_id and 
	  pp.model_year = 2018
INTERSECT
SELECT  pp.brand_id, pb.brand_name
FROM product.product pp, product.brand pb
WHERE pp.brand_id = pb.brand_id and 
	  pp.model_year = 2019

-- Wrire a query that returns customers who have orders for all of 2018, 2019 and 2020
SELECT first_name, last_name
FROM sale.customer sc, sale.orders so
WHERE sc.customer_id = so.customer_id and
	  YEAR (so.order_date) = 2018
INTERSECT
SELECT first_name, last_name
FROM sale.customer sc, sale.orders so
WHERE sc.customer_id = so.customer_id and
	  YEAR (so.order_date) = 2019
INTERSECT
SELECT first_name, last_name 
FROM sale.customer sc, sale.orders so
WHERE sc.customer_id = so.customer_id and
	  YEAR (so.order_date) = 2020

select	*
from
	(
	select	A.first_name, A.last_name, B.customer_id
	from	sale.customer A , sale.orders B
	where	A.customer_id = B.customer_id and
			YEAR(B.order_date) = 2018
	INTERSECT
	select	A.first_name, A.last_name, B.customer_id
	from	sale.customer A, sale.orders B
	where	A.customer_id = B.customer_id and
			YEAR(B.order_date) = 2019
	INTERSECT
	select	A.first_name, A.last_name, B.customer_id
	from	sale.customer A , sale.orders B
	where	A.customer_id = B.customer_id and
			YEAR(B.order_date) = 2020
	) A, sale.orders B
where	a.customer_id = b.customer_id and Year(b.order_date) in (2018, 2019, 2020)
order by a.customer_id, b.order_date


-- Charlotte ve Aurora þehrinde ayný soyisme sahip olan kiþileri bulunuz
SELECT  last_name
FROM sale.customer
WHERE city = 'Charlotte'
INTERSECT
SELECT  last_name
FROM sale.customer
WHERE city = 'Aurora'


--- EXCEPT  

-- Write a query that returns brands that have a 2018 model product but not a 2019 model product.

SELECT pp.brand_id, pb.brand_name
FROM product.product pp, product.brand pb
WHERE pp.brand_id = pb.brand_id and
	  model_year = 2018
EXCEPT
SELECT pp.brand_id, pb.brand_name
FROM product.product pp, product.brand pb
WHERE pp.brand_id = pb.brand_id and
	  model_year = 2019

--Sadece 2019 yýlýnda sipariþ verilen diðer yýllarda sipariþ verilmeyen ürünleri getiriniz.

SELECT A.product_id, B.product_name
FROM ( 
	SELECT soý.product_id
	FROM sale.orders so, sale.order_item soý
	WHERE  so.order_id = soý.order_id and
		  YEAR (so.order_date) = 2019
	EXCEPT
	SELECT soý.product_id
	FROM sale.orders so, sale.order_item soý
	WHERE  so.order_id = soý.order_id and
		  YEAR (so.order_date) <> 2019
) A, product.product B
WHERE A.product_id = B.product_id

-- plus
SELECT P.product_name
FROM product.product P, sale.orders O, sale.order_item OI 
WHERE P.product_id = OI.product_id AND O.order_id = OI.order_id AND YEAR(O.order_date) = 2019
EXCEPT 
SELECT P.product_name
FROM product.product P, sale.orders O, sale.order_item OI 
WHERE P.product_id = OI.product_id AND O.order_id = OI.order_id AND YEAR(O.order_date) <> 2019 

-- plus
SELECT *
FROM
			(
			SELECT P.product_name, P.product_id, YEAR(O.order_date) as order_year
			FROM product.product P, sale.orders O, sale.order_item OI 
			WHERE P.product_id = OI.product_id AND O.order_id = OI.order_id
			) A
PIVOT
(
	count(product_id)
	FOR order_year IN
	(
	[2018], [2019], [2020], [2021]
	)
) AS PIVOT_TABLE


-- plus
select	B.product_id, C.product_name
	from	sale.orders A, sale.order_item B, product.product C
	where	Year(A.order_date) = 2019 AND
			A.order_id = B.order_id AND
			B.product_id = C.product_id
	except
	select	B.product_id, C.product_name
	from	sale.orders A, sale.order_item B, product.product C
	where	Year(A.order_date) <> 2019 AND
			A.order_id = B.order_id AND
			B.product_id = C.product_id


-- 5 marka
select	brand_id, brand_name
from	product.brand
except
select	*
from	(
		select	A.brand_id, B.brand_name
		from	product.product A, product.brand B
		where	a.brand_id = b.brand_id and
				a.model_year = 2018
		INTERSECT
		select	A.brand_id, B.brand_name
		from	product.product A, product.brand B
		where	a.brand_id = b.brand_id and
				a.model_year = 2019
		) A


SELECT *
FROM
			(
			SELECT	b.product_id, year(a.order_date) OrderYear, B.item_id
			FROM	SALE.orders A, sale.order_item B
			where	A.order_id = B.order_id
			) A
PIVOT
(
	count(item_id)
	FOR OrderYear IN
	(
	[2018], [2019], [2020], [2021]
	)
) AS PIVOT_TABLE
order by 1



-- CASE EXPRESSION

-- Simple Case

SELECT order_id, order_status,
		CASE order_status
			WHEN 1 THEN 'Pending'
			WHEN 2 THEN 'Processing'
			WHEN 3 THEN 'Rejected'
			WHEN 4 THEN 'Completed'
		END order_status_desc
FROM sale.orders


SELECT first_name, last_name, store_id, 
		CASE store_id
			WHEN 1 THEN 'Davi techno Retail'
			WHEN 2 THEN 'The BFLO Store'
			WHEN 3 THEN 'Burkes Outlet'
		END store_name
FROM sale.staff


-- Searched Case

SELECT order_id, order_status,
		CASE 
			WHEN order_status = 1 THEN 'Pending'
			WHEN order_status = 2 THEN 'Processing'
			WHEN order_status = 3 THEN 'Rejected'
			WHEN order_status = 4 THEN 'Completed'
			ELSE 'Other'
		END order_status_desc
FROM sale.orders


--MüþterilERÝN e-mail adreslerindeki servis saðlayýcýlarýný yeni bir sütun oluþturarak belirtiniz.
SELECT first_name, last_name, email,
		CASE 
			WHEN email LIKE '%gmail%' THEN 'Gmail'
			WHEN email LIKE '%Hotmail%' THEN 'Hotmail'
			WHEN email LIKE '%Yahoo%' THEN 'Yahoo'
			ELSE 'Others'
		END email_service_provider

FROM sale.customer

-- Ayný sipariþte hem mp4 player, hem Computer Accessories hem de Speakers kategorilerinde ürün sipariþ veren müþterileri bulunuz


select	C.first_name, C.last_name
from	(
		select	c.order_id, count(distinct a.category_id) uniqueCategory
		from	product.category A, product.product B, sale.order_item C
		where	A.category_name in ('Computer Accessories', 'Speakers', 'mp4 player') AND
				A.category_id = B.category_id AND
				B.product_id = C.product_id
		group by C.order_id
		having	count(distinct a.category_id) = 3
		) A, sale.orders B, sale.customer C
where	A.order_id = B.order_id AND
		B.customer_id = C.customer_id


SELECT soý.order_id, pc.category_id, pc.category_name,
FROM product.product pp
JOIN sale.order_item soý
ON pp.product_id = soý.product_id
JOIN product.category pc
ON pp.category_id = pc.category_id

