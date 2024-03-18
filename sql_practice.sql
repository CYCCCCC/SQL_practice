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
from EMPLOYEES

