 -- DATA VALIDATION
 
-- simple check
SELECT * FROM superstore;

 -- Total Row
SELECT COUNT(*) AS total_rows FROM superstore;

-- Date Range
SELECT MIN(order_date) AS start_date,
       MAX(order_date) AS end_date
FROM superstore;

-- Null checks
SELECT
    COUNT(*) FILTER (WHERE sales IS NULL) AS null_sales,
    COUNT(*) FILTER (WHERE profit IS NULL) AS null_profit
FROM superstore;

-- Negative values
SELECT
    COUNT(*) FILTER (WHERE sales < 0) AS negative_sales,
	COUNT(*) FILTER (WHERE profit < 0) AS negative_sales
FROM superstore;

-- Discount Range
SELECT MIN(discount) AS min_discount,
       MAX(discount) AS max_discount
FROM superstore;

--Invalid Shipping Dates
SELECT COUNT(*) AS invalid_ship_dates
FROM superstore
WHERE ship_date < order_date;

-- Quantity Range
SELECT MIN(quantity), MAX(quantity)
FROM superstore;

-- Duplicate Orders
SELECT order_id, COUNT(*)
FROM superstore
GROUP BY order_id
HAVING COUNT(*) > 1;


 -- PERFORMANCE OVERVIEW
 
-- Total Sales
SELECT SUM(sales) AS total_sales FROM superstore;

-- Total Profit
SELECT SUM(profit) AS total_profit FROM superstore;

-- Overall Margin %
SELECT ROUND((SUM(profit)/SUM(sales))*100,2) AS margin_pct
FROM superstore;

-- Total Orders
SELECT COUNT(DISTINCT order_id) AS total_orders
FROM superstore;

-- Average Order Value
SELECT ROUND(SUM(sales)/COUNT(DISTINCT order_id),2) AS avg_order_value
FROM superstore;

-- Total Quantity
SELECT SUM(quantity) AS total_quantity
FROM superstore;

--Average Discount %
SELECT ROUND(AVG(discount)*100,2) AS avg_discount_pct
FROM superstore;

--Loss Order %
SELECT ROUND(
(SUM(CASE WHEN profit<0 THEN 1 ELSE 0 END)::numeric
/COUNT(*))*100,2) AS loss_order_pct
FROM superstore;

-- Avg Delivery Days
SELECT Round(AVG(ship_date - Order_date),2) AS avg_delivery_days
FROM superstore;


 -- TIME ANALYSIS
 
-- Monthly Sales
SELECT
DATE_TRUNC('month', order_date) AS month,
SUM(sales) AS monthly_sales
FROM superstore
GROUP BY month
ORDER BY month;

-- Monthly Profit
SELECT
DATE_TRUNC('month', order_date) AS month,
SUM(profit) AS monthly_profit
FROM superstore
GROUP BY month
ORDER BY month;

-- Yearly Sales
SELECT
DATE_TRUNC('year', order_date) AS year,
SUM(sales) AS yearly_sales
FROM superstore
GROUP BY year
ORDER BY year;

-- Quarterly Sales
SELECT
DATE_TRUNC('quarter', order_date) AS quarter,
SUM(sales) AS quarterly_sales
FROM superstore
GROUP BY quarter
ORDER BY quarter;

 -- CATEGORY ANALYSIS

-- Sales and Profit by Category
SELECT
category,
SUM(sales) AS total_sales,
SUM(profit) AS total_profit,
ROUND(SUM(profit)/SUM(sales)*100,2) AS profit_margin
FROM superstore
GROUP BY category
ORDER BY total_sales DESC;

-- Category Sales Contribution
SELECT
category,
SUM(sales) AS sales,
ROUND(
SUM(sales) /
(SELECT SUM(sales) FROM superstore) * 100,2
) AS contribution_percent
FROM superstore
GROUP BY category;

 -- SUB-CATEGORY ANALYSIS

-- Sales by Sub Category
SELECT
sub_category,
SUM(sales) AS total_sales
FROM superstore
GROUP BY sub_category
ORDER BY total_sales DESC;

-- Profit by Sub Category
SELECT
sub_category,
SUM(profit) AS total_profit
FROM superstore
GROUP BY sub_category
ORDER BY total_profit DESC;

-- Loss Making Sub Categories
SELECT
sub_category,
SUM(profit) AS total_profit
FROM superstore
GROUP BY sub_category
HAVING SUM(profit) < 0
ORDER BY total_profit;

-- Profit Margin by Sub Category
SELECT
sub_category,
ROUND(SUM(profit)/SUM(sales)*100,2) AS profit_margin
FROM superstore
GROUP BY sub_category
ORDER BY profit_margin DESC;

 -- PRODUCT ANALYSIS


-- Top 10 Products by Sales
SELECT
product_name,
SUM(sales) AS total_sales
FROM superstore
GROUP BY product_name
ORDER BY total_sales DESC
LIMIT 10;

-- Top 10 Products by Profit
SELECT
product_name,
SUM(profit) AS total_profit
FROM superstore
GROUP BY product_name
ORDER BY total_profit DESC
LIMIT 10;

-- Bottom 10 Products by Profit
SELECT
product_name,
SUM(profit) AS total_profit
FROM superstore
GROUP BY product_name
ORDER BY total_profit
LIMIT 10;

-- Products Profit Margin
SELECT
product_name,
ROUND(SUM(profit)/sum(sales)*100,2) AS profit_margin
FROM superstore
GROUP BY product_name
ORDER BY profit_margin DESC;

 -- CUSTOMER ANALYSIS

-- Top Customers by Sales
SELECT
customer_name,
SUM(sales) AS total_sales
FROM superstore
GROUP BY customer_name
ORDER BY total_sales DESC
LIMIT 10;

-- Customer Profitability
SELECT
customer_name,
SUM(sales) AS total_sales,
SUM(profit) AS total_profit
FROM superstore
GROUP BY customer_name
ORDER BY total_profit DESC;

-- Customer Order Count
SELECT
customer_name,
COUNT(DISTINCT order_id) AS total_orders
FROM superstore
GROUP BY customer_name
ORDER BY total_orders DESC;

 -- SEGMENT ANALYSIS

-- Sales by Segment
SELECT
segment,
SUM(sales) AS total_sales
FROM superstore
GROUP BY segment
ORDER BY total_sales DESC;

-- Profit by Segment
SELECT
segment,
SUM(profit) AS total_profit
FROM superstore
GROUP BY segment
ORDER BY total_profit DESC;

-- Profit Margin by Segment
SELECT
segment,
ROUND(SUM(profit)/SUM(sales)*100,2) AS profit_margin
FROM superstore
GROUP BY segment;

-- Average Discount by Segment
SELECT
segment,
Avg(discount) AS avg_discount
FROM superstore
GROUP BY segment;

-- REGIONAL ANALYSIS

-- Sales by Region
SELECT
region,
SUM(sales) AS total_sales
FROM superstore
GROUP BY region
ORDER BY total_sales DESC;

-- Profit by Region
SELECT
region,
SUM(profit) AS total_profit
FROM superstore
GROUP BY region
ORDER BY total_profit DESC;

-- Sales by State
SELECT
state,
SUM(sales) AS total_sales
FROM superstore
GROUP BY state
ORDER BY total_sales DESC;

-- Profit by State
SELECT
state,
SUM(profit) AS total_profit
FROM superstore
GROUP BY state
ORDER BY total_profit DESC;

 -- DISCOUNT IMPACT

-- Discount vs Profit
SELECT
discount,
SUM(sales) AS sales,
SUM(profit) AS profit
FROM superstore
GROUP BY discount
ORDER BY discount;

-- Discount Band Analysis
SELECT
CASE
WHEN discount <= 0.10 THEN '0-10%'
WHEN discount <= 0.20 THEN '10-20%'
WHEN discount <= 0.30 THEN '20-30%'
ELSE '30%+'
END AS discount_band,
SUM(sales) AS sales,
SUM(profit) AS profit
FROM superstore
GROUP BY discount_band;

-- High Discount Orders
SELECT
order_id,
product_name,
sales,
profit,
discount
FROM superstore
WHERE discount > 0.30;

-- Discount Impact by Category
SELECT
category,
avg(discount) AS avg_discount,
SUM(profit) AS total_profit
FROM superstore
GROUP BY category;

 -- SHIPPING ANALYSIS

-- Orders by Ship Mode
SELECT
ship_mode,
COUNT(DISTINCT order_id) AS total_orders
FROM superstore
GROUP BY ship_mode;

-- Sales by Ship Mode
SELECT
ship_mode,
SUM(sales) AS total_sales
FROM superstore
GROUP BY ship_mode;

-- Profit by Ship Mode
SELECT
ship_mode,
SUM(profit) AS total_profit
FROM superstore
GROUP BY ship_mode;

-- ADVANCED SQL

-- Product Sales Ranking
SELECT
product_name,
SUM(sales) AS total_sales,
RANK() OVER(ORDER BY SUM(sales) DESC) AS sales_rank
FROM superstore
GROUP BY product_name;

-- Top Products per Category
SELECT *
FROM (
SELECT
category,
product_name,
SUM(sales) AS total_sales,
ROW_NUMBER() OVER(
PARTITION BY category
ORDER BY SUM(sales) DESC
) AS rn
FROM superstore
GROUP BY category, product_name
) t
WHERE rn <= 5;

-- Running Total Sales
SELECT
order_date,
SUM(sales) AS daily_sales,
SUM(SUM(sales)) OVER(ORDER BY order_date) AS running_sales
FROM superstore
GROUP BY order_date
ORDER BY order_date;

-- Sales Contribution by Product
SELECT
product_name,
SUM(sales) AS total_sales,
ROUND(
SUM(sales) /
(SELECT SUM(sales) FROM superstore) * 100,2
) AS contribution_percent
FROM superstore
GROUP BY product_name
ORDER BY total_sales DESC;

-- Loss Making Orders
SELECT
COUNT(DISTINCT order_id) AS loss_orders
FROM superstore
WHERE profit < 0;