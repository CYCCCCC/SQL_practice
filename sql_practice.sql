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



-- Ollivander's Inventory

select b.id, c.age, a.coins_needed, a.power
from 
(select code, power, min(coins_needed) as coins_needed 
 from Wands
 group by code, power) a
inner join Wands b on a.code = b.code and a.power = b.power and a.coins_needed = b.coins_needed
inner join (select code, age from Wands_Property where is_evil = 0) c on a.code = c.code
order by a.power desc, c.age desc;



-- Challenges

select a.hacker_id, a.name, count(distinct challenge_id) as challenges_created
from Hackers a
inner join Challenges b on a.hacker_id = b.hacker_id
group by a.hacker_id, a.name
having 
-- the number of challenges = max
challenges_created = (select max(cnt) 
                      from (select hacker_id, count(*) cnt from Challenges group by hacker_id) a)
or
-- the number of challenges is unique
challenges_created in (select cnt
                       from (select hacker_id, count(*) cnt from Challenges group by hacker_id) a
                       group by cnt
                       having count(cnt) = 1)
order by challenges_created desc, a.hacker_id;



-- Contest Leaderboard

select a.hacker_id, b.name, sum(score) as total_score
from(
    select hacker_id, challenge_id, max(score) as score
    from Submissions
    where score != 0
    group by hacker_id, challenge_id
) a
left join Hackers b on a.hacker_id = b.hacker_id
group by a.hacker_id, b.name
order by total_score desc, a.hacker_id;


-- Interviews

select a.contest_id, c.hacker_id, c.name,
sum(case when total_submissions is null then 0 else total_submissions end) as sum_submissions,
sum(case when total_accepted_submissions is null then 0 else total_accepted_submissions end) as sum_accepted_submissions,
sum(case when total_views is null then 0 else total_views end) as sum_views,
sum(case when total_unique_views is null then 0 else total_unique_views end) as sum_unique_views
from Colleges a
left join Challenges b on a.college_id = b.college_id
left join Contests c on a.contest_id = c.contest_id
left join (select challenge_id, sum(total_views) as total_views, sum(total_unique_views) as total_unique_views
           from View_Stats
           group by challenge_id) d on b.challenge_id = d.challenge_id
left join (select challenge_id, sum(total_submissions) as total_submissions, sum(total_accepted_submissions) as total_accepted_submissions
           from Submission_Stats
           group by challenge_id) e on b.challenge_id = e.challenge_id
group by a.contest_id, c.hacker_id, c.name
having sum_views > 0 or
sum_unique_views > 0 or
sum_submissions > 0 or
sum_accepted_submissions > 0 
order by a.contest_id;


-- 15 Days of Learning SQL

select a.submission_date, a.daily_cnt, a.hacker_id, b.name
from (
    select hacker_id, submission_date, daily_cnt,
           rank() over(partition by submission_date order by daily_cnt desc, hacker_id asc) as ranking
    from (
        select hacker_id, submission_date, count(*) as daily_cnt
        from Submissions
        where hacker_id in (select hacker_id
                            from Submissions
                            group by hacker_id
                            having count(distinct submission_date) = 15)
        group by hacker_id, submission_date
    ) a
) a
left join Hackers b on a.hacker_id = b.hacker_id
where ranking = 1
order by a.submission_date;

