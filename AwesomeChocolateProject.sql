SELECT
	*
FROM sales;


SELECT
	SaleDate,
	Amount, 
	Customers
FROM sales;


SELECT
	SaleDate, 
	Amount, 
	Boxes, 
	Amount/Boxes 'Amount per Boxes'
FROM sales;


SELECT
	*
FROM sales
WHERE Amount > 10000
ORDER BY Amount;


SELECT
	*
FROM sales
WHERE GeoId = 'g1'
ORDER BY PId, amount desc;


SELECT
	*
FROM sales
WHERE Amount > 10000
AND SaleDate >= '2022-01-01';


SELECT
	SaleDate, 
	Amount
FROM sales
WHERE Amount > 10000 and year(SaleDate) = 2022
ORDER BY Amount desc;


SELECT
	*
FROM sales
WHERE Boxes between 0 and 50
ORDER BY Boxes;


SELECT
	SaleDate, 
	Amount, 
	Boxes,
	WEEKDAY(SaleDate) 'Day of Week'
FROM sales
WHERE WEEKDAY(SaleDate) = 4;


SELECT
	*
FROM people;


SELECT
	*
FROM people
WHERE team = 'Delish' or team = 'Jucies';


SELECT
	*
FROM people
WHERE team IN ('Delish','Jucies');


SELECT *
FROM people
WHERE salesperson LIKE 'B%';


SELECT
	SaleDate,
	Amount,
	CASE
		WHEN Amount < 1000 then 'Under 1k'
		WHEN Amount < 5000 then 'Under 5k'
		WHEN Amount < 10000 then 'Under 10k'
		ELSE 'Above 10k'
	END as 'Amount Category'
FROM sales
ORDER BY Amount desc;


SELECT
	*
FROM people p
JOIN sales s
	ON p.spid = s.spid;
	

SELECT
	s.saledate,
	s.amount, 
	pr.product
FROM sales s
LEFT JOIN products pr
	ON s.pid = pr.pid;
	
    
SELECT 
	s.saledate,
	s.amount,
	p.salesperson,
	pr.product
FROM sales s
JOIN people p
	ON s.spid = p.spid
JOIN products pr
        ON s.pid = pr.pid
	

SELECT
	s.saledate,
	s.amount,
	p.salesperson,
	p.team,
	pr.product
FROM sales s
JOIN people p
	ON s.spid = p.spid
JOIN products pr
        ON s.pid = pr.pid
WHERE s.amount <500
	AND p.Team = 'Delish';
	

SELECT
	s.saledate, 
	s.amount,
	p.salesperson,
	p.team,
	pr.product
FROM sales s
JOIN people p
	ON s.spid = p.spid
JOIN products pr
        ON s.pid = pr.pid
WHERE s.amount <500
	AND p.Team = '';
	

SELECT
	s.saledate,
	s.amount,
	p.salesperson, 
	p.team, 
	pr.product, 
	g.Geo
FROM sales s
JOIN people p
	ON s.spid = p.spid
JOIN products pr
        ON s.pid = pr.pid
JOIN geo g
	ON s.geoid = g.geoid
WHERE g.geo IN ('New Zealand', 'India')
	AND p.team <> ''
	AND s.amount <500
ORDER BY saledate;


SELECT
	geoid, 
	SUM(Amount)
FROM sales
GROUP BY geoid;


SELECT
	g.geo, 
	SUM(boxes), 
	SUM(amount), 
	AVG(Amount)
FROM sales s
JOIN geo g
	ON s.geoid = g.geoid
GROUP BY geo;

	
SELECT
	pr.category, 
	p.team, 
	SUM(boxes), 
	SUM(amount)
FROM sales s
JOIN people p
	ON s.spid = p.spid
JOIN products pr
	ON s.pid = pr.pid
WHERE p.team <> ''
GROUP BY pr.category, p.team
ORDER BY pr.category, p.team;


SELECT
	pr.product, 
	SUM(amount) as 'Total Amount'
FROM sales s
JOIN products pr
	ON s.pid = pr.pid
GROUP BY pr.product
ORDER BY `Total Amount` desc
LIMIT 10;
