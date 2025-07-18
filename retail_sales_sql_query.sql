
CREATE DATABASE retail_sales;
USE retail_sales;

CREATE TABLE sales_data (
    transactions_id INTEGER,
    sale_date DATE,
    sale_time TIME,
    customer_id INTEGER,
    gender VARCHAR(10),
    age INTEGER,
    category VARCHAR(50),
    quantity INTEGER,
    price_per_unit INTEGER,
    cogs FLOAT,
    total_sale INTEGER
);

SELECT 
    *
FROM
    sales_data
LIMIT 10;

-- Turn off safemode in MySQL to allow DELETE operations without using key columns
SET SQL_SAFE_UPDATES = 0;

-- Find and delete rows containing NULL values
DELETE FROM sales_data 
WHERE
    transactions_id IS NULL
    OR sale_date IS NULL
    OR sale_time IS NULL
    OR customer_id IS NULL
    OR gender IS NULL
    OR age IS NULL
    OR category IS NULL
    OR quantity IS NULL
    OR price_per_unit IS NULL
    OR cogs IS NULL
    OR total_sale IS NULL;

-- How many unique customers do we have?
SELECT 
    COUNT(DISTINCT customer_id) AS total_customers
FROM
    sales_data;

-- Find the grand total price 
SELECT 
    SUM((quantity * price_per_unit)) AS total_price
FROM
    sales_data;

-- How many sales records do we have?
SELECT COUNT(*) AS total_records
FROM sales_data;

-- How many unique categories do we have?
SELECT DISTINCT
    category AS categories
FROM
    sales_data;

-- Data Analysis & Business Problems

-- Q.1: Retrieve all columns for sales made on '2022-11-05'
SELECT 
    *
FROM
    sales_data
WHERE
    sale_date = '2022-11-05';

-- Q.2: Retrieve all 'Clothing' category transactions with quantity < 4 in Nov-2022
SELECT 
    *
FROM
    sales_data
WHERE
    category = 'Clothing' AND quantity < 4
        AND YEAR(sale_date) = 2022
        AND MONTH(sale_date) = 11;

-- Q.3: Total sales (total_sale) and order count per category
SELECT 
    category,
    SUM(total_sale) AS category_wise_total_sale,
    COUNT(*) AS total_orders
FROM
    sales_data
GROUP BY category;

-- Q.4: Average age of customers who purchased 'Beauty' items
SELECT 
    ROUND(AVG(age), 2) AS avg_customrs_age
FROM
    sales_data
WHERE
    category = 'Beauty';

-- Q.5: Find all transactions with total_sale > 1000
SELECT 
    *
FROM
    sales_data
WHERE
    total_sale > 1000;

-- Q.6: Number of transactions made by each gender in each category
SELECT 
    COUNT(transactions_id) AS total_transactions,
    category,
    gender
FROM
    sales_data
GROUP BY category , gender
ORDER BY category;

-- Q.7: Average sale per month & best selling month in each year
WITH monthly_avg_sales AS (
    SELECT 
        YEAR(sale_date) AS sale_year,
        MONTH(sale_date) AS sale_month,
        AVG(total_sale) AS avg_sale
    FROM sales_data
    GROUP BY YEAR(sale_date), MONTH(sale_date)
),
ranked_months AS (
    SELECT *,
           RANK() OVER (PARTITION BY sale_year ORDER BY avg_sale DESC) AS rank_in_year
    FROM monthly_avg_sales
)
SELECT sale_year, sale_month, avg_sale
FROM ranked_months
WHERE rank_in_year = 1;

-- Q.8: Top 5 customers based on total sales
SELECT 
    customer_id, SUM(total_sale) AS total_sale
FROM
    sales_data
GROUP BY customer_id
ORDER BY total_sale DESC
LIMIT 5;

-- Q.9: Number of unique customers per category
SELECT 
    category, COUNT(DISTINCT customer_id) AS cnt_unique_cs
FROM
    sales_data
GROUP BY category;

-- Q.10: Create shifts (Morning, Afternoon, Evening) and count orders per shift
WITH hourly_sales AS (
	SELECT 
		*,
		CASE
			WHEN HOUR(sale_time) < 12 THEN 'Morning'
			WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
			ELSE 'Evening'
		END AS shift
	FROM
		sales_data
)
SELECT 
    COUNT(transactions_id) AS orders,
    shift 
FROM 
    hourly_sales
GROUP BY 
    shift;

-- End of project
