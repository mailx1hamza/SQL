
SELECT *
FROM pizza_sales_
;

-- KPI's REQUIREMENT

-- TOTAL REVENUE

SELECT SUM(total_price) 'Total Revenue'
FROM pizza_sales_
;

-- AVERAGE ORDER VALUE

SELECT SUM(total_price) / COUNT (DISTINCT order_id) 'Avg Order Value'
FROM pizza_sales_
;

-- TOTAL PIZZA's SOLD

SELECT SUM(quantity) 'Total Pizza Sold'
FROM pizza_sales_
;

-- TOTAL ORDERS

SELECT COUNT(DISTINCT order_id) 'Total Orders'
FROM pizza_sales_
;

-- AVERAGE PIZZA's PER ORDER

SELECT CAST
		(CAST(SUM(quantity) AS DECIMAL(10,2)) / CAST(COUNT(DISTINCT order_id) AS DECIMAL(10,2)) 
		AS DECIMAL(10,2)) 'Average Pizza Per Order'
FROM pizza_sales_
;



-- CHART's REQUIREMENT

--DAILY TREND FOR TOTAL ORDERS

SELECT DATENAME(DW, order_date) 'Order Day', COUNT(DISTINCT order_id) 'Total Orders'
FROM pizza_sales_
GROUP BY DATENAME(DW, order_date)
ORDER BY 'Total Orders' DESC
;

--MONTHLY TREND FOR TOTAL ORDERS IN THE MONTH OF JANUARY

SELECT DATENAME(MONTH, order_date) 'Month Name', COUNT(DISTINCT order_id) 'Total Orders'
FROM pizza_sales_
GROUP BY DATENAME(MONTH, order_date)
ORDER BY 'Total Orders' DESC
;

-- PERCENTAGE OF SALES BY PIZZA CATEGORY

SELECT pizza_category, CAST(SUM(total_price) AS DECIMAL(10,2)) 'Total Sales',
	CAST(SUM(total_price) * 100 /
	(
		SELECT SUM(total_price)
		FROM pizza_sales_
		WHERE MONTH(order_date) = 1
	) AS DECIMAL (10,2)) PCT
FROM pizza_sales_
WHERE MONTH(order_date) = 1
GROUP BY pizza_category
ORDER BY PCT DESC
;

-- PERCENTAGE OF SALES BY PIZZA SIZE

SELECT pizza_size, CAST(SUM(total_price) AS DECIMAL (10,2)) 'Total Price', CAST(SUM(total_price) * 100 /
	(
SELECT SUM(total_price)
FROM pizza_sales_
	) AS DECIMAL (10,2)) PCT
FROM pizza_sales_
GROUP BY pizza_size
ORDER BY PCT DESC
;


-- TOTAL PIZZA SOLD BY PIZZA CATEGORY

SELECT pizza_category,SUM(total_price) 'Total Price'
FROM pizza_sales_
GROUP BY pizza_category
ORDER BY 'Total Price' ASC
;


-- TOP 5 BEST SELLER's BY REVENUE, TOTAL QUANTITY & TOTAL ORDERS

SELECT TOP 5 pizza_name, SUM(total_price) 'Total Revenue'
FROM pizza_sales_
GROUP BY pizza_name
ORDER BY 'Total Revenue' DESC
;

SELECT TOP 5 pizza_name, SUM(quantity) 'Total Quantity'
FROM pizza_sales_
GROUP BY pizza_name
ORDER BY 'Total Quantity' DESC
;

SELECT TOP 5 pizza_name, COUNT(DISTINCT order_id) 'Total Orders'
FROM pizza_sales_
GROUP BY pizza_name
ORDER BY 'Total Orders' DESC
;


-- BOTTOM 5 SELLER's BY REVENUE, TOTAL QUANTITY & TOTAL ORDERS

SELECT TOP 5 pizza_name, SUM(total_price) 'Total Revenue'
FROM pizza_sales_
GROUP BY pizza_name
ORDER BY 'Total Revenue' ASC
;

SELECT TOP 5 pizza_name, SUM(quantity) 'Total Quantity'
FROM pizza_sales_
GROUP BY pizza_name
ORDER BY 'Total Quantity' ASC
;

SELECT TOP 5 pizza_name, COUNT(DISTINCT order_id) 'Total Orders'
FROM pizza_sales_
GROUP BY pizza_name
ORDER BY 'Total Orders' ASC
;