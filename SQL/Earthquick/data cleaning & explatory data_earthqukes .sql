select * 
from earthquake_data_tsunami;

/*
data cleaning project  
1 remove duplicate 
steps to remove duplicate 
1- make copy of row data 
2- insert data into  the copy data 
3- ad row number 
*/
-- first thing we want to do is create a staging table. This is the one we will work in and clean the data. We want a table with the raw data in case something happens
CREATE TABLE earthquake_data_tsunami2 
LIKE earthquake_data_tsunami;
-- insert data from maintable to the backup table 
INSERT earthquake_data_tsunami2 
SELECT * 
FROM earthquake_data_tsunami;
-- make  sure the data inserted 
select * 
from earthquake_data_tsunami2;
-- show duplicates 
ALTER TABLE earthquake_data_tsunami2
ADD COLUMN id INT AUTO_INCREMENT PRIMARY KEY FIRST;
 WITH ranked AS (
  SELECT 
    id,  -- your primary key column
    ROW_NUMBER() OVER (
      PARTITION BY Year, Month, magnitude, mmi, sig, nst, dmin, gap, depth, latitude, longitude, tsunami
      ORDER BY id
    ) AS row_num
  FROM earthquake_data_tsunami2
)
DELETE e
FROM earthquake_data_tsunami2 e
JOIN ranked r
  ON e.id = r.id
WHERE r.row_num > 1;
-- make sure that duplicate with deleted 
select * 
from earthquake_data_tsunami2;

-- analysis 
-- over view 
SELECT COUNT(*) AS total_records FROM earthquake_data_tsunami2;
SELECT MIN(Year), MAX(Year) FROM earthquake_data_tsunami2;
SELECT MIN(Month), MAX(Month) FROM earthquake_data_tsunami2;
SELECT AVG(magnitude) AS avg_magnitude, AVG(depth) AS avg_depth FROM earthquake_data_tsunami2;
-- tsunami events 
SELECT tsunami, COUNT(*) AS count
FROM earthquake_data_tsunami2
GROUP BY tsunami;
-- Strongest Earthquakes
SELECT id , magnitude, depth
FROM earthquake_data_tsunami2
ORDER BY magnitude DESC
LIMIT 10;
-- Magnitude Distribution
SELECT
  CASE
    WHEN magnitude < 4 THEN 'Minor'
    WHEN magnitude BETWEEN 4 AND 5 THEN 'Light'
    WHEN magnitude BETWEEN 5 AND 6 THEN 'Moderate'
    WHEN magnitude BETWEEN 6 AND 7 THEN 'Strong'
    ELSE 'Major'
  END AS mag_category,
  COUNT(*) AS event_count
FROM earthquake_data_tsunami2
GROUP BY mag_category;
-- Correlation Between Tsunami & Magnitude
SELECT tsunami, AVG(magnitude) AS avg_magnitude, COUNT(*) AS count
FROM earthquake_data_tsunami2
GROUP BY tsunami;
-- Top 5 Regions with Highest Average Magnitude
SELECT 
 AVG(magnitude) AS avg_mag, COUNT(*) AS event_count
FROM earthquake_data_tsunami2
HAVING COUNT(*) > 5
ORDER BY avg_mag DESC
LIMIT 5;
-- monthley Trend 
SELECT Month AS Month, COUNT(*) AS total_events, AVG(magnitude) AS avg_mag
FROM earthquake_data_tsunami2
GROUP BY Month
ORDER BY Month;
-- Yearly Trends
SELECT YEAR AS year, COUNT(*) AS total_events, AVG(magnitude) AS avg_mag
FROM earthquake_data_tsunami2
GROUP BY YEAR
ORDER BY year;

