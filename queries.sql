#1
select 
count(customer_id) as customers_count
from customers;

#2
SELECT
CONCAT(first_name, ' ', last_name) AS seller,
COUNT(sales.sales_person_id) AS operations,
FLOOR(SUM(sales.quantity * products.price)) AS income
FROM sales
LEFT JOIN employees ON employees.employee_id = sales.sales_person_id
LEFT JOIN products ON products.product_id = sales.product_id
GROUP BY 1
ORDER BY 3 DESC
LIMIT 10;

#3
WITH 
avgincomeall AS
(
SELECT
AVG(sales.quantity * products.price) AS avg_all
FROM sales
LEFT JOIN products ON products.product_id = sales.product_id
)
SELECT
CONCAT(first_name, ' ', last_name) AS seller,
FLOOR(AVG(sales.quantity * products.price)) AS average_income
FROM sales
LEFT JOIN employees ON employees.employee_id = sales.sales_person_id
LEFT JOIN products ON products.product_id = sales.product_id
GROUP BY 1
HAVING AVG(sales.quantity * products.price) < (SELECT * FROM avgincomeall)
ORDER BY 2;

#4
SELECT
CONCAT(employees.first_name, ' ', employees.last_name) AS seller,
TO_CHAR(sales.sale_date, 'day') AS day_of_week,
FLOOR(SUM(sales.quantity * products.price)) AS income
FROM sales
LEFT JOIN employees ON employees.employee_id = sales.sales_person_id
LEFT JOIN products ON products.product_id = sales.product_id
GROUP BY EXTRACT(ISODOW FROM sales.sale_date), 1, 2 
ORDER BY EXTRACT(ISODOW FROM sales.sale_date), 1;

#5
SELECT
(
CASE
WHEN customers.age BETWEEN 16 AND 25 THEN '16-25'
WHEN customers.age BETWEEN 26 AND 40 THEN '26-40'
WHEN customers.age > 40 THEN '40+'
END 
) AS age_category,
COUNT (*) AS age_count
FROM customers
Group by 1
order by 1;

#6
SELECT
TO_CHAR(sales.sale_date, 'YYYY-MM') AS selling_month,
COUNT(DISTINCT sales.customer_id) AS total_customers,
FLOOR(SUM(sales.quantity * products.price)) AS income
FROM sales 
LEFT JOIN customers ON sales.customer_id = customers.customer_id 
LEFT JOIN products ON sales.product_id = products.product_id 
LEFT JOIN employees ON sales.sales_person_id = employees.employee_id 
GROUP BY 1
ORDER BY 1;

#7
SELECT 
DISTINCT ON (customers.customer_id) 
customers.first_name || ' ' || customers.last_name AS customer,
sales.sale_date AS sale_date, 
employees.first_name || ' ' || employees.last_name AS seller 
FROM sales 
LEFT JOIN customers ON sales.customer_id = customers.customer_id 
LEFT JOIN products ON sales.product_id = products.product_id 
LEFT JOIN employees ON sales.sales_person_id = employees.employee_id 
WHERE products.price = 0 
ORDER BY customers.customer_id, sales.sale_date;
