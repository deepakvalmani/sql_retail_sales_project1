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

-- find and delete the null values
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
    OR total_sale IS NULL
;

-- how many unique customers do we have
SELECT 
    COUNT(DISTINCT customer_id) AS total_customers
FROM
    sales_data;

-- find the grand total price 
SELECT 
    SUM((quantity * price_per_unit)) AS total_price
FROM
    sales_data;

-- how many sales recods we have ?
SELECT COUNT(*) AS total_records
FROM sales_data;

-- how many unique categories we have?
SELECT DISTINCT
    category AS categories
FROM
    sales_data;

-- Data Analysis & Business Problems

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'
SELECT 
    *
FROM
    sales_data
WHERE
    sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is less than 4 in the month of Nov-2022
SELECT 
    *
FROM
    sales_data
WHERE
    category = 'Clothing' AND quantity < 4
        AND YEAR(sale_date) = 2022
        AND MONTH(sale_date) = 11;

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT 
    category,
    SUM(total_sale) AS category_wise_total_sale,
    COUNT(*) AS total_orders
FROM
    sales_data
GROUP BY category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT 
    ROUND(AVG(age), 2) AS avg_customrs_age
FROM
    sales_data
WHERE
    category = 'Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT 
    *
FROM
    sales_data
WHERE
    total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT 
    COUNT(transactions_id) AS total_transactions,
    category,
    gender
FROM
    sales_data
GROUP BY category , gender
ORDER BY category;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.
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

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales.
SELECT 
    customer_id, SUM(total_sale) AS total_sale
FROM
    sales_data
GROUP BY customer_id
ORDER BY total_sale DESC
LIMIT 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT 
    category, COUNT(DISTINCT customer_id) AS cnt_unique_cs
FROM
    sales_data
GROUP BY category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

WITH hourly_sales AS(
	SELECT 
		*,
		CASE
			WHEN HOUR(sale_time) < 12 THEN 'Morning'
			WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
			ELSE 'Evening'
		END AS shift
	FROM
		sales_data)
        
SELECT COUNT(transactions_id), shift FROM hourly_sales
GROUP BY shift;

-- End of project


