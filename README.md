# 🛒 Retail Sales Data Analysis with MySQL

This project involves the creation and analysis of a transactional retail dataset using MySQL. It includes table setup, data cleaning, and SQL queries designed to solve real-world business problems such as customer segmentation, sales trend analysis, and category performance evaluation.

---

## 📁 Project Structure

- `sales_data` table stores transaction-level information such as customer, category, quantity, sales, etc.
- SQL queries are written to answer real business questions and generate data insights.

---

## 🔧 Technologies Used

- MySQL 8.x
- MySQL Workbench
- SQL (DDL, DML, Aggregation, CTEs, Window Functions)

---

## 📋 SQL Tasks Performed

### ✅ Table & Data Setup
- Created `retail_sales` database and `sales_data` table
- Disabled safe update mode to allow deletions
- Removed rows with `NULL` values

### 📈 Analysis Performed

1. Total unique customers  
2. Grand total of all sales  
3. Total number of records  
4. List of unique product categories  
5. Sales on a specific date (`2022-11-05`)  
6. Clothing category sales with quantity < 4 in Nov 2022  
7. Total sales and orders by category  
8. Average age of 'Beauty' category customers  
9. High-value transactions (> 1000)  
10. Total transactions by gender and category  
11. Best-selling months per year  
12. Top 5 customers by total sales  
13. Unique customers per category  
14. Orders by time shift (Morning, Afternoon, Evening)  

---

## 🗃️ Table Schema

```sql
CREATE DATABASE retail_sales;
USE retail_sales;

CREATE TABLE sales_data (
    transactions_id INTEGER PRIMARY KEY,
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
```

---

## 🧹 Safe Mode Handling & Data Cleaning

```sql
-- Disable safe update mode
SET SQL_SAFE_UPDATES = 0;

-- Delete records with missing values
DELETE FROM sales_data
WHERE 
    transactions_id IS NULL OR sale_date IS NULL OR sale_time IS NULL OR 
    customer_id IS NULL OR gender IS NULL OR age IS NULL OR 
    category IS NULL OR quantity IS NULL OR 
    price_per_unit IS NULL OR cogs IS NULL OR total_sale IS NULL;
```

---

## 🔎 Data Exploration

```sql
-- Total records
SELECT COUNT(*) FROM sales_data;

-- Unique customers
SELECT COUNT(DISTINCT customer_id) FROM sales_data;

-- Unique product categories
SELECT DISTINCT category FROM sales_data;
```

---

## 📊 Data Analysis & Business Questions

### 1. Sales made on '2022-11-05'

```sql
SELECT * FROM sales_data
WHERE sale_date = '2022-11-05';
```

---

### 2. Clothing sales with quantity < 4 in Nov-2022

```sql
SELECT * FROM sales_data
WHERE category = 'Clothing'
  AND quantity < 4
  AND YEAR(sale_date) = 2022
  AND MONTH(sale_date) = 11;
```

---

### 3. Total sales and orders by category

```sql
SELECT 
    category,
    SUM(total_sale) AS net_sale,
    COUNT(*) AS total_orders
FROM sales_data
GROUP BY category;
```

---

### 4. Average age of customers who purchased Beauty items

```sql
SELECT ROUND(AVG(age), 2) AS avg_age
FROM sales_data
WHERE category = 'Beauty';
```

---

### 5. Transactions where total_sale > 1000

```sql
SELECT * FROM sales_data
WHERE total_sale > 1000;
```

---

### 6. Total transactions by gender in each category

```sql
SELECT 
    category,
    gender,
    COUNT(*) AS total_trans
FROM sales_data
GROUP BY category, gender
ORDER BY category;
```

---

### 7. Average sale per month; find best-selling month per year

```sql
WITH monthly_sales AS (
    SELECT 
        YEAR(sale_date) AS year,
        MONTH(sale_date) AS month,
        AVG(total_sale) AS avg_sale
    FROM sales_data
    GROUP BY YEAR(sale_date), MONTH(sale_date)
),
ranked_sales AS (
    SELECT *,
        RANK() OVER (PARTITION BY year ORDER BY avg_sale DESC) AS rank
    FROM monthly_sales
)
SELECT year, month, avg_sale
FROM ranked_sales
WHERE rank = 1;
```

---

### 8. Top 5 customers by total sales

```sql
SELECT 
    customer_id,
    SUM(total_sale) AS total_sales
FROM sales_data
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;
```

---

### 9. Unique customers per category

```sql
SELECT 
    category,
    COUNT(DISTINCT customer_id) AS cnt_unique_cs
FROM sales_data
GROUP BY category;
```

---

### 10. Shift-wise order distribution (Morning <12, Afternoon 12–17, Evening >17)

```sql
WITH hourly_sales AS (
    SELECT *,
        CASE
            WHEN HOUR(sale_time) < 12 THEN 'Morning'
            WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS shift
    FROM sales_data
)
SELECT shift, COUNT(*) AS total_orders
FROM hourly_sales
GROUP BY shift;
```

---

## 📌 Findings

- **Customer Demographics**: Customers from various age groups shopped across multiple categories.
- **High-Value Purchases**: Several transactions exceeded the 1000 sales mark.
- **Sales Trends**: Identified top-performing months and customer spending patterns.
- **Top Customers**: Pinpointed high-revenue customers based on total sales.
- **Shift Insights**: Sales distribution revealed patterns across Morning, Afternoon, and Evening time windows.

---

## 📑 Reports & Outcomes

- **Sales Summary**: Category-wise totals and transaction counts
- **Trend Analysis**: Best months by year and shift-wise distribution
- **Customer Insights**: Unique customers per category and top spenders

---

## ✅ Conclusion

This project showcases the core skills of a data analyst: data exploration, data cleaning, writing analytical SQL queries, and deriving business insights. It demonstrates how SQL can be used to power real-world decision-making in a retail environment.

---

## 🧠 How to Use This Project

1. **Clone This Repository**  
2. **Run `CREATE TABLE` and populate your data**
3. **Execute the queries listed above to gain insights**
4. **Extend the queries based on your custom analysis needs**

---

## 👨‍💻 Author

**Zero Analyst (Deepak Raj)**  
Passionate about data, analysis, and building solutions that make business decisions easier.

---

## 💬 Feedback & Collaboration

If you found this useful or want to collaborate, feel free to connect. Feedback and suggestions are always welcome!

---

## 📝 License

This project is licensed under the MIT License.
