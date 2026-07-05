use supply_data;

select * from customers;
select * from orders;
select * from products;
select * from shipping;
select * from category;


# Q1 — Markets Above Minimum Order Volume

select Market,count(distinct`Order Id`) as total_orders,
 SUM(`Total Sales`) AS total_revenue,
 SUM(`Benefit per order`) AS total_profit
 from orders
 group by Market
order by total_revenue DESC;


-- # Q2 — On-Time vs Late Delivery Rate by Shipping Mode
SELECT
    `Shipping Mode`,

    ROUND(
        100.0 * SUM(CASE
            WHEN `Delivery Status` = 'Shipping on time' THEN 1 ELSE 0 END) / COUNT(*), 2) AS on_time_pct,

    ROUND(
        100.0 * SUM(CASE
            WHEN `Delivery Status` = 'Late delivery' THEN 1 ELSE 0 END) / COUNT(*), 2) AS late_delivery_pct,

    ROUND(
        100.0 * SUM(CASE
            WHEN `Delivery Status` = 'Advance shipping' THEN 1
            ELSE 0 END) / COUNT(*), 2) AS advance_delivery_pct

FROM shipping
GROUP BY `Shipping Mode`
ORDER BY on_time_pct DESC;

-- # Q3 — Average Delivery Delay by Market
select o.Market,
round(avg(s.`Days for shipping (real)`-s.`Days for shipment (scheduled)`),2) as avg_delay_days
from orders o inner join shipping s
on s.`Order ID`=o.`Order Id`
group by o.Market
order by  avg_delay_days;




-- # Q4 — Monthly Sales Trend
-- show Total  sales For each month.
select monthname(`order date`) as month,
round(sum(`Total Sales`),2) as monthly_revenue
from orders
group by month
order by monthly_revenue desc;

-- Q5 calculate  Month-over-Month sales Growth (in %).
with monthly_sales as(
select month(`order date`) as month,
YEAR(`order date`) AS yr,
round(sum(`Total Sales`),2) as Total_sales
from orders
group by month,yr
order by month
)
select month,yr,Total_sales,
lag(Total_sales) over(order by month) as prev_month_rev,
  round(((Total_sales -lag(Total_sales) over(order by month))
          / lag(Total_sales) over(order by month))*100,2)
AS month_growth_pct
from monthly_sales
order by yr, month;




-- Q6 — Top 10 Products by Revenue

select p.`Product Name`,round(sum(o.`Total sales`),2) as total_revenue
from orders o join products p
on o.`Product Card Id`=p.`Product Card Id`
group by  p.`Product Name`
order by  total_revenue desc
limit 10;

-- # Q7 — show total sales ,total profit and total margin foreach category product.
select c.`Category Name`,
round(sum(o.`Total Sales`),2) as total_sales,
round(sum(o.`Benefit per order`),2) as total_profit,
round((sum(o.`Benefit per order`)/sum(o.`Total Sales`))*100,2) as total_margin_perct
from orders o left join products p
on p.`Product Card Id`=o.`Product Card Id`
 join category c
on c.`Product Category Id`= p.`Product Category Id`
group by c.`Category Name`
order by total_sales,total_profit,total_margin_perct;
 

-- # Q8 — Rank Products Within Each Category
SELECT
    `Category Name`,
    `Product Name`,
    total_sales,
    RANK() OVER (
        PARTITION BY `Category Name`
        ORDER BY total_sales DESC
    ) AS product_rank
FROM (
    SELECT
        c.`Category Name`,
        p.`Product Name`,
        SUM(o.`Total Sales`) AS total_sales
    FROM orders o
    left JOIN products p
        ON o.`Product Card Id` = p.`Product Card Id`
    JOIN category c
        ON p.`Product Category Id` = c.`Product Category Id`
    GROUP BY
        c.`Category Name`,
        p.`Product Name`
) AS t
ORDER BY
    `Category Name`,
    product_rank;



-- Q9 — Repeat vs One-Time Customers
WITH customer_orders AS (
    SELECT `Customer Id`, COUNT(DISTINCT `Order Id`) AS order_count
    FROM orders
    GROUP BY `Customer Id`
)
SELECT
    CASE WHEN order_count = 1 THEN 'One-Time Customer' ELSE 'Repeat Customer' END AS customer_type,
    COUNT(*) AS num_customers
FROM customer_orders
GROUP BY CASE WHEN order_count = 1 THEN 'One-Time Customer' ELSE 'Repeat Customer' END;

-- Q10 — Discount Rate vs. Average Profit
SELECT
    CASE
        WHEN `Order Item Discount Rate` = 0 THEN 'No Discount'
        WHEN `Order Item Discount Rate` <= 0.10 THEN '1-10%'
        WHEN `Order Item Discount Rate` <= 0.20 THEN '11-20%'
        ELSE '21%+'
    END AS discount_band,
    COUNT(*) AS order_lines,
    ROUND(AVG(`Benefit per order`), 2) AS avg_profit
FROM orders
GROUP BY
    CASE
        WHEN `Order Item Discount Rate` = 0 THEN 'No Discount'
        WHEN `Order Item Discount Rate` <= 0.10 THEN '1-10%'
        WHEN `Order Item Discount Rate` <= 0.20 THEN '11-20%'
        ELSE '21%+'
    END
ORDER BY discount_band;

-- Q11 — Cancelled Orders by Region
WITH region_cancel_rate AS (
    SELECT
        `Order Region`,
        ROUND(100.0 * SUM(CASE WHEN `Order Status` = 'CANCELED' THEN 1 ELSE 0 END) / COUNT(*), 2) AS cancel_rate_pct
    FROM orders
    GROUP BY `Order Region`)
SELECT *
FROM region_cancel_rate
WHERE cancel_rate_pct > (SELECT AVG(cancel_rate_pct) FROM region_cancel_rate)
ORDER BY cancel_rate_pct DESC;


-- # Q12 — Orders Missing Shipping Records

SELECT
    o.`Order Id`,
    o.`Market`,
    s.`Delivery Status`
FROM orders o
LEFT JOIN shipping s
on o.`Order Id`=s.`Order Id`
WHERE s.`Order Id` is null;

                                                      