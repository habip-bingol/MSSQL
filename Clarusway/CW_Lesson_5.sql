--- VIEW ----

CREATE VIEW product_stock AS,
	SELECT	A.product_id, A.product_name, B.store_id, B.quantity
	FROM	product.product A
	LEFT JOIN product.stock B ON A.product_id = B.product_id
	WHERE	A.product_id > 310
;

select *
from dbo.product_stock

-- Ma�aza �al��anlar�n� �al��t�klar� ma�aza bilgileriyle birlikte listeleyin
-- �al��an ad�, soyad�, ma�aza adlar�n� se�in


CREATE VIEW StoreStaff AS
SELECT	A.first_name, A.last_name, B.store_name
FROM	sale.staff A
INNER JOIN sale.store B
	ON	A.store_id = B.store_id
;



---- ADVENCED GROUPING OPERATIONS ----

SELECT * 
FROM product.brand

SELECT count(*)
FROM product.brand


SELECT  brand_id, count(*)
FROM product.product
GROUP BY brand_id


-- Herbir kategorideki toplam �r�n say�s�n� yazd�r�n�z.

SELECT category_id, count(*) count_of_product
FROM product.product
GROUP BY category_id


select pp.[category_id],count(*) CountOfCategory
from [product].[product] pp
join [product].[category] pc 
on pp.[category_id] = pc.[category_id]
group by pp.[category_id]


---- HAVING CLAUSE -----

--- Model y�l� 2016 dan b�y�k olan �r�nlerin liste fiyatlar�n�n 
--- ortalamas�n�n 1000 den fazla oldu�u markalar� listeleyin.

SELECT b.brand_name, avg(p.list_price)
FROM product.product p, product.brand b
WHERE p.brand_id = b.brand_id
	  AND p.model_year > 2016
GROUP BY b.brand_name
HAVING avg(p.list_price) > 1000


--Write a query that checks if any product id is repeated 
--in more than one row in the product table.

SELECT product_id, count(product_id) num_of_rows
FROM product.product
GROUP BY product_id
HAVING count(product_id) > 1

--maximum list price' � 4000' in �zerinde olan veya minimum 
-- list price' � 500' �n alt�nda olan categori id' leri getiriniz

SELECT category_id, MAX(list_price) max_price, MIN(list_price) min_price
FROM product.product
GROUP BY category_id
HAVING MAX(list_price) >4000 OR MIN(list_price) < 500

--bir sipari�in toplam net tutar�n� getiriniz. (m��terinin sipari� i�in �dedi�i tutar)
--discount' � ve quantity' yi ihmal etmeyiniz.


SELECT order_id ,sum(quantity*list_price*(1-discount))
FROM sale.order_item
GROUP BY order_id


--- GROUPING SETS ---

-- Herbir kategorideki toplam �r�n say�s�
--Herbir model y�l�ndaki toplam �r�n say�s�
-- Herbir kategorinin model y�l�ndaki toplam �r�n say�s�s

SELECT  category_id, model_year, count(*) CountOfProducts
FROM product.product
GROUP BY 
	GROUPING SETS (
	
	(category_id),
	(model_year),
	(category_id, model_year)
)
ORDER BY 1,2

-- BONUS
SELECT  category_id, model_year, count(*) CountOfProducts
FROM product.product
GROUP BY 
	GROUPING SETS (
	(category_id),
	(model_year),
	(category_id, model_year)
)
HAVING model_year is NULL
ORDER BY 1,2



- -- ROLLUP ---

-- Herbir marka id, herbir category id ve herbir model y�l� 
--i�in toplam �r�n say�lar�n� getiriniz.
--Sonu� tablosunda t�m ihtimaller bulunsun.


SELECT category_id,  brand_id, model_year,count(*) cnt
FROM product.product
GROUP BY
	ROLLUP (category_id, brand_id, model_year)


SELECT category_id,  brand_id, model_year,count(*) cnt
FROM product.product
GROUP BY
	CUBE (category_id, brand_id, model_year)


--- PIVOT --- 