/*
Write an SQL query to find the 2nd highest selling product
(in terms of revenue) for each product category, ordered
by product name
*/
use practice;

CREATE TABLE sales (
order_id INT PRIMARY KEY,
product_name varchar(20) NOT NULL,
units_sold INT DEFAULT 0,
unit_price FLOAT 
);

CREATE TABLE products (
category varchar(20) NOT NULL,
product varchar(20)
);

INSERT INTO sales VALUES
(122,'Bikaji_namkeen',1500,200),
(112,'Lays',10000,20),
(110,'Amul_kool',2200,25),
(138,'Dairy_milk',2000,149),
(202,'Monaco',9000,50),
(118,'Coke',7000,95),
(104,'Appy_fizz',8000,35),
(189,'KitKat',4500,70),
(238,'Dosa_batter',3000,99),
(199,'Munch',4500,80),
(448,'Maggi',10000,168);

INSERT INTO products VALUES
('Snacks','Bikaji_namkeen'),
('Snacks','Lays'),
('Snacks','Monaco'),
('Drinks','Amul_kool'),
('Drinks','Coke'),
('Drinks','Appy_fizz'),
('Chocolates','KitKat'),
('Chocolates','Munch'),
('Chocolates','Dairy_milk'),
('Instant_food','Dosa_batter'),
('Instant_food','Maggi');

select * from sales;
select * from products;

-- Method 1
with cte as(
        select *,(units_sold * unit_price) as revenue,
        rank() over(partition by category order by units_sold * unit_price desc) as rnk
        from sales s
        join products p on p.product=s.product_name
)
select product_name, category
from cte
where rnk=2
order by product_name;

-- Method 2
select product_name,category
from(
        select *,(units_sold * unit_price) as revenue,
        rank() over(partition by category order by units_sold * unit_price desc) as rnk
        from sales s
        join products p on p.product=s.product_name
) tab1
where rnk=2
order by product_name;