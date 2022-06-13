-- Below you see a table of the actions of customers visiting the website 
-- by clicking on two different types of advertisements given by an E-Commerce company.

-- Write a query to return the conversion rate for each Advertisement type.

--Desired Output:

--  Adv_Type   Conversion_Rate

--     A              0.33
--     B              0.25




CREATE TABLE Actions (
			Visitor_ID IDENTITY(1,1) INT ,
			Adv_type CHAR not null,
			Action VARCHAR(20)
			)



INSERT INTO Actions VALUES ('A', 'Left')
INSERT INTO Actions VALUES ('A', 'Order')
INSERT INTO Actions VALUES ('B', 'Left')
INSERT INTO Actions VALUES ('A', 'Order')
INSERT INTO Actions VALUES ('A', 'Review')
INSERT INTO Actions VALUES ('A', 'Left')
INSERT INTO Actions VALUES ('B', 'Left')
INSERT INTO Actions VALUES ('B', 'Order')
INSERT INTO Actions VALUES ('B', 'Review')
INSERT INTO Actions VALUES ('A', 'Review')

SELECT *
FROM Actions

SELECT Adv_Type,[Action], count(Action) countOfAction
FROM Actions
GROUP BY Adv_Type, [Action]
ORDER BY Adv_Type

SELECT A.[Adv_Type],
	   cast(sum(A.new_action)*1.0/count(A.new_action)  as numeric (10,2)) as Conversion_Rate
FROM	(SELECT *,
		CASE [Action]
		WHEN 'Order' THEN 1	ELSE 0
		END new_action
		FROM sample1
		) A
GROUP BY A.[Adv_Type]