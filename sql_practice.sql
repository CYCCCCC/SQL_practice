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




-- SQL Project Planning

select Start_Date, min(End_Date)
from 
(select Start_Date from Projects where Start_Date not in (select End_Date from Projects)) a
inner join
(select End_Date from Projects where End_Date not in (select Start_Date from Projects)) b
where Start_Date < End_Date
group by Start_Date
order by min(End_Date) - Start_Date, Start_Date;



-- Placements

select a.Name
from Students a
left join Friends b on a.ID = b.ID
left join Packages c on a.ID = c.ID
left join Packages d on b.Friend_ID = d.ID
where c.Salary < d.Salary
order by d.Salary;



-- Symmetric Pairs

select a.X, a.Y
from Functions a
inner join Functions b on a.X = b.Y and a.Y = b.X
group by a.X, a.Y
having count(*) > 1 or a.X < a.Y   -- count(*)>1 to filter the case X = Y
order by a.X;



-- The Report

select (case when Grade < 8 then NULL else Name end) as Name, Grade, Marks
from Students, Grades
where Marks between Min_Mark and Max_Mark
order by Grade desc, (case when Grade >= 8 then Name else Marks end);



-- Top Competitors

select d.hacker_id, d.name
from Submissions a
left join Challenges b on a.challenge_id = b.challenge_id
left join Difficulty c on b.difficulty_level = c.difficulty_level
left join Hackers d on a.hacker_id = d.hacker_id
where a.score = c.score
group by d.hacker_id, d.name
having count(distinct a.challenge_id) > 1
order by count(distinct a.challenge_id) desc, d.hacker_id;