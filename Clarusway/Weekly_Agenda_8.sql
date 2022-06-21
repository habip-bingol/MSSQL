
-- Report cumulative total turnover by months in each year in pivot table format.



SELECT *
FROM (
SELECT DISTINCT YEAR(so.order_date) ord_year , MONTH(so.order_date) ord_month,
		SUM(list_price*quantity) OVER(PARTITION BY YEAR(order_date) ORDER BY MONTH(order_date)) cum_total_turnover
FROM sale.order_item soi, sale.orders so
WHERE soi.order_id = so.order_id
) as source_table
PIVOT (
	SUM(cum_total_turnover)
	for ord_year in ([2018], [2019], [2020])
) as pivot_table



-- What percentage of customers purchasing a product have purchased the same product again?

 --- FIRST WAY
SELECT	soi.product_id, 
		CAST(1.0*(COUNT(so.customer_id) - COUNT(DISTINCT so.customer_id))/COUNT(so.customer_id) AS DECIMAL(3,2)) per_of_cust_pur
FROM	sale.order_item soi, sale.orders so
		WHERE	soi.order_id = so.order_id		
GROUP BY soi.product_id


--- SECOND WAY
with T1 as
(
select  product_id,
sum(case when  counts >=2 then 1 else 0 end) as customer_counts ,
count(customer_id) as totl_customer
from
(
select  distinct  b.product_id,  a.customer_id,
count(a.customer_id) over( partition by b.product_id, a.customer_id ) as counts
from sale.orders a, sale.order_item b
where  a.order_id = b.order_id) as X
group by product_id )
select product_id, cast(1.0*customer_counts/totl_customer as numeric(3,2)) per_of_cust_pur
from T1;
 

 -- From the following table of user IDs, actions, and dates, 
 -- write a query to return  the publication and cancellation rate for each user.

 CREATE TABLE Actions(
			[User_ID] TINYINT NOT NULL,
			[Action] VARCHAR(10),
			[Date] DATE);


INSERT INTO Actions
VALUES 
	(1, 'START', '01-01-2022'),
	(1, 'CANCEL', '01-02-2022'),
	(2, 'START', '01-03-2022'),
	(2, 'PUBLISH', '01-04-2022'),
	(3, 'START', '01-05-2022'),
	(3, 'CANCEL', '01-06-2022'),
	(1, 'START', '01-07-2022'),
	(1, 'PUBLISH', '01-08-2022');



select  A.User_ID
		, cast(sum(publish)*2.0/count(*)  as decimal(10,2)) Publish_rate
		, cast(sum(cancel)*2.0/count(*) as decimal(10,2)) cancel_rate
from
(
select *, IIF(action='PUBLISH',1,0) publish
	, IIF(action='CANCEL',1,0) cancel
from actions
)A
group by A.User_ID



--- Alternative
with tbl1 as
(
	select distinct [User_ID], Action,
		count(Action) over (partition by [User_ID], [Action]) count_actions
	from Actions
	where Action = 'Start'
),
tbl2 as
(
select *,
		count(Action) over (partition by [User_ID], [Action]) count_actions
	from Actions
	where Action != 'Start'
)
select *
from tbl1, tbl2
where tbl1.User_ID = tbl2.User_ID


SELECT User_ID,
		SUM(CASE WHEN action = 'start' THEN 1 ELSE 0 END) AS starts,
		SUM(CASE WHEN action = 'cancel' THEN 1 ELSE 0 END) AS cancels,
		SUM(CASE WHEN action = 'publish' THEN 1 ELSE 0 END) AS publishes
FROM Actions
GROUP BY User_ID
ORDER BY 1


WITH tbl as (
SELECT *
FROM (
	SELECT * 
	FROM Actions) main_tbl
PIVOT
(
	COUNT([Date])
	FOR Action in ([START], [PUBLISH], [CANCEL])) AS pivot_table
)
select User_ID, CAST (1.0 *PUBLISH/START AS DECIMAL(3,2)) Publish_Rate,
	    CAST (1.0 * CANCEL/START AS DECIMAL(3,2)) Cancel_Rate
from tbl




