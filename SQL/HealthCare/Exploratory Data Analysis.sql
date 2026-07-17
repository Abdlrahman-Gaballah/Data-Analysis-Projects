-- Data Overview

SELECT 'Train (Registrations)' as table_name, COUNT(*) as record_count FROM train
UNION ALL
SELECT 'Patient Profile', COUNT(*) FROM patient_profile
UNION ALL
SELECT 'Camps Detail', COUNT(*) FROM health_camp_detail;

-- Missing Values / Nulls
SELECT 
    SUM(CASE WHEN Age IS NULL OR Age = '' THEN 1 ELSE 0 END) AS Missing_Age,
    SUM(CASE WHEN City_Type IS NULL OR City_Type = '' THEN 1 ELSE 0 END) AS Missing_City,
    SUM(CASE WHEN Education_Score IS NULL OR Education_Score = '' THEN 1 ELSE 0 END) AS Missing_Education
FROM patient_profile;

-- Data Distribution
SELECT 
    CASE 
        WHEN Age < 30 THEN 'Under 30'
        WHEN Age BETWEEN 30 AND 50 THEN '30-50'
        WHEN Age > 50 THEN 'Over 50'
        ELSE 'Unknown'
    END AS Age_Group,
    COUNT(*) AS Patient_Count
FROM patient_profile
GROUP BY Age_Group;

-- Categorical Analysis
SELECT Category1, Category2, COUNT(*) as camp_count
FROM health_camp_detail
GROUP BY Category1, Category2;

