use wallmart_sales;
select * from sales;
use wallmart_sales;
alter table sales rename column prodect_line to product_line;
alter table sales rename column payement to payment_method;
-- --------------------------------------------------------------------------------------------------------------------------
--                               		Feature Engineering

/*Add a new column named time_of_day to give insight of sales in the Morning, Afternoon and Evening.
 This will help answer the question on which part of the day most sales are made.*/
 
 alter table Sales add column time_of_day varchar(10);

update sales 
set time_of_day = case
when hour(time) between 6 and 11 then'MORNING'
WHEN HOUR(TIME) BETWEEN 12 AND 17 THEN 'AFTERNOON'
WHEN HOUR(TIME) BETWEEN 18 AND 21 THEN 'EVENING'
ELSE 'NIGHT'
END;

 
/*Add a new column named day_name that contains the extracted days of the week on which the given 
transaction took place (Mon, Tue, Wed, Thur, Fri). This will help answer the question on which week 
of the day each branch is busiest.*/

ALTER TABLE SALES ADD COLUMN DAY_NAME VARCHAR(10);

UPDATE SALES 
SET DAY_NAME = DAYNAME(DATE);

ALTER TABLE SALES RENAME COLUMN DAY_NAME TO DAY ;

/*Add a new column named month_name that contains the extracted months of
 the year on which the given transaction took place (Jan, Feb, Mar). 
 Help determine which month of the year has the most sales and profit.*/

ALTER TABLE SALES ADD COLUMN MONTH VARCHAR(10);

UPDATE sales SET
MONTH=MONTHNAME(DATE);

-- ---------------------------------------------------------------------------------------------------------------------------
-- 		Business Questions To Answer

-- 	                                                    Generic Question

-- How many unique cities does the data have?
select distinct city ,count( city) from sales group by city ;

-- In which city is each branch?
select distinct city ,branch  from sales ;
-- ---------------------------------------------------------------------
--                  PRODUCT
-- How many unique product lines does the data have?
select distinct product_line from sales;

select count(distinct product_line) from sales ;

-- What is the most common payment method?
SELECT 
    payment_method,
    COUNT(payment_method) AS usage_of_payment_method
FROM
    sales
GROUP BY payment_method
ORDER BY usage_of_payment_method DESC
LIMIT 1;

-- What is the most selling product line?
SELECT 
    product_line, COUNT(quantity) AS QUANTITY_SOLD
FROM
    sales
GROUP BY product_line
ORDER BY QUANTITY_SOLD DESC
LIMIT 1; 

-- What is the total revenue by month?
SELECT 
    MONTH, SUM(TOTAL) AS TOTAL_REVENUE
FROM
    SALES
GROUP BY MONTH;

-- What month had the largest COGS?

SELECT 
    MONTH, MAX(COGS) AS LARGEST_COGS
FROM
    SALES
GROUP BY month
ORDER BY LARGEST_COGS DESC
LIMIT 1;

-- What product line had the largest revenue?

SELECT 
    PRODUCT_LINE, SUM(TOTAL) AS LARGEST_REVENUE
FROM
    SALES
GROUP BY PRODUCT_LINE
ORDER BY LARGEST_REVENUE DESC
LIMIT 1;

-- What is the city with the largest revenue?
SELECT 
    CITY, MAX(TOTAL) AS LARGEST_REVENUE
FROM
    SALES
GROUP BY CITY
ORDER BY LARGEST_REVENUE DESC
LIMIT 1;

-- What product line had the largest VAT?
SELECT 
    PRODUCT_LINE, MAX(VAT) AS LARGEST_VAT
FROM
    SALES
GROUP BY PRODUCT_LINE
ORDER BY LARGEST_VAT DESC
LIMIT 1;

/* Fetch each product line and add a column to those product line showing "Good", "Bad". 
Good if its greater than average sales */
ALTER TABLE SALES ADD COLUMN GOOD_BAD VARCHAR(5);

WITH AVG_QUANTITY AS (
SELECT AVG(QUANTITY) AS AVG_QTY FROM SALES)
UPDATE SALES SET
GOOD_BAD = CASE 
WHEN QUANTITY >(SELECT AVG_QTY FROM AVG_QUANTITY )
THEN 'GOOD' 
ELSE 'BAD'
END;


-- Which branch sold more products than average product sold?

SELECT 
    BRANCH, SUM(QUANTITY) AS AVG_QTY_SOLD
FROM
    SALES
GROUP BY BRANCH
HAVING AVG_QTY_SOLD > (SELECT 
        AVG(QUANTITY)
    FROM
        SALES) ORDER BY AVG_QTY_SOLD DESC LIMIT 1 ;
        
-- What is the most common product line by gender?
SELECT 
    GENDER, PRODUCT_LINE, SUM(QUANTITY) TOTAL_SALES
FROM
    SALES
    
GROUP BY GENDER , PRODUCT_LINE
ORDER BY TOTAL_SALES DESC;


-- What is the average rating of each product line?
SELECT 
    PRODUCT_LINE, AVG(RATING) AS AVG_RATING
FROM
    SALES
GROUP BY PRODUCT_LINE
ORDER BY AVG_RATING DESC;
-- --------------------------------------------------------------------------------------------------------------------------
-- 															Sales

-- Number of sales made in each time of the day per weekday
SELECT 
    TIME_OF_DAY, SUM(QUANTITY)
FROM
    SALES
WHERE
    DAY IN ('MONDAY' , 'TUESDAY',
        'WEDNESDAY',
        'THURSDAY',
        'FRIDAY')
GROUP BY TIME_OF_DAY;
-- 	Which of the customer types brings the most revenue?
 SELECT 
    CUSTOMER_TYPE, SUM(TOTAL) AS TOTAL_REVENUE
FROM
    SALES
GROUP BY CUSTOMER_TYPE
ORDER BY TOTAL_REVENUE DESC;
-- Which city has the largest tax percent/ VAT (Value Added Tax)?
SELECT 
    CITY, MAX(VAT) LARGEST_TAX
FROM
    SALES
GROUP BY CITY
ORDER BY LARGEST_TAX DESC
LIMIT 1;
-- Which customer type pays the most in VAT?
SELECT 
    CUSTOMER_TYPE, MAX(VAT) LARGEST_TAX
FROM
    SALES
GROUP BY CUSTOMER_TYPE
ORDER BY LARGEST_TAX DESC
LIMIT 1;
-- --------------------------------------------------------------------------------------------------------------------------
-- 														Customer
-- How many unique customer types does the data have?
SELECT 
    COUNT(DISTINCT CUSTOMER_TYPE) AS UNIQUE_CUSTOMER_TYPES
FROM
    SALES;
-- How many unique payment methods does the data have?
SELECT 
    COUNT(DISTINCT PAYMENT_METHOD) AS UNIQUE_PAYMENT_METHODS
FROM
    SALES;
-- What is the most common customer type?
SELECT 
    CUSTOMER_TYPE, COUNT(CUSTOMER_TYPE) AS NO_OF_CUSTOMER
FROM
    SALES
GROUP BY CUSTOMER_TYPE
ORDER BY NO_OF_CUSTOMER;
-- Which customer type buys the most?
SELECT 
    CUSTOMER_TYPE,
    SUM(TOTAL) AS TOTAL_REVENUE,
    SUM(QUANTITY) AS TOTAL_SALES
FROM
    SALES
GROUP BY CUSTOMER_TYPE
ORDER BY TOTAL_SALES DESC , TOTAL_REVENUE DESC;
-- What is the gender of most of the customers?
SELECT 
    GENDER, COUNT(GENDER) AS NO_OF_CUSTOMER
FROM
    SALES
GROUP BY GENDER
ORDER BY NO_OF_CUSTOMER DESC;
-- What is the gender distribution per branch?
SELECT 
    BRANCH, GENDER, COUNT(GENDER) AS NO_OF_CUSTOMER
FROM
    SALES
GROUP BY BRANCH , GENDER
ORDER BY NO_OF_CUSTOMER DESC;
-- Which time of the day do customers give most ratings?
SELECT 
    TIME_OF_DAY, COUNT(RATING)
FROM
    SALES
GROUP BY TIME_OF_DAY;
-- Which time of the day do customers give most ratings per branch?
SELECT 
    BRANCH, TIME_OF_DAY, COUNT(RATING)
FROM
    SALES
GROUP BY TIME_OF_DAY , BRANCH;
-- Which day fo the week has the best avg ratings?
SELECT 
    DAY, AVG(RATING) AS AVG_RATING
FROM
    SALES
GROUP BY DAY
ORDER BY AVG_RATING DESC;
-- Which day of the week has the best average ratings per branch?

SELECT 
    BRANCH, DAY, AVG(RATING) AS AVG_RATING
FROM
    SALES
GROUP BY BRANCH , DAY
ORDER BY AVG_RATING DESC;





