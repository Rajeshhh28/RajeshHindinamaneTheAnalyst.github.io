SELECT USER();
SELECT CURRENT_USER();
select * from orders;

-- Checking datatypes with their size and details 
DESCRIBE orders;
-- or
SELECT 
    COLUMN_NAME, 
    COLUMN_TYPE, 
    IS_NULLABLE, 
    COLUMN_DEFAULT, 
    CHARACTER_MAXIMUM_LENGTH, 
    NUMERIC_PRECISION, 
    NUMERIC_SCALE
FROM 
    INFORMATION_SCHEMA.COLUMNS
WHERE 
    TABLE_SCHEMA = 'retail_orders'  -- Replace with your database name
    AND TABLE_NAME = 'orders';  -- Replace with your table name
 drop table orders;
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    order_date DATE,
    ship_mode VARCHAR(20),
    segment VARCHAR(20),
    country VARCHAR(20),
    city VARCHAR(20),
    state VARCHAR(20),
    postal_code VARCHAR(20),
    region VARCHAR(20),
    category VARCHAR(20),
    sub_category VARCHAR(20),
    product_id VARCHAR(50),
    quantity DECIMAL(7,2),
    discount DECIMAL(7,2),
    sale_price DECIMAL(7,2),
    profit DECIMAL(7,2)
);

ALTER TABLE orders
MODIFY COLUMN quantity INT;

-- Now we will do  data analysis with relavnmt quetions 
-- Find top 10 higest revenue generating products 

select * from orders;
select product_id,sum(sale_price) as sales from orders group by product_id order by sales desc limit 10 ;

-- Top 5 highest selling product in each reagion 
with cte as(
SELECT region, product_id, SUM(sale_price) AS sales
FROM orders
GROUP BY region, product_id)
Select * from (select *,row_number() over(partition by region ORDER BY sales desc ) as rn 
 from cte ) A
 Where rn<=5
 
-- Find month over month growth comparision for 2022 to 2023 sales example jan 2022 to jan 2023

With cte as (SELECT YEAR(order_date) AS order_year, MONTH(order_date) AS order_month, SUM(sale_price) AS sales
FROM orders
GROUP BY order_year, order_month)
select order_month,
sum(case when order_year=2022 then sales else 0 end) as sales_2022
,sum(case when order_year=2023 then sales else 0 end) as sales_2023
from cte 
group by order_month
order by order_month;

-- for each category which month had the higest sales
select category,year(order_date) as order_year,month(order_date) as order_month,sum(sale_price) as sales
from orders
group by order_month,category
order by order_month,category;

select * from orders;







