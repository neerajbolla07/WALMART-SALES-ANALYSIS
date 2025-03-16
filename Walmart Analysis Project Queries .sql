CREATE DATABASE IF NOT EXISTS walmartSales;
-- Create table
CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1)
);
-- update time of the day--------------------------------
alter table sales add time_of_day varchar(50);
update sales set time_of_day=
	(CASE
		WHEN time BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN time BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END);
-- ---------------------------------------------------
-- updating day of the date 
alter table sales add day_name varchar(25);
update sales set day_name=dayname(date);
select * from sales;
-- -----------------------------------------------
-- updating month name
alter table sales add month_name varchar(15);
update sales set month_name=monthname(date);
select * from sales;
-- ----------------------------------GENERIC QUESTIONS---------------------------------

-- ----------How many unique cities does the data have?
select count(distinct city) as num_of_cities from sales;
select distinct city from sales;

-- -----------In which city is each branch?
select distinct city,branch from sales 
order by branch asc;
-- --------------------------------PRODUCT QUESTIONS-----------------------------------

-- -----------------How many unique product lines does the data have?
select distinct product_line from sales;
select count(distinct product_line) as no_of_product_lines from sales;

-- ----------------What is the most common payment method?
select distinct payment,count(payment) from sales group by payment;

-- ----------------What is the most selling product line?
select distinct product_line,count(product_line) from sales group by product_line
order by count(product_line) desc ;

-- -----------------What is the total revenue by month?
select distinct month_name,
sum(total) from sales group by month_name
order by month_name desc;

-- ---------------What month had the largest COGS?
SELECT
	month_name AS month,
	SUM(cogs) AS cogs
FROM sales
GROUP BY month_name 
ORDER BY cogs;

-- -------------What product line had the largest revenue?
SELECT
	product_line,
	SUM(total) as total_revenue
FROM sales
GROUP BY product_line
ORDER BY total_revenue DESC;

-- -------------What is the city with the largest revenue?
SELECT
	branch,
	city,
	SUM(total) AS total_revenue
FROM sales
GROUP BY city, branch 
ORDER BY total_revenue;

-- ------------What product line had the largest VAT?
SELECT
	product_line,
	AVG(tax_pct) as avg_tax
FROM sales
GROUP BY product_line
ORDER BY avg_tax DESC;

-- -----------Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
select avg(quantity) as avg_qty from sales;
select product_line,
case when avg(quantity) > 6 then 'good'
else 'bad'
end as remark from sales
group by product_line;

-- -----------Which branch sold more products than average product sold?
select city,branch,avg(quantity) as avg_qty from sales
group by city,branch
having avg(quantity) > '5.4995';

-- -----------What is the most common product line by gender?
select gender,max(product_line) from sales group by gender;

-- -----------What is the average rating of each product line?
select product_line,avg(rating) from sales group by product_line;

-- --------------------------------SALES QUESTIONS--------------------------------------

-- -----------Number of sales made in each time of the day per weekday
select time_of_day,count(product_line) from sales where day_name='sunday' group by time_of_day;

-- --------------How many unique payment methods does the data have?
select distinct payment from sales;

-- ------------What is the most common customer type?
select max(customer_type) from sales;

-- -------------Which customer type buys the most?
select customer_type,count(customer_type) from sales group by customer_type;

-- --------------What is the gender of most of the customers?
select gender,count(gender) from sales group by gender;

-- --------------What is the gender distribution per branch?
select gender,count(gender) from sales where branch="A" group by gender;

-- --------------Which time of the day do customers give most ratings?
select time_of_day,avg(rating) from sales group by time_of_day order by avg(rating) desc;

-- --------------Which time of the day do customers give most ratings per branch?
select time_of_day,avg(rating) from sales where branch="B" 
group by time_of_day 
order by avg(rating) desc;

-- --------------Which day fo the week has the best avg ratings?
select day_name,avg(rating) from sales
 group by day_name 
 order by avg(rating) desc;

-- ----------------Which day of the week has the best average ratings per branch?
 select day_name,avg(rating) from sales
 where branch="c"
 group by day_name 
 order by avg(rating) desc;
 
 -- ------------------------REVENUE AND VAT CALCULATION---------------------------------
select
unit_price*quantity as COGS,
(unit_price*quantity)*0.05 as VAT,
unit_price*quantity + (unit_price*quantity)*0.05 as total_price,
(unit_price*quantity + (unit_price*quantity)*0.05)- unit_price*quantity as tot_profit
from sales;
-- ------------------------------------PROJECT_DONE------------------------------------