
    -----PROCEDURES----

CREATE PROCEDURE sp_sampleproc1 AS
BEGIN
SELECT 'Hello World!'
END

EXEC sp_sampleproc1


DROP PROCEDURE sp_sampleproc1


-- created again to alter
CREATE PROCEDURE sp_sampleproc1 AS
BEGIN
SELECT 'Hello World!'
END

ALTER PROCEDURE sp_sampleproc1 AS
BEGIN 
SELECT 'Hello World!2'
END

EXEC sp_sampleproc1


CREATE TABLE ORDER_TBL 
(
ORDER_ID TINYINT NOT NULL,
CUSTOMER_ID TINYINT NOT NULL,
CUSTOMER_NAME VARCHAR(50),
ORDER_DATE DATE,
EST_DELIVERY_DATE DATE--estimated delivery date
);


INSERT INTO ORDER_TBL VALUES (1, 1, 'Adam', GETDATE()-10, GETDATE()-5 ),
						(2, 2, 'Smith',GETDATE()-8, GETDATE()-4 ),
						(3, 3, 'John',GETDATE()-5, GETDATE()-2 ),
						(4, 4, 'Jack',GETDATE()-3, GETDATE()+1 ),
						(5, 5, 'Owen',GETDATE()-2, GETDATE()+3 ),
						(6, 6, 'Mike',GETDATE(), GETDATE()+5 ),
						(7, 6, 'Rafael',GETDATE(), GETDATE()+5 ),
						(8, 7, 'Johnson',GETDATE(), GETDATE()+5 )


SELECT *
FROM ORDER_TBL

CREATE TABLE ORDER_DELIVERY
(
ORDER_ID TINYINT NOT NULL,
DELIVERY_DATE DATE -- tamamlanan delivery date
);



SET NOCOUNT ON
INSERT ORDER_DELIVERY VALUES (1, GETDATE()-6 ),
				(2, GETDATE()-2 ),
				(3, GETDATE()-2 ),
				(4, GETDATE() ),
				(5, GETDATE()+2 ),
				(6, GETDATE()+3 ),
				(7, GETDATE()+5 ),
				(8, GETDATE()+5 )

SELECT *
FROM ORDER_DELIVERY


CREATE PROCEDURE sp_sum_order AS

BEGIN 
	SELECT COUNT(*)
	FROM ORDER_TBL
END


EXECUTE sp_sum_order;


CREATE PROCEDURE sp_wantedday_order 
	(
	@DAY DATE
	)
AS

BEGIN 
	SELECT COUNT(*) TOTAL_ORDER
	FROM ORDER_TBL
	WHERE ORDER_DATE = @DAY 
END


EXECUTE sp_wantedday_order '2022-06-22';


DECLARE 
	@p1 INT,
	@p2 INT,
	@SUM INT

SET @p1 = 5


SELECT * 
FROM ORDER_TBL
WHERE ORDER_ID = @p1


DECLARE 
	@order_id int, 
	@customer_name nvarchar(100)

SET @order_id = 5

SELECT @customer_name = customer_name
FROM ORDER_TBL
WHERE ORDER_ID = @order_id

SELECT @customer_name


  -----FUNCTIONS -------

--- Metni b�y�k harfe �eviren bir fonksiyon yaz�n�z...

CREATE FUNCTION fnc_uppertext
(
	@inputtext varchar (MAX)
)
RETURNS VARCHAR (MAX)
AS
BEGIN
	RETURN UPPER(@inputtext)
END


SELECT dbo.fnc_uppertext('hello world')

---------------------------------------------

SELECT *
FROM ORDER_TBL
 

-- M��teri ad�n� parametre olarak al�p o m��terinin al��veri�lerini d�nd�ren bir fonksiyon yaz�n�z.

CREATE FUNCTION fnc_getorderbycustomers
(
@customer_name nvarchar(100)
)
RETURNS TABLE
AS
 
RETURN
	SELECT *
	FROM ORDER_TBL
	WHERE CUSTOMER_NAME = @customer_name
;

SELECT *
FROM dbo.fnc_getorderbycustomers('Owen')


----- IF/ELSE 

-- Bir fonksiyon yaziniz. Bu fonksiyon ald��� rakamsal de�eri �ift ise �ift, tek ise Tek d�nd�rs�n. E�er 0 ise S�f�r d�nd�rs�n.

SELECT 10  % 2


DECLARE 
	 @input int, 
	 @modulus int

set @input = 100

SELECT @modulus = @input % 2

print @modulus

------------------------------------------------------------
------------------------------------------------------------


create FUNCTION dbo.fnc_tekcift
(
	@input int
)
RETURNS nvarchar(max)
AS
BEGIN
	DECLARE
		-- @input int,
		@modulus int,
		@return nvarchar(max)
	-- SET @input = 100
	SELECT @modulus = @input % 2
	IF @input = 0
		BEGIN
		 set @return = 'S�f�r'
		END
	ELSE IF @modulus = 0
		BEGIN
		 set @return = '�ift'
		END
	ELSE set @return = 'Tek'
	return @return
	
END
;

select dbo.fnc_tekcift(100)

select dbo.fnc_tekcift(100) A, dbo.fnc_tekcift(9) B, dbo.fnc_tekcift(0) C

-------------------------------------------------------
-------------------------------------------------------


   ---- WHILE -----

DECLARE 
	@counter int,
	@total int 

set @counter = 1
set @total = 50

WHILE @counter <= 50
	BEGIN
		print @counter
		set @counter = @counter +1
	END


--Sipari�leri, tahmini teslim tarihleri ve ger�ekle�en teslim tarihlerini k�yaslayarak
--'Late','Early' veya 'On Time' olarak s�n�fland�rmak istiyorum.
--E�er sipari�in ORDER_TBL tablosundaki EST_DELIVERY_DATE' i (tahmini teslim tarihi) 
--ORDER_DELIVERY tablosundaki DELIVERY_DATE' ten (ger�ekle�en teslimat tarihi) k���kse
--Bu sipari�i 'LATE' olarak etiketlemek,
--E�er EST_DELIVERY_DATE>DELIVERY_DATE ise Bu sipari�i 'EARLY' olarak etiketlemek,
--E�er iki tarih birbirine e�itse de bu sipari�i 'ON TIME' olarak etiketlemek istiyorum.

--Daha sonradan sipari�leri, sahip olduklar� etiketlere g�re farkl� i�lemlere tabi tutmak istiyorum.

--istenilen bir order' �n status' unu tan�mlamak i�in bir scalar valued function olu�turaca��z.
--��nk� girdimiz order_id, ��kt�m�z ise bir string de�er olan statu olmas�n� bekliyoruz.

create FUNCTION dbo.fnc_orderstatus
(
	@input int
)
RETURNS nvarchar(max)
AS
BEGIN
	declare
		@result nvarchar(100)
	-- set @input = 1
	select	@result =
				case
					when B.DELIVERY_DATE < A.EST_DELIVERY_DATE
						then 'EARLY'
					when B.DELIVERY_DATE > A.EST_DELIVERY_DATE
						then 'LATE'
					when B.DELIVERY_DATE = A.EST_DELIVERY_DATE
						then 'ON TIME'
				else NULL end
	from	ORDER_TBL A, ORDER_DELIVERY B
	where	A.ORDER_ID = B.ORDER_ID AND
			A.ORDER_ID = @input
	;
	return @result
end
;


select	dbo.fnc_orderstatus(3)
;
select	*, dbo.fnc_orderstatus(ORDER_ID) OrderStatus
from	ORDER_TBL
;




