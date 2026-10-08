CREATE DATABASE helthcare_analytics;
USE helthcare_analytics;
SELECT COUNT(*) as Total_Patients
FROM healthcare_raw;
SELECT* FROM healthcare_raw
LIMIT 10;
DESCRIBE helthcare_analytics;
DESC healthcare_raw;
SELECT Gender,COUNT(*) as Total_Patients
FROM healthcare_raw
GROUP BY Gender;
SELECT
MIN(Age)as Minimum_Age,
MAX(Age)as Maximum_Age,
AVG(Age)as Average_Age
FROM healthcare_raw;
SELECT `Medical Condition`,
COUNT(*)as Total_Patients
FROM healthcare_raw
GROUP BY `Medical Condition`
ORDER BY Total_Patients DESC;
SELECT `Admission Type`,
COUNT(*) as Total_Patients
FROM healthcare_raw
GROUP BY `Admission Type`
ORDER BY Total_Patients DESC;
SELECT Gender,
count(*)as Total_Patients
FROM healthcare_raw
GROUP BY Gender;
SELECT `Test Results`,
COUNT(*) as Total_Patients
FROM healthcare_raw
GROUP BY `Test Results`
ORDER BY Total_Patients DESC;
SELECT Hospital,
COUNT(*) as Total_Patients
FROM healthcare_raw
GROUP BY Hospital
ORDER BY Total_Patients DESC
LIMIT 5;
SELECT `Medical Condition`,
ROUND(AVG(`Billing Amount`),2) AS Average_Bill
FROM healthcare_raw
GROUP BY `Medical Condition`
ORDER BY Average_Bill DESC;
SELECT `Insurance Provider`,
ROUND(AVG(`Billing Amount`),2) AS Average_Bill
FROM healthcare_raw
GROUP BY `Insurance Provider`
ORDER BY Average_Bill DESC;
SELECT `Blood Type`,
COUNT(*) AS Total_Patients
FROM healthcare_raw
GROUP BY `Blood Type`
ORDER BY Total_Patients DESC;
SELECT Medication,
COUNT(*) AS Total_Patients
FROM healthcare_raw
GROUP BY Medication
ORDER BY Total_Patients DESC;
SELECT *
FROM healthcare_raw
WHERE Age >= 60;
SELECT COUNT(*) AS Senior_Patients
FROM healthcare_raw
WHERE Age >= 60;
SELECT *
FROM healthcare_raw
WHERE `Medical Condition` = 'Diabetes';
SELECT Name,
Hospital,
`Billing Amount`
FROM healthcare_raw
ORDER BY `Billing Amount` DESC
LIMIT 5;
SELECT
CASE
    WHEN Age < 18 THEN 'Child'
    WHEN Age BETWEEN 18 AND 40 THEN 'Young Adult'
    WHEN Age BETWEEN 41 AND 60 THEN 'Adult'
    ELSE 'Senior Citizen'
END AS Age_Group,
COUNT(*) AS Total_Patients
FROM healthcare_raw
GROUP BY Age_Group
ORDER BY Total_Patients DESC;
SELECT
`Medical Condition`,
ROUND(AVG(`Billing Amount`),2) AS Average_Bill
FROM healthcare_raw
GROUP BY `Medical Condition`
ORDER BY Average_Bill DESC;
SELECT
Hospital,
ROUND(AVG(`Billing Amount`),2) AS Average_Bill
FROM healthcare_raw
GROUP BY Hospital
ORDER BY Average_Bill DESC
LIMIT 10;
SELECT
`Admission Type`,
COUNT(*) AS Total_Patients
FROM healthcare_raw
GROUP BY `Admission Type`
ORDER BY Total_Patients DESC;
SELECT
`Test Results`,
COUNT(*) AS Total_Patients
FROM healthcare_raw
GROUP BY `Test Results`
ORDER BY Total_Patients DESC;
SELECT
`Insurance Provider`,
COUNT(*) AS Total_Patients,
ROUND(AVG(`Billing Amount`),2) AS Average_Bill
FROM healthcare_raw
GROUP BY `Insurance Provider`
ORDER BY Average_Bill DESC;
SELECT
Doctor,
COUNT(*) AS Total_Patients
FROM healthcare_raw
GROUP BY Doctor
ORDER BY Total_Patients DESC
LIMIT 10;
SELECT
Name,
Hospital,
`Billing Amount`
FROM healthcare_raw
WHERE `Billing Amount` >
(
SELECT AVG(`Billing Amount`)
FROM healthcare_raw
);
SELECT
Hospital,
MAX(`Billing Amount`) AS Highest_Bill
FROM healthcare_raw
GROUP BY Hospital
ORDER BY Highest_Bill DESC
LIMIT 5;
SELECT
`Blood Type`,
COUNT(*) AS Total_Patients
FROM healthcare_raw
GROUP BY `Blood Type`
ORDER BY Total_Patients DESC;
SELECT
MONTHNAME(STR_TO_DATE(`Date of Admission`,'%d/%m/%Y')) AS Admission_Month,
COUNT(*) AS Total_Patients
FROM healthcare_raw
GROUP BY Admission_Month
ORDER BY Total_Patients DESC;
SELECT
    `Date of Admission`,
    STR_TO_DATE(`Date of Admission`, '%d-%m-%Y')
FROM healthcare_raw
LIMIT 10;
SELECT
    MONTHNAME(`Date of Admission`) AS Admission_Month,
    COUNT(*) AS Total_Patients
FROM healthcare_raw
GROUP BY MONTHNAME(`Date of Admission`), MONTH(`Date of Admission`)
ORDER BY Total_Patients DESC;
SELECT *
FROM healthcare_raw
WHERE Name IS NULL
   OR Hospital IS NULL
   OR Gender IS NULL;
   
   
   
---------------------------------
#view
--------------------------------
use helthcare_analytics;
CREATE VIEW vw_hospital_billing_summary AS
SELECT
    Hospital,
    COUNT(*) AS Total_Patients,
    SUM(`Billing Amount`) AS Total_Billing,
    ROUND(AVG(`Billing Amount`),2) AS Average_Billing
FROM healthcare_raw
GROUP BY Hospital;
SELECT*FROM vw_hospital_billing_summary;

CREATE VIEW vw_gender_summary AS
SELECT
    Gender,
    COUNT(*) AS Total_Patients
FROM healthcare_raw
GROUP BY Gender;
SELECT * FROM vw_gender_summary;

CREATE VIEW vw_blood_group_summary AS
SELECT
    `Blood Type`,
    COUNT(*) AS Total_Patients
FROM healthcare_raw
GROUP BY `Blood Type`;
SELECT * FROM vw_blood_group_summary;

CREATE VIEW vw_medical_condition_summary AS
SELECT
    `Medical Condition`,
    COUNT(*) AS Total_Patients,
    ROUND(AVG(`Billing Amount`),2) AS Average_Bill
FROM healthcare_raw
GROUP BY `Medical Condition`;
SELECT * FROM vw_medical_condition_summary;

CREATE VIEW vw_insurance_summary AS
SELECT
    `Insurance Provider`,
    COUNT(*) AS Total_Patients,
    SUM(`Billing Amount`) AS Total_Billing
FROM healthcare_raw
GROUP BY `Insurance Provider`;
SELECT * FROM vw_insurance_summary;
-------------------------------------
#CTE
-------------------------------------
WITH Hospital_Billing AS
(
    SELECT
        Hospital,
        AVG(`Billing Amount`) AS Avg_Billing
    FROM healthcare_raw
    GROUP BY Hospital
)
SELECT *
FROM Hospital_Billing
ORDER BY Avg_Billing DESC;

WITH High_Billing AS
(
    SELECT *
    FROM healthcare_raw
    WHERE `Billing Amount` > 50000
)
SELECT
    Name,
    Hospital,
    `Billing Amount`
FROM High_Billing
ORDER BY `Billing Amount` DESC;

WITH Gender_Count AS
(
    SELECT
        Gender,
        COUNT(*) AS Total_Patients
    FROM healthcare_raw
    GROUP BY Gender
)
SELECT *
FROM Gender_Count;

WITH Disease_Summary AS
(
    SELECT
        `Medical Condition`,
        COUNT(*) AS Total_Patients,
        ROUND(AVG(`Billing Amount`),2) AS Average_Bill
    FROM healthcare_raw
    GROUP BY `Medical Condition`
)
SELECT *
FROM Disease_Summary
ORDER BY Total_Patients DESC;

WITH Insurance_Summary AS
(
    SELECT
        `Insurance Provider`,
        SUM(`Billing Amount`) AS Total_Billing
    FROM healthcare_raw
    GROUP BY `Insurance Provider`
)
SELECT *
FROM Insurance_Summary
ORDER BY Total_Billing DESC;

----------------------------------
# Window Functions
----------------------------------
SELECT
    Name,
    Hospital,
    `Billing Amount`,
    ROW_NUMBER() OVER (ORDER BY `Billing Amount` DESC) AS Row_Num
FROM healthcare_raw;

SELECT
    Name,
    Hospital,
    `Billing Amount`,
    RANK() OVER (ORDER BY `Billing Amount` DESC) AS Bill_Rank
FROM healthcare_raw;

SELECT
    Name,
    Hospital,
    `Billing Amount`,
    DENSE_RANK() OVER (ORDER BY `Billing Amount` DESC) AS DRank
FROM healthcare_raw;

SELECT
    Name,
    Hospital,
    `Billing Amount`,
    ROW_NUMBER() OVER (
        PARTITION BY Hospital
        ORDER BY `Billing Amount` DESC
    ) AS Hospital_Rank
FROM healthcare_raw;

WITH Hospital_Ranking AS
(
    SELECT
        Name,
        Hospital,
        `Billing Amount`,
        ROW_NUMBER() OVER (
            PARTITION BY Hospital
            ORDER BY `Billing Amount` DESC
        ) AS Rank_No
    FROM healthcare_raw
)
SELECT *
FROM Hospital_Ranking
WHERE Rank_No = 1;

-------------------------------
#Stored Procedures
-------------------------------
DELIMITER $$

CREATE PROCEDURE Get_All_Patients()
BEGIN
    SELECT *
    FROM healthcare_raw;
END $$

DELIMITER ;
CALL Get_All_Patients();

DELIMITER $$

CREATE PROCEDURE Get_Patients_By_Hospital(IN Hospital_Name VARCHAR(255))
BEGIN
    SELECT *
    FROM healthcare_raw
    WHERE Hospital = Hospital_Name;
END $$

DELIMITER ;

CALL Get_Patients_By_Hospital('Cook PLC');

DELIMITER $$

CREATE PROCEDURE Get_Patients_By_Gender(IN Gender_Name VARCHAR(20))
BEGIN
    SELECT *
    FROM healthcare_raw
    WHERE Gender = Gender_Name;
END $$

DELIMITER ;
CALL Get_Patients_By_Gender('Male');

DELIMITER $$

CREATE PROCEDURE Get_High_Billing(IN Amount DECIMAL(10,2))
BEGIN
    SELECT
        Name,
        Hospital,
        `Billing Amount`
    FROM healthcare_raw
    WHERE `Billing Amount` > Amount
    ORDER BY `Billing Amount` DESC;
END $$

DELIMITER ;

CALL Get_High_Billing(50000);

DELIMITER $$

CREATE PROCEDURE Get_Medical_Condition_Summary()
BEGIN
    SELECT
        `Medical Condition`,
        COUNT(*) AS Total_Patients,
        ROUND(AVG(`Billing Amount`),2) AS Average_Bill
    FROM healthcare_raw
    GROUP BY `Medical Condition`;
END $$

DELIMITER ;

CALL Get_Medical_Condition_Summary();

SHOW PROCEDURE STATUS
WHERE Db = 'healthcare_analytics';
-----------------------------------------------------------------------------------------------------------------------------------
SHOW DATABASES;

USE helthcare_analytics;
SHOW TABLES;
DESCRIBE healthcare_raw;







