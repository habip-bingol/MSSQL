-- Discount Effects

-- Generate a report including product IDs and discount effects on whether the increase 
-- in the discount rate positively impacts the number of orders for the products.

-- In this assignment, you are expected to generate a solution using SQL with a logical approach. 

-- Product_id	Discount Effect
--		1			Positive
--		2			Negative
--		3			Negative
--		4			Neutral

SELECT DISTINCT product_id, discount, SUM(quantity) total_sale
FROM SALE.order_item
GROUP BY product_id, discount
ORDER BY 1,2


with tbl as
(
SELECT DISTINCT product_id, discount, 
		SUM(quantity) OVER(PARTITION BY  product_id, discount ) total_sale
FROM SALE.order_item

)
SELECT product_id, discount, total_sale,
	   FIRST_VALUE(total_sale) OVER (PARTITION BY product_id ORDER BY product_id, discount) sale_low_disc,
	   FIRST_VALUE(total_sale) OVER (PARTITION BY product_id ORDER BY product_id, discount DESC) sale_high_disc_
INTO #table_1
FROM tbl

SELECT * 
FROM #table_1

SELECT *,
	CASE 
			WHEN sale_low_disc < sale_high_disc_ THEN 'Positive'
			WHEN sale_low_disc > sale_high_disc_ THEN 'Negative'
			WHEN sale_low_disc = sale_high_disc_ THEN 'Neutral'
			END AS Discount_Effect
INTO #table_2
FROM #table_1

SELECT distinct product_id, discount_Effect
FROM #table_2

SELECT DISTINCT A.product_id, B.Discount_Effect
FROM product.product A
LEFT JOIN #table_2 B
ON A.product_id = B.product_id
ORDER BY 1


