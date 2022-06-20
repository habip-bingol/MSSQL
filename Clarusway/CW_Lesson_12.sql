
      ---- INDEXES ---

--önce tablonun çatýsýný oluþturuyoruz.


create table website_visitor 
(
visitor_id int,
ad varchar(50),
soyad varchar(50),
phone_number bigint,
city varchar(50)
);


DECLARE @i int = 1
DECLARE @RAND AS INT
WHILE @i<200000
BEGIN
	SET @RAND = RAND()*81
	INSERT website_visitor
		SELECT @i , 'visitor_name' + cast (@i as varchar(20)), 'visitor_surname' + cast (@i as varchar(20)),
		5326559632 + @i, 'city' + cast(@RAND as varchar(2))
	SET @i +=1
END


SELECT TOP 10 *
FROM website_visitor

--Ýstatistikleri (Process ve time) açýyoruz, bunu açmak zorunda deðilsiniz sadece yapýlan iþlemlerin detayýný görmek için açtýk.
SET STATISTICS IO on
SET STATISTICS TIME on

--herhangi bir index olmadan visitor_id' ye þart verip tüm tabloyu çaðýrýyoruz


SELECT *
FROM website_visitor
WHERE visitor_id = 100

Create CLUSTERED INDEX CLS_INX_1 ON website_visitor (visitor_id)

-- controlled execution plan
SELECT *
FROM website_visitor
WHERE visitor_id = 100

SELECT ad
FROM website_visitor
where ad = 'visitor_name17'

CREATE NONCLUSTERED INDEX ix_NoN_CLS_1 ON website_visitor (ad)

-- controlled execution plan
SELECT ad
FROM website_visitor
where ad = 'visitor_name17'


SELECT ad, soyad
FROM website_visitor
where ad = 'visitor_name17'


CREATE UNIQUE NONCLUSTERED INDEX ix_NoN_CLS_2 ON website_visitor (ad) include (soyad)

-- controlled execution plan
SELECT ad, soyad
FROM website_visitor
where ad = 'visitor_name17'

---- Clustered index(visitor_id)
---- Nonclustered index (ad)
---- Nonclustered index (ad) include (soyad)

-- 
SELECT soyad
FROM website_visitor
WHERE soyad = 'visitor_surname17'