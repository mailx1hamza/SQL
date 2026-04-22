
-- WHO ARE OUR MOST VALUABLE MEMBERS AND WHAT DO THEY HAVE IN COMMON
-- Customer Segmentation By value... Top 10% CLV



WITH ranked_customers AS 
(
	SELECT 
		Loyalty_Number, Country, Education, Loyalty_Card, CLV,
		NTILE(10) OVER (ORDER BY CLV DESC) AS Decile
	FROM customer_loyalty_history
	WHERE CLV IS NOT NULL
)
	SELECT 
		Country, Education, Loyalty_Card, COUNT(*) AS customers_in_top_10pct,
		ROUND(AVG(CLV), 2) AS avg_clv,
		ROUND(SUM(CLV), 2) AS total_clv
	FROM ranked_customers
	WHERE Decile = 1
	GROUP BY Country, Education, Loyalty_Card
	ORDER BY total_clv DESC
	;




-- DO HIGHER TIERS ACTUALLY FLY MORE?
-- DOES TIER MATCH BEHAVIOR?



SELECT
	h.Loyalty_Card, COUNT(DISTINCT h.Loyalty_Number) AS Customers,
	ROUND(AVG(a.Total_Flights), 2) AS avg_flight_per_month,
	ROUND(AVG(a.Distance), 0) AS avg_distance_per_month,
	ROUND(AVG(a.Points_Accumulated), 0) AS avg_points_earned_per_month
FROM customer_loyalty_history h
JOIN customer_flight_activity a
	ON h.Loyalty_Number = a.Loyalty_Number
GROUP BY h.Loyalty_Card
ORDER BY avg_flight_per_month DESC
;



-- ARE WE LOSING CUSTOMERS FROM SPECIFIC SIGN-UP PERIOD OR CHANNELS?
-- CHURN AND TENURE ANALYSIS



SELECT 
	Enrollment_Year, Enrollment_Type, COUNT(*) AS total_enrolled,
	SUM(CASE WHEN cancellation_year IS NOT NULL THEN 1 ELSE 0 END) AS cancelled,
	ROUND(
		100.0 * SUM(CASE WHEN cancellation_year IS NOT NULL THEN 1 ELSE 0 END) / COUNT(*), 2
		) AS churn_pct,
	ROUND(
		AVG(
			CASE
				WHEN cancellation_year IS NOT NULL
				THEN (cancellation_year - Enrollment_year) * 12 + (cancellation_month - Enrollment_month)
				ELSE NULL
			END
		), 1
	) AS avg_tenure_months

FROM customer_loyalty_history
GROUP BY Enrollment_Year, Enrollment_Type
ORDER BY Enrollment_Year, Enrollment_Type
;



-- HOW MUCH DOES THE AIRLINE OWE MEMBERS IN UNREDEEMED POINTS
-- MONTHLY POINT LIABILITY + DOLLAR COST



WITH monthly_points AS (
SELECT 
	Year, Month, SUM(Points_Accumulated - Points_Redeemed) AS net_points_issued,
	SUM(Dollar_Cost_Points_Redeemed) AS dollars_redeemed
FROM customer_flight_activity
GROUP BY Year, Month
)
SELECT 
	Year, Month, net_points_issued,
	SUM(net_points_issued) OVER (ORDER BY Year, Month) AS cummulative_outstanding_points,
	dollars_redeemed
FROM  monthly_points
ORDER BY Year, Month
;


-- WHO HOARDS POINTS AND WHO SPEND THEM?
-- REDEMPTION HABITS BY DEMOGRAPHICS


WITH customer_redemption AS (
	SELECT 
		h.Loyalty_Number, h.Salary, h.Marital_Status,
		SUM(a.Points_Accumulated) AS total_earned,
		SUM(a.Points_Redeemed) AS total_redeemed
	FROM customer_loyalty_history h
	LEFT JOIN customer_flight_activity a
	ON h.Loyalty_Number = a.Loyalty_Number
	GROUP BY h.Loyalty_Number, h.Salary, h.Marital_Status
),
salary_bands AS (
	SELECT *,
		CASE 
			WHEN Salary <50000 THEN 'Under 50K'
			WHEN Salary BETWEEN 50000 AND 99999 THEN '50K-100K'
			WHEN Salary BETWEEN 100000 AND 149999 THEN '100K-150K'
			WHEN Salary >= 150000 THEN '150K+'
			ELSE 'UNKNOWN'
		END AS salary_band,
		CASE
			WHEN total_earned = 0 THEN NULL
			ELSE ROUND(100.0 * total_redeemed / total_earned, 2)
		END AS redemption_pct
	FROM customer_redemption
)
SELECT 
	salary_band, Marital_Status, COUNT(*) AS customers,
	ROUND(AVG(redemption_pct), 2) AS avg_redemption_pct
FROM salary_bands
WHERE redemption_pct IS NOT NULL
GROUP BY salary_band, Marital_Status
ORDER BY salary_band, avg_redemption_pct DESC
;



-- WHICH VALUABLE CUSTOMERS ARE ABOUT TO CHURN BUT WE CAN STILL SAVE?
-- HIGH VALUE CHURN RISK FLAG



WITH clv_rank AS (
	SELECT 
		Loyalty_Number, CLV, 
		NTILE(5) OVER (ORDER BY CLV DESC) AS clv_quintile
	FROM customer_loyalty_history
	WHERE Cancellation_Year IS NULL
),
last_flight AS (
	SELECT 
		Loyalty_Number, 
		MAX(Year * 12 + Month) AS last_active_period
	FROM customer_flight_activity
	GROUP BY Loyalty_Number
),
current_period AS (
	SELECT 
		MAX(Year * 12 + Month) AS recent_period
	FROM customer_flight_activity
)
SELECT 
	h.Loyalty_Number, h.Loyalty_Card, h.CLV, h.Country, 
	cp.recent_period - lf.last_active_period AS month_since_last_flight
FROM customer_loyalty_history h
JOIN clv_rank cr 
	ON
	h.Loyalty_Number = cr.Loyalty_Number
JOIN last_flight lf
	ON 
	h.Loyalty_Number = lf.Loyalty_Number
CROSS JOIN current_period cp
WHERE cr.clv_quintile = 1
	AND h.Cancellation_Year IS NULL
	AND (cp.recent_period - lf.last_active_period) >= 3
ORDER BY h.CLV DESC
;



-- WHICH REGIONS MAKE MONEY FOR THE LOYALTY PROGRAM AND WHICH LOSE MONEY?
-- GEOGRAPHIC ROI MAP



WITH customer_profit AS (
	SELECT 
		h.Loyalty_Number, h.Province, h.City, 
		SUM(a.Distance * 0.12) AS est_revenue,  -- assumption: $0.12 per mile
		SUM(a.Dollar_Cost_Points_Redeemed) AS point_cost
	FROM customer_loyalty_history h
	JOIN customer_flight_activity a
		ON
		h.Loyalty_Number = a.Loyalty_Number
	GROUP BY h.Loyalty_Number, h.Province, h.City
)
SELECT 
	Province, City, COUNT(*) AS customers,
	ROUND(SUM(est_revenue), 2) AS total_est_revenue,
	ROUND(SUM(point_cost), 2) AS total_point_cost,
	ROUND(SUM(est_revenue - point_cost), 2) AS estimated_profit,
	ROUND(AVG(est_revenue - point_cost), 2) AS avg_profit_per_customer
FROM customer_profit
GROUP BY Province, City
ORDER BY estimated_profit DESC
;