select *
from sales;

select SaleDate, Amount, Customers
from sales;

select SaleDate, Amount, Boxes, Amount/Boxes  'Amount per Boxes'
from sales;

select *
from sales
where amount > 10000
order by amount;

select *
from sales
where geoid = 'g1'
order by pid, amount desc;

select *
from sales
where amount > 10000
and SaleDate >= '2022-01-01';

select saledate, amount
from sales
where amount > 10000 and year(SaleDate) = 2022
order by amount desc;

select *
from sales
where Boxes between 0 and 50
order by boxes;

select SaleDate, amount, boxes, weekday(SaleDate) 'Day of Week'
from sales
where weekday(SaleDate) = 4;

select *
from people;

select *
from people
where team = 'Delish' or team = 'Jucies';

select *
from people
where team in ('Delish','Jucies');

select *
from people
where salesperson like 'B%';

select SaleDate, amount,
		case
			when amount < 1000 then 'Under 1k'
			when amount < 5000 then 'Under 5k'
			when amount < 10000 then 'Under 10k'
			else 'Above 10k'
			end as 'Amount Category'
from sales
order by amount desc;


select *
from people p
join sales s
on p.spid = s.spid;

select s.saledate, s.amount, pr.product
from sales s
	left join products pr
	on s.pid = pr.pid;
    
select s.saledate, s.amount, p.salesperson, pr.product
from sales s
	join people p
	on s.spid = p.spid
		join products pr
        on s.pid = pr.pid;

select s.saledate, s.amount, p.salesperson, p.team, pr.product
from sales s
	join people p
	on s.spid = p.spid
		join products pr
        on s.pid = pr.pid
where s.amount <500
and p.Team = 'Delish';

select s.saledate, s.amount, p.salesperson, p.team, pr.product
from sales s
	join people p
	on s.spid = p.spid
		join products pr
        on s.pid = pr.pid
where s.amount <500
and p.Team = '';

select s.saledate, s.amount, p.salesperson, p.team, pr.product, g.Geo
from sales s
	join people p
	on s.spid = p.spid
		join products pr
        on s.pid = pr.pid
         join geo g
         on s.geoid = g.geoid
			where g.geo in ('New Zealand', 'India')
				and p.team <> ''
				and s.amount <500
order by saledate;


select geoid, sum(Amount)
from sales
group by geoid;

select g.geo, sum(boxes), sum(amount), avg(Amount)
from sales s
	join geo g
		on s.geoid = g.geoid
group by geo;
	
select pr.category, p.team, sum(boxes), sum(amount)
from sales s
	join people p
		on s.spid = p.spid
			join products pr
				on s.pid = pr.pid
where p.team <> ''
group by pr.category, p.team
order by pr.category, p.team;

select pr.product, sum(amount) as 'Total Amount'
from sales s
	join products pr
		on s.pid = pr.pid
group by pr.product
order by `Total Amount` desc
limit 10;