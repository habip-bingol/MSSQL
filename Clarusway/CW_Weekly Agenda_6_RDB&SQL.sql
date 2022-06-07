---- C-11 WEEKLY AGENDA-6 RD&SQL STUDENT

---- 1. List all the cities in the Texas and the numbers of customers in each city.----

SELECT  city, count(customer_id) as customer_number
FROM sale.customer
WHERE [state] = 'TX'
GROUP BY city

---- 2. List all the cities in the California which has more than 5 customer, by showing the cities which have more customers first.---
SELECT city, count(customer_id) as customer_number
FROM sale.customer
WHERE [state] = 'CA' 
GROUP BY city
HAVING count(customer_id) > 5
ORDER BY customer_number DESC


---- 3. List the top 10 most expensive products----

SELECT TOP 10 *
FROM product.product
ORDER BY list_price DESC

---- 4. List store_id, product name and list price and the quantity of the products which are located in the store id 2 and the quantity is greater than 25----

SELECT s.store_id, p.product_name, p.list_price, s.quantity
FROM product.product AS p
LEFT JOIN product.stock AS s
ON p.product_id = s.product_id
WHERE s.store_id = 2 and s.quantity > 25



---- 5. Find the sales order of the customers who lives in Boulder order by order date----

SELECT C.customer_id, O.order_id, O.order_status, O.order_date
FROM sale.customer AS C
INNER JOIN sale.orders O
ON C.customer_id = O.customer_id
WHERE C.city = 'Boulder'
ORDER BY O.order_date 


---- 6. Get the sales by staffs and years using the AVG() aggregate function.

-- as quantity

SELECT s.staff_id, YEAR(o.order_date)as date_ , count(o.order_id) as number_order
FROM sale.staff AS s
JOIN sale.orders AS o
ON s.staff_id = o.staff_id
GROUP BY s.staff_id, YEAR(o.order_date)
ORDER BY s.staff_id

SELECT  AVG(A.staff_id) AS avg_staff, DATEPART(YEAR, A.order_date) AS order_year, COUNT(B.quantity) AS avg_quantity
FROM sale.orders A
LEFT JOIN sale.order_item B
ON A.order_id = B.order_id
GROUP BY A.staff_id, DATEPART(YEAR, A.order_date)
ORDER BY A.staff_id, DATEPART(YEAR, A.order_date)

--- as Price
SELECT o.staff_id, DATEPART(YEAR, o.order_date) AS YEAR_, AVG((oý.list_price * oý.quantity)*(1-oý.discount)) AS sales
FROM sale.orders AS o
INNER JOIN sale.order_item AS oý
ON o.order_id = oý.order_id
GROUP BY o.staff_id, DATEPART(YEAR, o.order_date)
ORDER BY o.staff_id, DATEPART(YEAR, o.order_date)



---- 7. What is the sales quantity of product according to the brands and sort them highest-lowest----

SELECT b.brand_name, SUM(oý.quantity) SALES_QUANTITY
FROM product.brand AS b
INNER JOIN product.product AS p
ON b.brand_id = p.brand_id
INNER JOIN sale.order_item AS oý
ON p.product_id = oý.product_id
GROUP BY b.brand_name
ORDER BY SUM(oý.quantity) DESC


---- 8. What are the categories that each brand has?----

SELECT b.brand_name, c.category_name
FROM product.product AS p
JOIN product.brand AS b
ON p.brand_id = b.brand_id
JOIN product.category AS c
ON p.category_id = c.category_id
GROUP BY b.brand_name, c.category_name

---- 9. Select the avg prices according to brands and categories----

SELECT b.brand_name, c.category_name, AVG(p.list_price) avg_price
FROM product.product AS p
JOIN product.brand AS b
ON p.brand_id = b.brand_id
JOIN product.category AS c
ON p.category_id = c.category_id
GROUP BY b.brand_name, c.category_name


---- 10. Select the annual amount of product produced according to brands----
'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'
SELECT YEAR (p.model_year) AS YEAR_,  SUM (p.product_id) count_
FROM product.product AS p
JOIN product.brand AS b
ON p.brand_id = b.brand_id
GROUP BY YEAR (p.model_year)



---- 11. Select the store which has the most sales quantity in 2018.----

SELECT TOP 1 st.store_name, YEAR(o.order_date) AS YEAR_, SUM (oý.quantity) AS TOTAL_QUANTITY
FROM sale.orders AS o
JOIN sale.store AS st
ON o.store_id = st.store_id
JOIN sale.order_item AS oý
ON o.order_id = oý.order_id
WHERE YEAR (o.order_date) = '2018'
GROUP BY st.store_name, YEAR(o.order_date)
ORDER BY TOTAL_QUANTITY DESC


---- 12 Select the store which has the most sales amount in 2018.----

SELECT TOP 1 st.store_name, YEAR (o.order_date), SUM ((oý.quantity)*(oý.list_price*(1-oý.discount))) AS TOTAL_AMOUNT
FROM sale.orders AS o
JOIN sale.store AS st
ON o.store_id = st.store_id
JOIN sale.order_item AS oý
ON o.order_id = oý.order_id
WHERE YEAR (o.order_date) = '2018'
GROUP BY st.store_name, YEAR (o.order_date)
ORDER BY TOTAL_AMOUNT DESC


---- 13. Select the personnel which has the most sales amount in 2019.----

SELECT TOP 1 s.staff_id, s.first_name, s.last_name, YEAR (o.order_date), SUM ((oý.quantity)*(oý.list_price*(1-oý.discount))) AS TOTAL_AMOUNT
FROM sale.orders o
JOIN sale.order_item oý
ON o.order_id = oý.order_id
JOIN sale.staff s
ON s.staff_id = o.staff_id
GROUP BY s.staff_id, s.first_name, s.last_name, YEAR (o.order_date)
ORDER BY TOTAL_AMOUNT DESC

