/*
Write an SQL query to find and remove duplicate entries from a
database ( when only few columns have duplicate values)
*/
use practice;

create table emp(
        emp_id int,
        name varchar(20),
        age int,
        salary float
);

insert into emp values
(102,'Arival',24,20000),
(103,'Arohi',28,350000),
(104,'James',35,120000),
(998,'Arival',24,20000);

select * from emp;

delete from emp
where emp_id in(select emp_id from (
		    select *, row_number() over(partition by name,age,salary order by emp_id) as row_num 
		    from emp) as tab
where row_num>1);