SELECT * FROM Customers;


-- WHERE Command

SELECT * FROM Customers
WHERE CITY='?STANBUL'

-- ctrl+t yap?p ?al??t?r?nca gridleri kapat?p sonu? verir(text halinde )
-- eski haline d?nmesi i?in ctrl+d yapmam?z laz?m 
-- ctrl+shift+f dosya halinde kaydeder

SELECT * FROM Customers
WHERE CITY <> '?ZM?R';

SELECT * FROM Customers
WHERE not CITY = '?ZM?R'; -- E?it de?ildirle ayn?d?r.

SELECT * FROM Customers
WHERE BIRTHDATE > '19971024'; 
--Dilden ba??ms?z ?al??abilen sorunsuz bir tarih format?d?r.Y?lAyG?n

SELECT * FROM Customers
WHERE BIRTHDATE BETWEEN '19971024' and '19991024';


UPDATE Customers SET AGE = DATEDIFF(YEAR, BIRTHDATE, GETDATE());

SELECT * FROM Customers
WHERE AGE BETWEEN 24 AND 32

UPDATE Customers SET AGE = DATEDIFF(MONTH, BIRTHDATE, GETDATE());

ALTER TABLE CUSTOMERS
ADD AGE_MONTH VARCHAR(10);

UPDATE Customers SET AGE_MONTH = DATEDIFF(MONTH, BIRTHDATE, GETDATE());


/* Regex */

--Ali ile ba?layanlar
SELECT * FROM Customers
WHERE CUSTOMERNAME LIKE 'AL?%'  


--Ali ile ba?lamayanlar
SELECT * FROM Customers
WHERE CUSTOMERNAME not LIKE 'AL?%'


--Ad ve soyad?n i?erisinde Alp ile bitenler
SELECT * FROM Customers
WHERE CUSTOMERNAME LIKE '%ALP'


--ismi Alp ile bitmeyenler
SELECT * FROM Customers
WHERE CUSTOMERNAME not LIKE '%ALP'

--ismin i?erisinde AL ge?enler.
SELECT * FROM Customers
WHERE CUSTOMERNAME LIKE '%AL%'


SELECT * FROM Customers
WHERE CITY IN('?STANBUL')

SELECT * FROM Customers
WHERE CITY IN('?STANBUL','ANKARA')

SELECT * FROM Customers
WHERE CITY IN('?STANBUL','ANKARA','?ZM?R')



SELECT COUNT(*) FROM Customers
WHERE CUSTOMERNAME LIKE '%ER%';

SELECT * FROM Customers
WHERE CITY IN ('?STANBUL', '?ZM?R' );


UPDATE Customers SET GENDER = 'E' WHERE GENDER = 'ERKEK'
UPDATE Customers SET GENDER = 'K' WHERE GENDER = 'KADIN'

UPDATE Customers SET GENDER = 'ERKEK' WHERE GENDER = 'E'
UPDATE Customers SET GENDER = 'KADIN' WHERE GENDER = 'K'


-- DELETE Customers WHERE ID IN (18,19,90)


-- AND --- OR OPERATORS

SELECT * FROM Customers
WHERE CITY = '?STANBUL' AND DISTRICT = 'ESENLER' AND GENDER='KADIN' 


SELECT * FROM Customers
WHERE CITY = '?STANBUL' AND BIRTHDATE BETWEEN '19900102' AND '20000203' AND GENDER='KADIN' 


SELECT * FROM CUSTOMERS
WHERE CITY = '?STANBUL' OR CITY='?ZM?R' ;

SELECT * FROM CUSTOMERS
WHERE CITY IN ('?STANBUL', '?ZM?R');

SELECT * FROM CUSTOMERS
WHERE CITY NOT IN ('?STANBUL', '?ZM?R');

SELECT * FROM CUSTOMERS
WHERE CITY LIKE ('?%');

SELECT * FROM CUSTOMERS
WHERE CITY LIKE '?%' OR CITY LIKE '%K'


SELECT * FROM CUSTOMERS
WHERE CITY LIKE '?%%R' 


--DISTINCT KOMUTU
--T?rkiyenin hangi illerinden m??terimiz var?
SELECT DISTINCT CITY
FROM Customers
--Toplamda istanbul da ka? tane il?e vard?r?
SELECT CITY,DISTRICT FROM Customers
WHERE CITY='?STANBUL'

SELECT DISTINCT CITY,DISTRICT FROM Customers
WHERE CITY='?STANBUL'

SELECT DISTINCT CITY,DISTRICT FROM Customers
WHERE CITY IN ('?STANBUL','ANKARA')

SELECT DISTINCT GENDER FROM CUSTOMERS 
WHERE CITY='?STANBUL'

SELECT DISTINCT CITY,GENDER FROM CUSTOMERS 
WHERE CITY IN ('?STANBUL','ANKARA')

--M??teriler hangi ya?larda
--?stanbul daki m??terilerin ya??
SELECT DISTINCT AGE FROM CUSTOMERS 
WHERE CITY='?STANBUL'

SELECT DISTINCT AGE,GENDER FROM CUSTOMERS 
WHERE CITY IN ('?STANBUL','ANKARA')

SELECT DISTINCT GENDER,AGE FROM CUSTOMERS 
WHERE CITY IN ('?STANBUL','ANKARA')

SELECT DISTINCT customername,GENDER,AGE FROM CUSTOMERS 
WHERE CITY IN ('?STANBUL','ANKARA')

SELECT DISTINCT AGE,customername,GENDER FROM CUSTOMERS 
WHERE CITY IN ('?STANBUL','ANKARA')

--ORDER BY KOMUTU
SELECT * FROM Customers
order by ?d

SELECT * FROM Customers
ORDER BY CUSTOMERNAME DESC

SELECT * FROM Customers
ORDER BY BIRTHDATE DESC

SELECT * FROM Customers
ORDER BY CITY
--?K? KOLONA G?RE SIRALAMA
SELECT * FROM Customers
ORDER BY CITY,CUSTOMERNAME

SELECT * FROM Customers
ORDER BY CITY,CUSTOMERNAME DESC

SELECT * FROM Customers
ORDER BY CITY,DISTRICT,CUSTOMERNAME

SELECT * FROM Customers
WHERE CITY='?STANBUL'
ORDER BY CITY,DISTRICT,CUSTOMERNAME

SELECT * FROM Customers
WHERE CITY='?STANBUL'
ORDER BY 1

SELECT * FROM Customers
WHERE CITY='?STANBUL'
ORDER BY 2 --CUSTOMERNAME KOLONUNA G?RE SIRALADI.

SELECT * FROM Customers
WHERE CITY='?STANBUL'
ORDER BY 5,2,1 --DISTRICT,CUSTOMERNAME,ID

SELECT * FROM Customers
WHERE CITY='?STANBUL'
ORDER BY AGE ASC

SELECT * FROM Customers
WHERE CITY='?STANBUL'
ORDER BY AGE DESC


--TOP KOMUTU
SELECT * FROM Customers

SELECT TOP 100 * FROM Customers

SELECT TOP 200 * FROM Customers

SELECT TOP 10 * FROM Customers

SELECT TOP 10 PERCENT * FROM Customers

SELECT TOP 50 PERCENT * FROM Customers