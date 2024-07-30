/*
Write an SQL query to find and remove duplicate entries from a
database ( when all the columns have duplicate values)
*/
use practice;

create table emp1(
        emp_id int,
        name varchar(20),
        age int,
        salary float
);

insert into emp1 values
(102,'Arival',24,20000),
(103,'Arohi',28,350000),
(104,'James',35,120000),
(102,'Arival',24,20000);

select * from emp1;
-- Method 1
create table emp_backup as
select distinct * from emp1;
select * from emp_backup;
drop table emp1;
alter table emp_backup rename emp1;
select * from emp1;

-- Method 2
select * from emp1;
insert into emp1 values
(102,'Arival',24,20000);

alter table emp1 add column row_num int auto_increment unique;

create  temporary table emp_temp
as select * from emp1;

select * from emp_temp;

delete from emp1
where row_num not in (
		    select min(row_num) from emp_temp
                        group by emp_id,name,age,salary);
 
drop table emp_temp;
select * from emp1;