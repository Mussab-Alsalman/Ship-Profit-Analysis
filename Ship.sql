


SELECT 
	* 
FROM
	ship;



SELECT 
	ship_mode,
	COUNT(*) AS Total_Orders
FROM
	ship
GROUP BY
	ship_mode
ORDER BY
	Total_Orders DESC;

-- Standerd Class Has the Greatist Mode.



SELECT 
	ship_mode,
	ship_duration_date,
	COUNT(ship_duration_date) AS Distribtion_of_Days
FROM
	ship
GROUP BY
	ship_mode,
	ship_duration_date
ORDER BY
	ship_mode,
	ship_duration_date;

-- Modes: - Same Day = in the same day, first-class 1 day to 3 days, sec-class 2 days to 5 days, standard class 4 days to 7 days.



WITH Overall AS 
(
	SELECT 
		ship_mode,
		ROUND(SUM(profit),0) AS Total_Profit
	FROM
		ship
	GROUP BY
		ship_mode
)
SELECT 
	ship_mode,
	total_profit,
	SUM(total_profit) OVER() AS Overall_Profit,
	ROUND(CAST(Total_Profit AS FLOAT) / SUM(total_profit) OVER() * 100,0) AS Profit_Pct
FROM
	Overall;

-- standard class has the highest Pct.



WITH Case_Profit AS 
(
	SELECT 
		YEAR(order_date) AS Year,
		MONTH(order_date) AS Month,
		ship_mode,
		ROUND(SUM(profit),0) AS Total_Profit
	FROM
		ship
	WHERE 
		profit < 0 
	GROUP BY
		YEAR(Order_Date),
		MONTH(order_date),
		ship_mode
) 
SELECT 
	*,
	CASE	
		WHEN Total_Profit > - 999 THEN 'Low_Negative'
		WHEN Total_Profit BETWEEN - 1999 AND  - 1000 THEN 'Medium_Negative'
		ELSE 'High_Negative'
	END AS Profit_Lost_Segment
FROM
	Case_Profit
WHERE
	CASE	
		WHEN Total_Profit > - 999 THEN 'Low_Negative'
		WHEN Total_Profit BETWEEN - 1999 AND  - 1000 THEN 'Medium_Negative'
		ELSE 'High_Negative'
	END = 'High_Negative'
ORDER BY
	Total_Profit;

-- year 2019 month 11 has the highest profit lost as standard class, overall standard class has most high_negative



SELECT
	*
FROM
(
	SELECT 
		YEAR(order_date) AS Year,
		MONTH(order_date) AS Month,
		ROUND(SUM(sales),0) AS Total_Sales,
		ROUND(SUM(profit),0) AS Total_Profit,
		ROUND((SUM(profit) / NULLIF(SUM(sales), 0)) * 100, 2) AS Profit_Sales_Ratio
	FROM
		ship
	GROUP BY
		YEAR(Order_Date),
		MONTH(order_date)
) AS Subquery
WHERE
	Profit_Sales_Ratio < 10
ORDER BY
	Profit_Sales_Ratio;

-- month 4 and 11 in both years has low profit



SELECT 
	category,
	COUNT(order_id) AS Total_Orders,
	SUM(quantity) AS Total_QTY,
	ROUND(SUM(sales),0) AS Total_Sales,
	ROUND(SUM(profit),0) AS Total_Profit,
	ROUND((SUM(profit) / NULLIF(SUM(sales), 0)) * 100, 2) AS Profit_Sales_Ratio
FROM
	ship
GROUP BY
	category;

-- the tech and furniture has low total orders but the profits diff is low in furniture and tech is high. 



SELECT 
	YEAR(order_date) AS Year,
	category,
	sub_category,
	COUNT(order_id) AS Total_Orders,
	SUM(quantity) AS Total_QTY,
	ROUND(SUM(sales),0) AS Total_Sales,
	ROUND(SUM(profit),0) AS Total_Profit,
	ROUND((SUM(profit) / NULLIF(SUM(sales), 0)) * 100, 2) AS Profit_Sales_Ratio
FROM
	ship
GROUP BY
	YEAR(order_date),
	category,
	sub_category
ORDER BY
	Profit_Sales_Ratio;

-- in the sub_category, tables in both years has negative profit, supplies in both years has negative profit, bookcases in both years has very low profit, 
-- machines in 2020 has high negative profit.

-- buttom-line: furniture has table, bookcases. tech has machines 2020 year, office supplies has supplies.


