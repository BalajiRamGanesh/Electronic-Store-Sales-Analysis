-- Check for duplicate columns

SELECT `Customer ID`, COUNT(*) FROM electronic_sales
GROUP BY `Customer ID`
HAVING COUNT(*) > 1; -- Customer ID is not unique identifier and may have duplicates

SELECT * FROM 
(
SELECT *,
ROW_NUMBER() OVER(PARTITION BY `Customer ID`, Age, Gender, `Loyalty Member`, `Product Type`, SKU, Rating, `Order Status`, `Payment Method`, `Total Price`,
`Unit Price`, Quantity, `Purchase Date`, `Shipping Type`, `Add-ons Purchased`, `Add-on Total`) AS row_num
FROM electronic_sales
) AS duplicates
WHERE row_num >1;  -- No duplicates found

-- Data Cleaning

SELECT DISTINCT Gender
FROM electronic_sales -- Requires cleaning
ORDER BY Gender;

UPDATE electronic_sales
SET Gender = (
	SELECT Gender FROM  ans 
    (
	SELECT Gender FROM electronic_sales
	GROUP BY Gender
	ORDER BY COUNT(*) DESC
	LIMIT 1
	) AS subquery
)
WHERE Gender = '#N/A';

UPDATE electronic_sales
SET `Purchase Date` = STR_TO_DATE(`Purchase Date`, '%Y-%m-%d');

ALTER TABLE electronic_sales
MODIFY `Purchase Date` DATE;

SELECT DISTINCT `Add-ons Purchased`
FROM electronic_sales
ORDER BY `Add-ons Purchased`; -- Contains null values

SELECT COUNT(*)
FROM electronic_sales
WHERE `Add-ons Purchased` = '' OR `Add-ons Purchased` IS NULL;

UPDATE electronic_sales
SET `Add-ons Purchased` = 'None'
WHERE  `Add-ons Purchased` = '' OR `Add-ons Purchased`IS NULL;

-- Adding and removing columns

ALTER TABLE electronic_sales
ADD COLUMN `Add-ons Purchased1` VARCHAR(25),
ADD COLUMN `Add-ons Purchased2` VARCHAR(25),
ADD COLUMN `Add-ons Purchased3` VARCHAR(25);

UPDATE electronic_sales
SET `Add-ons Purchased1` = TRIM(SUBSTRING_INDEX(`Add-ons Purchased`,',',1)),
`Add-ons Purchased2` = IF(LENGTH(`Add-ons Purchased`) - LENGTH(REPLACE(`Add-ons Purchased`,',','')) >= 1,
TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(`Add-ons Purchased`,',',2),',',-1)),
'None'),
`Add-ons Purchased3` = IF(LENGTH(`Add-ons Purchased`) - LENGTH(REPLACE(`Add-ons Purchased`,',','')) >= 2,
TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(`Add-ons Purchased`,',',3),',',-1)),
'None');

ALTER TABLE electronic_sales
DROP COLUMN `Add-ons Purchased`;

SELECT * FROM electronic_sales; -- Export this data to power bi

-- Data Analysis

		-- KPIs
SELECT SUM(`Total Price`) + SUM(`Add-on Total`) AS Total_Sales,
COUNT(*) AS Total_Orders,
SUM(Quantity) AS Total_Quantitiy,
(SUM(`Total Price`) + SUM(`Add-on Total`))/COUNT(*) AS AOV
FROM electronic_sales
WHERE `Order Status` = 'Completed';       

		-- Sales by Product Type
SELECT `Product Type`,
SUM(`Total Price`) + SUM(`Add-on Total`) AS Sales
FROM electronic_sales
WHERE `Order Status` = 'Completed'
GROUP BY `Product Type`
ORDER BY Sales DESC; 

		-- Orders by Product Type
SELECT `Product Type`, COUNT(*) AS orders
FROM electronic_sales
WHERE `Order Status` = 'Completed'
GROUP BY `Product Type`
ORDER BY orders DESC; 

		-- Sales by Shipping Type
SELECT `Shipping Type`,
SUM(`Total Price`) + SUM(`Add-on Total`) AS Sales
FROM electronic_sales
WHERE `Order Status` = 'Completed'
GROUP BY `Shipping Type`
ORDER BY Sales DESC; 

		-- Orders by Payment Type
SELECT `Payment Method`, COUNT(*) AS orders
FROM electronic_sales
WHERE `Order Status` = 'Completed'
GROUP BY `Payment Method`
ORDER BY orders DESC;

		-- AOV by Purchase Date
SELECT MONTH(`Purchase Date`),YEAR(`Purchase Date`),
(SUM(`Total Price`) + SUM(`Add-on Total`))/COUNT(*) AS AOV
FROM electronic_sales
WHERE `Order Status` = 'Completed'
GROUP BY MONTH(`Purchase Date`),YEAR(`Purchase Date`)
ORDER BY YEAR(`Purchase Date`),MONTH(`Purchase Date`);

SELECT `Purchase Date`,
(SUM(`Total Price`) + SUM(`Add-on Total`))/COUNT(*) AS AOV
FROM electronic_sales
WHERE `Order Status` = 'Completed'
GROUP BY `Purchase Date`
ORDER BY `Purchase Date`;

		-- Add-ons Purchased 
SELECT add_on_values, COUNT(*) AS orders
FROM (
  SELECT `Add-ons Purchased1` AS add_on_values  FROM electronic_sales WHERE `Order Status` = 'Completed'
  UNION ALL
  SELECT `Add-ons Purchased2` FROM electronic_sales WHERE `Order Status` = 'Completed'
  UNION ALL
  SELECT `Add-ons Purchased3` FROM electronic_sales WHERE `Order Status` = 'Completed'
) AS all_addons
WHERE add_on_values <> 'None'
GROUP BY add_on_values
ORDER BY orders DESC;

		-- Sales by Age
SELECT Age,
SUM(`Total Price`) + SUM(`Add-on Total`) AS sales
FROM electronic_sales
WHERE `Order Status` = 'Completed'
GROUP BY Age
ORDER BY Age;

SELECT 
CASE
	WHEN Age BETWEEN 18 AND 27 THEN '18-27'
    WHEN Age BETWEEN 28 AND 37 THEN '28-37'
    WHEN Age BETWEEN 38 AND 47 THEN '38-47'
    WHEN Age BETWEEN 48 AND 57 THEN '48-57'
    WHEN Age BETWEEN 58 AND 67 THEN '58-67'
    WHEN Age BETWEEN 68 AND 77 THEN '68-77'
    WHEN Age BETWEEN 78 AND 87 THEN '78-87'
END AS Age_group,
SUM(`Total Price`) + SUM(`Add-on Total`) AS sales
FROM electronic_sales
WHERE `Order Status` = 'Completed'
GROUP BY Age_group
ORDER BY Age_group;

		-- AOV by Gender
SELECT `Gender`, (SUM(`Total Price`) + SUM(`Add-on Total`))/COUNT(*) AS AOV
FROM electronic_sales
WHERE `Order Status` = 'Completed'
GROUP BY `Gender`;
        
        -- Add-Ons orders by Loyalty member
SELECT `Loyalty Member`,
SUM(CASE
	WHEN `Add-on Total` > 0 THEN 1
	ELSE 0
END) AS add_ons_orders
FROM electronic_sales
WHERE `Order Status` = 'Completed'
GROUP BY `Loyalty Member` ;

		-- Ratings by Product Type
SELECT `Product Type`, AVG(Rating) AS Avg_Rating
FROM electronic_sales
WHERE `Order Status` = 'Completed'
GROUP BY `Product Type`
ORDER BY Avg_Rating DESC;

		-- Sales by Loyalty Member
SELECT `Loyalty Member`,
SUM(`Total Price`) + SUM(`Add-on Total`) AS sales,
(SUM(`Total Price`) + SUM(`Add-on Total`))/(
	SELECT SUM(`Total Price`) + SUM(`Add-on Total`) FROM electronic_sales
    WHERE `Order Status` = 'Completed'
    )*100 AS sales_percent
FROM electronic_sales
WHERE `Order Status` = 'Completed'
GROUP BY `Loyalty Member`;

		-- Orders by Customer Type
SELECT Customer_Type,
SUM(orders) AS customer_orders,
SUM(orders)/(SELECT COUNT(*) FROM electronic_sales WHERE `Order Status` = 'Completed')*100 AS customer_orders_percentage
FROM
(
SELECT `Customer ID`,
COUNT(*) AS orders,
CASE
	WHEN COUNT(*) > 1 THEN 'Returning'
    ELSE 'New'
    END AS Customer_Type
FROM electronic_sales
WHERE `Order Status` = 'Completed'
GROUP BY `Customer ID`
) AS customer_type_table
GROUP BY Customer_Type;



