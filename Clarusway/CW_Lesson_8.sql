
--- Correlated Subqueries

-- Apple - Pre-Owned iPad 3 - 32GB - White ürünün hiç sipariþ verilmediði eyaletleri bulunuz.
-- Eyalet müþterilerin ikamet adreslerinden alýnacaktýr.


-- Aþaðýdaki sorgu ürünü alan müþterilerin eyalet listesini getirir
SELECT DISTINCT c.state
FROM product.product p, 
	 sale.order_item ý, 
	 sale.orders o,
	 sale.customer c
WHERE product_name = 'Apple - Pre-Owned iPad 3 - 32GB - White'
	  and p.product_id = ý.product_id
	  and ý.order_id = o.order_id
	  and o.customer_id = c.customer_id


SELECT DISTINCT [state]
FROM sale.customer c2
WHERE NOT EXISTS (  SELECT DISTINCT c.state
					FROM product.product p, 
						 sale.order_item ý, 
						 sale.orders o,
						 sale.customer c
					WHERE product_name = 'Apple - Pre-Owned iPad 3 - 32GB - White'
						  and p.product_id = ý.product_id
						  and ý.order_id = o.order_id
						  and o.customer_id = c.customer_id
						  and c2.state = c.state
					)

-- or 
SELECT DISTINCT [state]
FROM sale.customer c2
except 
SELECT DISTINCT c.state
FROM product.product p, 
	 sale.order_item ý, 
	 sale.orders o,
	 sale.customer c
WHERE product_name = 'Apple - Pre-Owned iPad 3 - 32GB - White'
	  and p.product_id = ý.product_id
	  and ý.order_id = o.order_id
	  and o.customer_id = c.customer_id

-- Burkes Outlet maðaza stoðunda bulunmayýp,
-- Davi techno maðazasýnda bulunan ürünlerin stok bilgilerini döndüren bir sorgu yazýn

SELECT PC.product_id, PC.store_id, PC.quantity
FROM product.stock PC, sale.store SS
WHERE PC.store_id = SS.store_id AND SS.store_name = 'Davi techno Retail' AND
	NOT EXISTS ( SELECT DISTINCT A.product_id, A.store_id, A.quantity
			FROM product.stock A, sale.store B
			WHERE A.store_id = B.store_id AND B.store_name = 'Burkes Outlet' AND
				PC.product_id = A.product_id AND A.quantity>0
	)

-- Brukes Outlet storedan alýnýp The BFLO Store maðazasýndan hiç alýnmayan ürün var mý?
-- Varsa bu ürünler nelerdir?
-- Ürünlerin satýþ bilgileri istenmiyor, sadece ürün listesi isteniyor.


SELECT DISTINCT  product_id 
FROM [sale].[orders] o, [sale].[store] t, [sale].[order_item] i
WHERE	o.[store_id] = t.[store_id]
		and i.[order_id]=o.[order_id]
		and t.store_name = 'Burkes Outlet'
		and not exists (
					SELECT DISTINCT product_id 
					FROM [sale].[orders] so, [sale].[store] ss, [sale].[order_item] soi
					WHERE	so.[store_id] = ss.[store_id]
							and soi.[order_id]=so.[order_id]
							and ss.store_name = 'The BFLO Store'
							and  soi.[product_id]=i.[product_id]
					)


-- OR 
SELECT P.product_name, p.list_price, p.model_year
FROM product.product P
WHERE NOT EXISTS (
		SELECt	I.product_id
		FROM	sale.order_item I,
				sale.orders O,
				sale.store S
		WHERE	I.order_id = O.order_id AND S.store_id = O.store_id
				AND S.store_name = 'The BFLO Store'
				and P.product_id = I.product_id)
	AND
	EXISTS (
		SELECt	I.product_id
		FROM	sale.order_item I,
				sale.orders O,
				sale.store S
		WHERE	I.order_id = O.order_id AND S.store_id = O.store_id
				AND S.store_name = 'Burkes Outlet'
				and P.product_id = I.product_id)


-- OR
SELECt	distinct I.product_id
		FROM	sale.order_item I,
				sale.orders O,
				sale.store S
		WHERE	I.order_id = O.order_id AND S.store_id = O.store_id
				AND S.store_name = 'Burkes Outlet'
except
		SELECt	distinct I.product_id
		FROM	sale.order_item I,
				sale.orders O,
				sale.store S
		WHERE	I.order_id = O.order_id AND S.store_id = O.store_id
				AND S.store_name = 'The BFLO Store'


-- OR  ??????
SELECT DISTINCT P.product_name
FROM product.product P,
    sale.order_item I,
    sale.orders O,
    sale.store S
WHERE store_name = 'Burkes Outlet'
    AND P.product_id = I.product_id
    AND I.order_id = O.order_id
    AND O.store_id = S.store_id
    AND NOT EXISTS (SELECT PP.product_name
                    FROM product.product PP,
                        sale.order_item SI,
                        sale.orders SO,
                        sale.store SS
                    WHERE store_name = 'The BFLO Store'
                        AND PP.product_id = SI.product_id
                        AND SI.order_id = SO.order_id
                        AND SO.store_id = SS.store_id
                        AND P.product_name = PP.product_name)


----  COMMON TABLE EXPRESSIONS

--Ordinary CTE Examples

-- Jerald Berray isimli müþterinin son sipariþinden önce sipariþ vermiþ 
-- ve Austin þehrinde ikamet eden müþterileri listeleyin.

with tbl AS (
	select	max(b.order_date) JeraldLastOrderDate
	from	sale.customer a, sale.orders b
	where	a.first_name = 'Jerald' and a.last_name = 'Berray'
			and a.customer_id = b.customer_id
)
select	*
from	sale.customer a,
		Sale.orders b,
		tbl c
where	a.city = 'Austin' and a.customer_id = b.customer_id and
		b.order_date < c.JeraldLastOrderDate


with tbl AS (
	select	max(b.order_date) JeraldLastOrderDate
	from	sale.customer a, sale.orders b
	where	a.first_name = 'Jerald' and a.last_name = 'Berray'
			and a.customer_id = b.customer_id
)
select	distinct a.first_name, a.last_name
from	sale.customer a,
		Sale.orders b,
		tbl c
where	a.city = 'Austin' and a.customer_id = b.customer_id and
		b.order_date < c.JeraldLastOrderDate

-- Herbir markanýn satýldýðý en son tarihli bir CTE sorgusunda,
-- Yine herbir markaya ait kaç farklý ürün bulunduðunu da ayrý bir CTE sorgusunda tanýmlayýnýz.
-- Bu sorgularý kullanarak  Logitech ve Sony markalarýna ait son satýþ tarihini ve 
-- toplam ürün sayýsýný (product tablosundaki) ayný sql sorgusunda döndürünüz.

with tbl as(
	select	br.brand_id, br.brand_name, max(so.order_date) LastOrderDate
	from	sale.orders so, sale.order_item soi, product.product pr, product.brand br
	where	so.order_id=soi.order_id and
			soi.product_id = pr.product_id and
			pr.brand_id = br.brand_id
	group by br.brand_id, br.brand_name
),
tbl2 as(
	select	pb.brand_id, pb.brand_name, count(*) count_product
	from	product.brand pb, product.product pp
	where	pb.brand_id=pp.brand_id
	group by pb.brand_id, pb.brand_name
)
select	*
from	tbl a, tbl2 b
where	a.brand_id=b.brand_id

with tbl as(
	select	br.brand_id, br.brand_name, max(so.order_date) LastOrderDate
	from	sale.orders so, sale.order_item soi, product.product pr, product.brand br
	where	so.order_id=soi.order_id and
			soi.product_id = pr.product_id and
			pr.brand_id = br.brand_id
	group by br.brand_id, br.brand_name
),
tbl2 as(
	select	pb.brand_id, pb.brand_name, count(*) count_product
	from	product.brand pb, product.product pp
	where	pb.brand_id=pp.brand_id
	group by pb.brand_id, pb.brand_name
)
select	*
from	tbl a, tbl2 b
where	a.brand_id=b.brand_id and
		a.brand_name in ('Logitech', 'Sony')




--- Recursive CTE Example 

-- 0'dan 9'a kadar herbir rakam bir satýrda olacak þekide bir tablo oluþturun.


WITH cte AS (
	select 0 rakam
	UNION ALL 
	SELECT  rakam+1
	FROM cte
	WHERE rakam < 9 
)
select * from cte


-- 2020 Ocak ayýnýn herbir tarihi bir satýr olacak þekilde 31 satýrlý bir tablo oluþturunuz.


with ocak as (
	select	cast('2020-01-01' as date) tarih
	union all
	select	cast(DATEADD(DAY, 1, tarih) as date) tarih
	from ocak
	where tarih < '2020-01-31'
)
select * from ocak;


-- OR
with cte AS (
	select cast('2020-01-01' as date) AS gun
	union all
	select DATEADD(DAY,1,gun)
	from cte
	where gun < EOMONTH('2020-01-01')
)
select gun tarih, day(gun) gun, month(gun) ay, year(gun) yil,
	EOMONTH(gun) ayinsongunu
from cte;





with cte AS (
	select ascii('A') num
	union all
	select num + 1
	from cte
	where num < ascii('Z')
)
select char(num) from cte;


--Write a query that returns all staff with their manager_ids. (use recursive CTE)

with cte as (
	select	staff_id, first_name, manager_id
	from	sale.staff
	where	staff_id = 1
	union all
	select	a.staff_id, a.first_name, a.manager_id
	from	sale.staff a, cte b
	where	a.manager_id = b.staff_id
)
select *
from	cte


--2018 yýlýnda tüm maðazalarýn ortalama cirosunun altýnda ciroya sahip maðazalarý listeleyin.
--List the stores their earnings are under the average income in 2018.

WITH T1 AS (
SELECT	c.store_name, SUM(list_price*quantity*(1-discount)) Store_earn
FROM	sale.orders A, SALE.order_item B, sale.store C
WHERE	A.order_id = b.order_id
AND		A.store_id = C.store_id
AND		YEAR(A.order_date) = 2018
GROUP BY C.store_name
),
T2 AS (
SELECT	AVG(Store_earn) Avg_earn
FROM	T1
)
SELECT *
FROM T1, T2
WHERE T2.Avg_earn > T1.Store_earn