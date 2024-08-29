SELECT * FROM df_orders;

--find total sales by category
Select category, round(SUM(sale_price),2) as sales
from df_orders
GROUP by category
ORDER by sales desc;

--find sales by customer_segment
SELECT segment, ROUND(SUM(sale_price),2) as sales
from df_orders
GROUP BY segment
order by sales desc;

--find top 10 highest revenue generating products
Select TOP 10 product_id, SUM(sale_price) AS sales
from df_orders
group by product_id
order by sales desc;

--find top 5 highest selling products in each region
WITH cte as (
SELECT region, product_id, SUM(sale_price) as sales
from df_orders
GROUP BY region, product_id)
SELECT * FROM (
SELECT *, ROW_NUMBER() OVER(PARTITION BY region order by sales DESC) as rn
from cte) A
WHERE rn<=5;

--find month over month growth comparison for 2022 and 2023 sales eg : jan 2022 vs jan 2023
WITH cte AS (
SELECT year(order_date) AS order_year,month(order_date) AS order_month,
sum(sale_price) AS sales
FROM df_orders
GROUP BY year(order_date),month(order_date)
--order by year(order_date),month(order_date)
	)
select order_month
, sum(CASE WHEN order_year=2022 THEN sales ELSE 0 END) AS sales_2022
, sum(CASE WHEN order_year=2023 THEN sales ELSE 0 END) AS sales_2023
from cte 
group by order_month
order by order_month;

--for each category which month had highest sales 
with cte as (
select category,format(order_date,'yyyyMM') as order_year_month
, sum(sale_price) as sales 
from df_orders
group by category,format(order_date,'yyyyMM')
--order by category,format(order_date,'yyyyMM')
)
select * from (
select *,
row_number() over(partition by category order by sales desc) as rn
from cte
) a
where rn=1;

--which sub category had highest growth by profit in 2023 compare to 2022
with cte as (
select sub_category,year(order_date) as order_year,
sum(sale_price) as sales
from df_orders
group by sub_category,year(order_date)
--order by year(order_date),month(order_date)
	)
, cte2 as (
select sub_category
, sum(case when order_year=2022 then sales else 0 end) as sales_2022
, sum(case when order_year=2023 then sales else 0 end) as sales_2023
from cte 
group by sub_category
)
select top 1 *
,(sales_2023-sales_2022)
from  cte2
order by (sales_2023-sales_2022) desc;


SELECT * FROM df_orders;

SELECT COUNT(*) FROM df_orders;