-- You need to create a report on whether customers who purchased the product named 
-- '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD' buy the products below or not.


--1. 'Polk Audio - 50 W Woofer - Black' -- (first_product)
--2. 'SB-2000 12 500W Subwoofer (Piano Gloss Black)' -- (second_product)
--3. 'Virtually Invisible 891 In-Wall Speakers (Pair)' -- (third_product)

SELECT sc.customer_id, sc.first_name, sc.last_name, pp.product_name
INTO #main_table
FROM sale.orders so
JOIN sale.customer sc
ON so.customer_id = sc.customer_id
JOIN sale.order_item soý
ON soý.order_id = so.order_id
JOIN product.product pp
ON pp.product_id = soý.product_id

select  * from #main_table


SELECT DISTINCT * 
INTO #table_hdd
FROM #main_table
WHERE product_name = '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD'

-- SELECT * FROM #table_hdd 

SELECT DISTINCT * 
INTO #table_woofer
FROM #main_table
WHERE product_name = 'Polk Audio - 50 W Woofer - Black'

-- SELECT * FROM #table_woofer

SELECT DISTINCT * 
INTO #table_subwoofer
FROM #main_table
WHERE product_name = 'SB-2000 12 500W Subwoofer (Piano Gloss Black)'

-- SELECT * FROM #table_subwoofer

SELECT DISTINCT * 
INTO #table_speaker
FROM #main_table
WHERE product_name = 'Virtually Invisible 891 In-Wall Speakers (Pair)'

-- SELECT * FROM #table_speaker


SELECT hdd.*, woofer.product_name first_, subwoofer.product_name second_, speaker.product_name third
INTO #last_table
FROM #table_hdd hdd
LEFT JOIN #table_woofer woofer
ON hdd.customer_id = woofer.customer_id
LEFT JOIN #table_subwoofer subwoofer
ON hdd.customer_id = subwoofer.customer_id
LEFT JOIN #table_speaker speaker
ON hdd.customer_id = speaker.customer_id

-- SELECT * FROM #last_table


SELECT customer_id, first_name, last_name, product_name, 
		REPLACE(ISNULL(first_, 'No'), 'Polk Audio - 50 W Woofer - Black', 'Yes') First_product,
		REPLACE(ISNULL(second_, 'No'), 'SB-2000 12 500W Subwoofer (Piano Gloss Black)', 'Yes' ) Second_product,
		REPLACE(ISNULL(third, 'No'), 'Virtually Invisible 891 In-Wall Speakers (Pair)', 'Yes') Third_product
FROM #last_table



