-- Write a Sql Query to find the nth highest salary of the employee from the table employees

create database practice;
use practice;

create table employees(
ID int not null primary key,
Name varchar(20),
Salary int
);

insert into employees values
(1,'Somesh',90000),
(2,'Vinay',70000),
(3,'Hima',75000),
(4,'Prashant',70000),
(5,'Shivangi',45000),
(6,'Priya',40000),
(7,'Mohan',95000);

select * from employees;

-- 1. Find the 2nd highest salary from table employees
select * from employees
order by salary desc
limit 1 offset 1;

-- 2. Find the 6th highest salary from table employees
select distinct(salary) from employees
order by salary desc
limit 1 offset 5;

-- 3. Find the 4th highest salary from table employees (without LIMIT command)
select * 
from(
        select *,dense_rank() over(order by salary desc) as rnk 
        from employees
        ) tab
where rnk=4;

-- (or)
with cte as
(
        select *,dense_rank() over(order by salary desc) as rnk 
        from employees
)

select * from cte
where rnk=4;
