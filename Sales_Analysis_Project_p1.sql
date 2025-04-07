-- Sql Retail Sales Analysis P1

CREATE DATABASE sql_Project_P1;

--To DROP the table if the table is salsready exists
DROP TABLE IF EXISTS retail_sales;

-- Create Table  Table_name
CREATE TABLE retail_sales
(
		transactions_id	INT Primary KEY,
		sale_date	DATE,
		sale_time 	TIME,
		customer_id	INT,
		gender 		VARCHAR(15),	
		age 		INT,	
		category 	VARCHAR(15),	
		quantiy		INT,
		price_per_unit	FLOAT,
		cogs 		FLOAT,	
		total_sale 	FLOAT
);

SELECT * FROM retail_sales
WHERE 
	transactions_id is NULL or sale_date is NULL or sale_time is NULL or
	gender is NULL or category is NULL or 
	quantity is NULL or cogs is NULL or total_sale is NULL;

DELETE FROM retail_sales
WHERE
	transactions_id is NULL or sale_date is NULL or sale_time is NULL or
	gender is NULL or category is NULL or 
	quantity is NULL or cogs is NULL or total_sale is NULL;

-- Data Exploration
-- How many sales we have?
SELECT COUNT(*) as total_sales FROM retail_sales

SELECT COUNT(DISTINCT customer_id) as total_sales FROM retail_sales

SELECT DISTINCT category FROM retail_sales

-- Data Analysis & Business key Problems & Answers

-- Qns1: Write a SQL query to retrieve all columns for sales moade on "2022-11-05".

SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

-- Qns2: Write a SQl query to retrieve all transactions where the category is 'clothing' and the quantity said is more than or equal to 4 in the month of Nov- 2022.

SELECT * FROM retail_sales
WHERE 
	category = 'Clothing' and
	quantity >= 4 and 
	TO_CHAR(sale_date, 'YYYY-MM') = '2022-11';

-- Qns3: Write a SQL query to calculate the total sales for each category.

SELECT
category, 
SUM(total_sale) as net_sales,
COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1

-- Qns4: Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT ROUND(AVG(age),2 ) as average_age FROM retail_sales
WHERE category = 'Beauty';

-- Qns5: Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT * FROM retail_sales
WHERE total_sale>1000;

-- Qns6: Write a SQL query to find the total number of transactions made by each gender in each category.

SELECT category, gender, COUNT(total_sale) as total_number_of_transactions
FROM retail_sales
group by category, gender;

-- Qns7: Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.

SELECT 
       year,
       month,
    avg_sale
FROM 
(    
SELECT 
    EXTRACT(YEAR FROM sale_date) as year,
    EXTRACT(MONTH FROM sale_date) as month,
    AVG(total_sale) as avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales
GROUP BY 1, 2
) as t1
WHERE rank = 1

-- Qns8: Write a SQL query find the top 5 customers based on the highest total sales.

SELECT customer_id, SUM(total_sale) as Total_sales FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- Qns9: Write a SQL query to find number of unique customers who purchased items from each category.

SELECT  category,COUNT(DISTINCT customer_id) FROM retail_sales
group by 1;

-- Qns10: Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, evening >17).

SELECT *,
	CASE
	WHEN EXTRACT(HOUR FROM sale_time) <= 12 THEN 'Morning'
	WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
	ELSE 'Evening'
	END as shift	
FROM retail_sales
