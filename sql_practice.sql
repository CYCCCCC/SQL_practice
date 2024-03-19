-- The PADS

select concat(Name, '(', substring(Occupation, 1, 1), ')')
from OCCUPATIONS
order by Name;

select concat('There are a total of ', count(*), ' ', lower(Occupation), 's.' )
from OCCUPATIONS
group by Occupation
order by count(*), Occupation;



-- Occupations

select
min(case when Occupation = 'Doctor' then Name else NULL end) as Doctor,
min(case when Occupation = 'Professor' then Name else NULL end) as Professor,
min(case when Occupation = 'Singer' then Name else NULL end) as Singer,
min(case when Occupation = 'Actor' then Name else NULL end) as Actor
from (
    select *, rank() over(partition by Occupation order by Name) as ranking
    from OCCUPATIONS
) a 
group by ranking;




-- Binary Tree Nodes

select N,
case when P is null then 'Root'
     when (select count(*) from BST a where a.P = b.N) > 0 then 'Inner'
     else 'leaf' end
from BST b
order by N;



-- New Companies

select a.company_code, a.founder,
    (select count(distinct lead_manager_code) from Lead_Manager where company_code = a.company_code),
    (select count(distinct senior_manager_code) from Senior_Manager where company_code = a.company_code),
    (select count(distinct manager_code) from Manager where company_code = a.company_code),
    (select count(distinct employee_code) from Employee where company_code = a.company_code)
from Company a
order by a.company_code;



-- The Blunder

select ceil(avg(Salary) - avg(replace(Salary, '0', '')))  -- use ceil to up to the next integer
from EMPLOYEES;



-- Top Earners

select max(salary * months), count(*)
from Employee
where (salary * months) = (select max(salary * months) 
                           from Employee);




-- Weather Observation Station 2

select round(sum(LAT_N), 2), round(sum(LONG_W), 2)
from STATION;



-- Weather Observation Station 15

select round(LONG_W, 4)
from STATION
where LAT_N = (select max(LAT_N) from STATION
               where LAT_N < 137.2345);



-- Weather Observation Station 18

select round((max(LAT_N) - min(LAT_N)) + (max(LONG_W) - min(LONG_W)), 4)
from STATION;


-- Weather Observation Station 19

round(sqrt(power(max(LAT_N) - min(LAT_N), 2) + power(max(LONG_W) - min(LONG_W), 2)), 4)
from STATION;


-- Weather Observation Station 20

select round(LAT_N, 4)
from STATION a
where (select count(LAT_N) from STATION b where a.LAT_N > b.LAT_N) 
= (select count(LAT_N) from STATION b where a.LAT_N < b.LAT_N);


