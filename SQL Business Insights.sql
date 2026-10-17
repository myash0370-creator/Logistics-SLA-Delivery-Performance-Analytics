CREATE DATABASE logistics_analytics_sql; -- Cretae Database 
USE logistics_analytics_sql;

-- Check Data
SELECT COUNT(*) AS total_rows
FROM delivery_logistics_cleaned;
SELECT *FROM delivery_logistics_cleaned
LIMIT 10;

-- Logistics SLA & Delivery Performance Analytics — SQL Business Insights

-- Q1: Delivery Status Distribution Analysis
SELECT  delivery_status, COUNT(*)
FROM delivery_logistics_cleaned
GROUP BY delivery_status;

-- Q2: Delivery Partner Performance Analysis
SELECT delivery_partner, COUNT(*) AS total_deliveries
FROM delivery_logistics_cleaned
GROUP BY delivery_partner
ORDER BY total_deliveries DESC;

-- Q3: Delivery Partner Efficiency Analysis
SELECT delivery_partner, AVG(delivery_cost) AS AVG_COST
FROM delivery_logistics_cleaned
GROUP BY delivery_partner
ORDER BY AVG_COST DESC;

-- Q4: Delivery Partner Cost Efficiency Analysis
SELECT delivery_partner, AVG(cost_per_km) AS AVG_COST_PER_KM
FROM delivery_logistics_cleaned
GROUP BY delivery_partner
ORDER BY AVG_COST_PER_KM DESC;

-- Q5: Vehicle Type Cost Analysis
SELECT vehicle_type, AVG(delivery_cost) AS AVG_VEHICLE_COST
FROM delivery_logistics_cleaned
GROUP BY vehicle_type
ORDER BY AVG_VEHICLE_COST DESC;

-- Q6: Package Type Cost Analysis
SELECT package_type, AVG(delivery_cost) AS AVG_PACKAGE_COST
FROM delivery_logistics_cleaned
GROUP BY package_type
ORDER BY  AVG_PACKAGE_COST DESC;

-- Q7: Delivery Mode Delay Analysis
SELECT delivery_mode, COUNT(*) AS total_deliveries,
(SUM(CASE WHEN `delayed` = 'yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS delay_percentage
FROM delivery_logistics_cleaned
GROUP BY delivery_mode;

-- Q8: Failed Deliveries by Delivery Partner
SELECT delivery_partner, COUNT(*) AS total_deliveries,
SUM(CASE WHEN delivery_status = 'failed' THEN 1 ELSE 0 END)  AS failed_deliveries,
SUM(CASE WHEN delivery_status = 'failed' THEN 1 ELSE 0 END) * 100 / COUNT(*) AS failure_percentage
FROM delivery_logistics_cleaned
GROUP BY delivery_partner
ORDER BY failure_percentage DESC;

-- Q9: Delivery Rating Analysis by Delivery Partner
SELECT delivery_partner, AVG(delivery_rating) AS avg_delivery_rating
FROM delivery_logistics_cleaned
GROUP BY delivery_partner
ORDER BY avg_delivery_rating ASC;

-- Q10: Actual vs Expected Delivery Time
SELECT delivery_partner,
AVG(delivery_time_hours) AS AVG_DELIVERY_TIME,
AVG(expected_time_hours) AS AVG_EXPECTED_TIME
FROM delivery_logistics_cleaned
GROUP BY delivery_partner;                                                   

-- Q11: SLA Compliance Analysis
SELECT delivery_partner, COUNT(*) AS total_deliveries,
SUM(CASE WHEN delivery_time_hours <= expected_time_hours THEN 1 ELSE 0 END) AS ON_TIME_DELIVERIES,
SUM(CASE WHEN delivery_time_hours > expected_time_hours THEN 1 ELSE 0 END) AS LATE_DELIVERIES,
SUM(CASE WHEN delivery_time_hours <= expected_time_hours THEN 1 ELSE 0 END) * 100.0 / count(*) AS SLA_Compliance_Percentage
FROM delivery_logistics_cleaned
GROUP BY delivery_partner 
ORDER BY SLA_Compliance_Percentage DESC;

-- Q12: High-Cost Delayed Deliveries
SELECT
    delivery_id, delivery_partner, delivery_mode, distance_km, delivery_cost, `delayed`
FROM delivery_logistics_cleaned
WHERE `delayed` = 'yes'
  AND delivery_cost > (
      SELECT AVG(delivery_cost)
      FROM delivery_logistics_cleaned)
ORDER BY delivery_cost DESC;
SELECT
    delivery_partner,
    COUNT(*) AS total_deliveries,
    SUM(CASE
        WHEN delivery_time_hours <= expected_time_hours THEN 1
        ELSE 0 END) * 100.0 / COUNT(*) AS sla_compliance_percentage
FROM delivery_logistics_cleaned
GROUP BY delivery_partner
ORDER BY sla_compliance_percentage DESC;
-- Q13: Region-wise Delivery Cost Analysis
SELECT region, AVG(delivery_cost) AS avg_delivery_cost
FROM delivery_logistics_cleaned
GROUP BY region
ORDER BY avg_delivery_cost DESC;

-- Q14: Best and Worst Performing Delivery Partners
