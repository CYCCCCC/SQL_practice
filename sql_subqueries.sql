-- SQL SUBQUERIES
-- https://www.w3resource.com/sql-exercises/subqueries/index.php

-- 1

select *
from Orders
where salesman_id in (select salesman_id from Salesman where name = 'Paul Adam');


-- 2

select *
from Orders
where salesman_id in (select salesman_id from Salesman where city = 'Lindon');


-- 3

select *
from Orders
where salesman_id in (select distinct salesman_id from Orders where customer_id = 3007);


-- 4

select *
from Orders
where purch_amt > (select avg(purch_amt) from Orders where ord_date = '2012-10-10');


-- 5



-- 6

select purch_amt * commission as total_commission
from Orders a
inner join (select salesman_id, commission from Salesman where city = 'Paris') b
on a.salesman_id = b.salesman_id;


-- 7




-- 8

select grade, count(customer_id)
from Customer
where grade > (select grade from Customer where city = 'New York');


-- 9

select *
from Orders
where salesman_id = (select a.salesman_id
                     from Salesman a
                     left join Orders b on a.salesman_id = b.salesman_id
                     group by a.salesman_id
                     order by sum(purch_amt * commission) desc
                     limit 1)


-- 11

select a.salesman_id, a.name
from Salesman a
left join Customer b on a.salesman_id = b.salesman_id
group by a.salesman_id, a.name
having count(distinct customer_id) > 1;


select salesman_id, name
from Salesman
where salesman_id in (select salesman_id 
                      from Customer
                      group by salesman_id
                      having count(distinct customer_id) > 1);



-- 14

select ord_date
from Orders
group by ord_date
having sum(purch_amt) - max(purch_amt) > 1000;



-- 18

select *
from Salesman
where salesman_id in (
    select distinct salesman_id
    from (
        select salesman_id, customer_id
        from Orders
        group by salesman_id, customer_id
        having count(ord_no) > 1) a);




