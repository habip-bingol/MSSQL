
-- TRIM FUNCTION
SELECT TRIM(' CHARACTER')

SELECT GETDATE()

SELECT TRIM('   CHARACTER     ')

SELECT TRIM('X' FROM 'ABCXDE')

SELECT TRIM('X' FROM 'XXXXXXABCXDEXXXXX')

SELECT TRIM('x' FROM 'XXXXXXABCXDEXXXXX') -- case insensitive

-- LTRIM and RTRIM

SELECT LTRIM('    CHARACTER     ')

SELECT RTRIM('     CHARACTER  ')


-- REPLACE FUNCTION

SELECT REPLACE('CHARACTER STRING', ' ', '/' )

SELECT REPLACE('CHARACTER STRING', 'CHARACTER STRING', 'CHARACTER')

-- STR FUNCTIONS

SELECT STR (5454)

SELECT len(STR (5454)) -- default 10 character

SELECT STR(2135454654)

SELECT STR (133215.654645, 12, 3)


--CAST and CONVERT FUNCTIONS

SELECT CAST (12345 AS CHAR)

SELECT CAST (123.65 AS INT)

SELECT CONVERT(int, 30.60)

SELECT CONVERT (VARCHAR(10), '2020-10-10')

SELECT CONVERT (DATETIME, '2020-10-10' )

SELECT CONVERT (NVARCHAR, GETDATE(),112 )

SELECT CAST ('20201010' AS DATE)

SELECT CONVERT (NVARCHAR, CAST ('20201010' AS DATE),103 )


-- COALESCE FUNCTIONS

SELECT COALESCE (NULL, 'Hi', 'Hello', NULL)

-- NULLIF

SELECT NULLIF (10,10)

SELECT NULLIF (10,9)

SELECT NULLIF ('Hello', 'Hello')


-- ROUND FUNCTIONS

SELECT ROUND(432.368,2)


-- ISNULL FUNCTIONS

SELECT ISNULL (NULL, 'ABC')

SELECT ISNULL ('', 'ABC')

-- ISNUMERIC FUNCTIONS

SELECT ISNUMERIC(123)

SELECT ISNUMERIC('123')

SELECT ISNUMERIC('ABC')


/* --------------------------------------------
-----------------------------------------------
-----------------------------------------------*/

-- JOINS

----INNER JOIN

SELECT A.product_id, A.product_name,
	   B.category_id, B.category_name
FROM product.product AS a
INNER JOIN product.category AS B
ON A.category_id = B.category_id

SELECT A.first_name, A.last_name,
	   B.store_name
FROM sale.staff AS A
INNER JOIN sale.store AS B
ON A.store_id = B.store_id


-----LEFT JOIN

SELECT A.product_id, A.product_name,
	   B.order_id
FROM product.product AS A
LEFT JOIN sale.order_item AS B
ON A.product_id = B.product_id
WHERE B.order_id is null


SELECT A.product_id, A.product_name,
	   B.store_id, B.product_id, B.quantity
FROM product.product AS A
LEFT JOIN product.stock AS B
ON A.product_id = B.product_id
WHERE A.product_id > 310

---- RIGHT JOIN 

SELECT	B.product_id, B.product_name, A.*
FROM	product.stock A
RIGHT JOIN product.product B
	ON	A.product_id = B.product_id
WHERE	B.product_id > 310


---- FULL OUTER JOIN

-- Ürünlerin stok miktarlarý ve sipariþ bilgilerini birlikte listeleyin
SELECT A.product_id, B.store_id, B.quantity, C.order_id, C.list_price
FROM product.product AS A
FULL OUTER JOIN product.stock AS B
ON A.product_id = B.product_id
FULL OUTER JOIN sale.order_item AS C
ON A.product_id = C.product_id
ORDER BY B.store_id

---	CROSS JOIN

--stock tablosunda olmayýp product tablosunda mevcut olan ürünlerin stock tablosuna tüm storelar için kayýt edilmesi gerekiyor. 
--stoðu olmadýðý için quantity leri 0 olmak zorunda
--Ve bir product id tüm store' larýn stockuna eklenmesi gerektiði için cross join yapmamýz gerekiyor.

SELECT	B.store_id, A.product_id, 0 quantity
FROM	product.product A
CROSS JOIN sale.store B
WHERE	A.product_id NOT IN (SELECT product_id FROM product.stock)
ORDER BY A.product_id, B.store_id