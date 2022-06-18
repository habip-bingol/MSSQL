
----- Analytic Numbering Functions ----

---- ROW_NUMBER()


--Assign an ordinal number to the product prices for each category in ascending order

SELECT product_id, category_id, list_price, 
		ROW_NUMBER() OVER(PARTITION BY category_id ORDER BY list_price ASC) Row_Num
FROM product.product
;


---- RANK() and DENSE_RANK() 

-- Ayný soruyu ayný fiyatlý ürünler ayný sýra numarasýný alacak þekilde yapýnýz (RANK fonksiyonunu kullanýnýz)
-- and
-- Lets try previous query again using DENSE_RANK() function.
SELECT product_id, category_id, list_price, 
		RANK() OVER(PARTITION BY category_id ORDER BY list_price ASC) [RANK],
		DENSE_RANK() OVER(PARTITION BY category_id ORDER BY list_price ASC) [DENSE_RANK]
FROM product.product




--Herbir model_yili içinde ürünlerin fiyat sýralamasýný yapýnýz (artan fiyata göre 1'den baþlayýp birer birer artacak)
-- row_number(), rank(), dense_rank()

SELECT product_id, model_year, list_price,
		ROW_NUMBER() OVER(PARTITION BY model_year ORDER BY list_price) [ROW_NUMBER],
		RANK() OVER(PARTITION BY model_year ORDER BY list_price ASC) [RANK],
		DENSE_RANK() OVER(PARTITION BY model_year ORDER BY list_price ASC) [DENSE_RANK]
FROM product.product


--- CUME_DIST
-- Write a query that returns the cumulative distribution of the list price in product table by brand.

SELECT brand_id, list_price, 
	  ROUND (CUME_DIST() OVER(PARTITION BY brand_id ORDER BY list_price), 3) [CUM_DIST]
FROM product.product
;


-- PERCENT_RANK() 
-- Write a query that returns the relative standing of  the list price in product table by brand.

SELECT brand_id, list_price, 
	  ROUND (PERCENT_RANK() OVER(PARTITION BY brand_id ORDER BY list_price), 3) [CUM_DIST]
FROM product.product


-- Yukarýdaki sorguda CumDist alanýný CUME_DIST fonksiyonunu kullanmadan hesaplayýnýz.

WITH tbl as(
		SELECT brand_id, list_price,
				COUNT(*) OVER (PARTITION BY brand_id) TotalProductInBrand,
				ROW_NUMBER() OVER (PARTITION BY brand_id ORDER BY list_price) Row_Num,
				RANK() OVER (PARTITION BY brand_id ORDER BY list_price) Rank_Num
		FROM product.product
)
SELECT *, 
		round (cast(Row_Num as float)/ TotalProductInBrand, 3) CumDistRowNum,  -- we can use cast function or
		round (1.0*Rank_Num / TotalProductInBrand, 3) CumDistRankNum           -- we can multiple with 1.0
FROM tbl


SELECT brand_id, list_price,
		COUNT(*) OVER (PARTITION BY brand_id) TotalProductInBrand,
		ROW_NUMBER() OVER (PARTITION BY brand_id ORDER BY list_price) Row_Num,
		RANK() OVER (PARTITION BY brand_id ORDER BY list_price) Rank_Num
FROM product.product
ORDER BY 1,2


--Write a query that returns both of the followings:
--The average product price of orders.
--Average net amount.

SELECT DISTINCT order_id, 
		AVG(list_price) OVER(PARTITION BY order_id) avg_price,
		AVG(list_price* quantity *(1-discount)) OVER() avg_net_amount
FROM sale.order_item


-- --List orders for which the average product price is higher than the average net amount.
SELECT DISTINCT order_id, 
		AVG(list_price) OVER(PARTITION BY order_id) avg_price,
		AVG(list_price* quantity *(1-discount)) OVER() avg_net_amount
FROM sale.order_item
WHERE list_price* quantity *(1-discount)        > (SELECT DISTINCT 
													AVG(list_price* quantity *(1-discount)) OVER() avg_net_amount
													FROM sale.order_item
								   )

WITH temp_table AS
(SELECT 
	DISTINCT order_id, 
	AVG(list_price) OVER(PARTITION BY order_id ) avg_price,
	AVG(list_price * quantity* (1-discount)) OVER() avg_net_amount
FROM 
	sale.order_item)

SELECT *
FROM temp_table
WHERE avg_price > avg_net_amount
ORDER BY avg_price

-- or 

select distinct order_id, a.Avg_price,a.Avg_net_amount
from (
		select *,
		avg(list_price*quantity*(1-discount))  over() Avg_net_amount,
		avg(list_price)  over(partition by order_id) Avg_price
		from [sale].[order_item]
		) A
where  a.Avg_price > a.Avg_net_amount
order by 2



--Calculate the stores' weekly cumulative number of orders for 2018
--maðazalarýn 2018 yýlýna ait haftalýk kümülatif sipariþ sayýlarýný hesaplayýnýz

SELECT DISTINCT ss.store_id, ss.store_name,  DATEPART( ISO_WEEK, so.order_date) week_of_year,
		count(*) OVER(PARTITION BY ss.store_id, DATEPART( ISO_WEEK, so.order_date)) week_orders,
		count(*) OVER(PARTITION BY ss.store_id ORDER BY DATEPART( ISO_WEEK, so.order_date)) cume_total_order
		
FROM sale.orders so, sale.store ss
WHERE  so.store_id = ss.store_id and
		YEAR(so.order_date) = 2018
ORDER BY 1,3
;

--Calculate 7-day moving average of the number of products sold between '2018-03-12' and '2018-04-12'.
--'2018-03-12' ve '2018-04-12' arasýnda satýlan ürün sayýsýnýn 7 günlük hareketli ortalamasýný hesaplayýn.

WITH tbl AS (
		SELECT so.order_date, SUM(soi.quantity) SumQuantity
		FROM sale.orders so, sale.order_item soi
		WHERE so.order_id =soi.order_id AND
			 so.order_date BETWEEN '2018-03-12' AND '2018-04-12'
		GROUP BY so.order_date
)
SELECT *, AVG(1.0*SumQuantity) OVER (ORDER BY order_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) sales_moving_average_7
FROM tbl
ORDER BY 1

-- pay attention the diffeences
with tbl as (
	select	B.order_date, sum(A.quantity) SumQuantity --A.order_id, A.product_id, A.quantity
	from	sale.order_item A, sale.orders B
	where	A.order_id = B.order_id
	group by B.order_date
)
select	*
from	(
	select	*,
		avg(SumQuantity*1.0) over(order by order_date rows between 6 preceding and current row) sales_moving_average_7
	from	tbl
) A
where	A.order_date between '2018-03-12' and '2018-04-12'
order by 1

