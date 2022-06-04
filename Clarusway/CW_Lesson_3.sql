
/*  
SELECT 
WHERE 
ORDER BY
TOP
*/


SELECT * 
FROM product.brand;

SELECT * 
FROM product.brand
ORDER BY brand_name;

SELECT * 
FROM product.brand
ORDER BY brand_name DESC;

SELECT TOP 10 *
FROM product.brand
ORDER BY brand_id DESC;


SELECT * 
FROM product.brand
WHERE brand_name LIKE 'S%';

SELECT * 
FROM product.product
ORDER BY brand_id;

SELECT * 
FROM product.product
WHERE model_year BETWEEN 2019 AND 2021;

SELECT TOP 1 *
FROM product.product
WHERE model_year BETWEEN 2019 AND 2021
ORDER BY model_year DESC;

SELECT *
FROM product.product
WHERE category_id IN (3,4,5);


SELECT *
FROM product.product
WHERE category_id NOT IN (3,4,5);

SELECT *
FROM product.product
WHERE category_id <> 3 AND category_id <> 4 AND category_id <> 5;


SELECT *
FROM product.stock

select *
from product.stock
where product_id in (select product_id
						from product.product
						where product_name like 'corsaýr - hyd%')


-- Functions

-- Date Functions

CREATE TABLE t_date_time(
	A_time time,
	A_date date,
	A_smalldatetime smalldatetime,
	A_datetime datetime,
	A_datetime2 datetime2,
	A_datetimeoffset datetimeoffset
	)

select * from t_date_time

SELECT GETDATE() as get_date 

INSERT t_date_time
VALUES (GETDATE(),GETDATE(),GETDATE(),GETDATE(),GETDATE(),GETDATE())


INSERT t_date_time (A_time, A_date, A_smalldatetime, A_datetime, A_datetime2, A_datetimeoffset)
VALUES
('12:00:00', '2021-07-17', '2021-07-17','2021-07-17', '2021-07-17', '2021-07-17' )


-- convert date to varchar

SELECT GETDATE();

SELECT CONVERT (VARCHAR(10), GETDATE(), 6);

-- VARCHAR TO DATE

SELECT CONVERT (DATE, '04 Jun 22', 6)

SELECT CONVERT (DATETIME, '04 Jun 22', 6)


-- DATE FUNCTÝONS

SELECT DAY(A_DATE) DAY_
		, MONTH(A_DATE) MONTH_

FROM t_date_time


SELECT A_DATE
		,DAY(A_DATE) DAY_
		,MONTH(A_DATE) MONTH_
		,DATENAME(DW, A_DATE)
FROM t_date_time


SELECT A_DATE
		,DAY(A_DATE) DAY_
		,MONTH(A_DATE) MONTH_
		,DATENAME(DAYOFYEAR, A_DATE) DOY
		,DATEPART(WEEKDAY, A_DATE) WKD
FROM t_date_time


SELECT A_DATE
		,DAY(A_DATE) DAY_
		,MONTH(A_DATE) MONTH_
		,DATENAME(DAYOFYEAR, A_DATE) DOY
		,DATEPART(WEEKDAY, A_DATE) WKD
		,DATENAME(MONTH, A_DATE) MON
FROM t_date_time



SELECT DATEDIFF(DAY, '2022-05-10', GETDATE()) DAY_

SELECT DATEDIFF(SECOND, '2022-05-10', GETDATE()) SECOND_


SELECT DATEADD(DAY,5,GETDATE());

SELECT DATEADD(MINUTE,5,GETDATE());

SELECT EOMONTH(GETDATE());

SELECT EOMONTH(GETDATE(), 2)


-- Teslimat tarihi ile sipariþ tarihi arasýndaki farký bul

SELECT * FROM sale.orders;

ELECT  DATEDIFF(DAY, order_date, shipped_date) Diff_of_day
FROM sale.orders

SELECT *, DATEDIFF(DAY, order_date, shipped_date) Diff_of_day
FROM sale.orders


SELECT *, DATEDIFF(DAY, order_date, shipped_date) Diff_of_day
FROM sale.orders
WHERE DATEDIFF(DAY, order_date, shipped_date) > 2


-- String Functions

-- LEN, CHARINDEX, PATINDEX

SELECT LEN('CHARACTER')

SELECT LEN(' CHARACTER') --included first gap

SELECT LEN(' CHARACTER ') -- excluded last gap


SELECT CHARINDEX('R', 'CHARACTER')

SELECT CHARINDEX('R', 'CHARACTER', 5) -- second 'R'

SELECT CHARINDEX('RA', 'CHARACTER')

SELECT CHARINDEX('RA', 'CHARACTER')-1


SELECT PATINDEX('%R', 'CHARACTER')


SELECT PATINDEX('%H%', 'CHARACTER')

SELECT PATINDEX('%A%', 'CHARACTER', 4)


-- LEFT, RIGHT , SUBSTRÝNG

SELECT LEFT('CHARACTER', 3)

SELECT RIGHT('CHARACTER', 3)

SELECT SUBSTRING('CHARACTER', 3,5) --  (start index, count_ character)

SELECT SUBSTRING('CHARACTER', 4, 9)


-- LOWER, UPPER, SPLIT

SELECT LOWER('CHARACTER')

SELECT UPPER('character')

SELECT * FROM STRING_SPLIT('JACK,MARTIN,ALAIN,OWEN', ',')


---- 'character' kelimesinin ilk harfini büyülten fonk yazýnýz.

SELECT UPPER (LEFT('CHARACTER', 1))


Select CONCAT(UPPER(SUBSTRING('character',1,1)),LOWER(SUBSTRING('character',2,9)))


select CONCAT(UPPER(SUBSTRING('character', 1, 1)), SUBSTRING('character', 2, len('character'))) 



SELECT UPPER(LEFT('character', 1)) + SUBSTRING('character', 2, 9) 


