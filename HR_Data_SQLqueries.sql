CREATE TABLE HR_Data(
  EmployeeID int,
  StartDate date,
  Title varchar(50),
  BusinessUnit varchar(50),
  EmployeeStatus varchar(50),
  EmployeeType varchar(50),
  PayZone varchar(50),
  EmployeeClassificationType varchar(50),
  DepartmentType varchar(50),
  Division varchar(50),
  DOB date,
  State varchar(50),
  GenderCode varchar(50),
  RaceDesc varchar(50),
  MaritalDesc varchar(50),
  PerformanceScore varchar(50),
  CurrentEmployeeRating int,
  SurveyDate date,
  EngagementScore int,
  SatisfactionScore int,
  WorkLifeBalanceScore int,
  TrainingDate date,
  TrainingProgramName varchar(50),
  TrainingType varchar(50),
  TrainingOutcome varchar(50),
  TrainingDuration_Days int,
  TrainingCost decimal(10,2),
  Age int
);

SELECT * FROM HR_Data;


COPY HR_Data
FROM 'C:\Program Files\PostgreSQL\17\HR Data Analysis.csv'
DELIMITER ','
CSV HEADER;

------------------------------------------------------------------
-- 1.Retrieve all employees who are currently active.
SELECT *
FROM HR_Data
WHERE EmployeeStatus = 'Active';

------------------------------------------------------------------
-- 2.Find the total number of employees in each Business Unit.
SELECT BusinessUnit,
COUNT(BusinessUnit) AS Number_OF_Employees FROM HR_Data
GROUP BY BusinessUnit;

------------------------------------------------------------------
-- 3.List all employees who are in the 'Sales' department.
SELECT * 
FROM HR_Data
WHERE DepartmentType = 'Sales';

------------------------------------------------------------------
-- 4.Calculate the average age of employees in each department.
SELECT DepartmentType,
ROUND(AVG(Age)) AS Average_Age
FROM HR_Data
GROUP BY DepartmentType;

------------------------------------------------------------------
-- 5.Find the maximum and minimum salary (assuming 'TrainingCost' as a proxy for salary) in each PayZone.
SELECT PayZone,
MAX(TrainingCost) AS Maximum_Salary, MIN(TrainingCost) AS Minimum_Salary
FROM HR_Data
GROUP BY PayZone;

------------------------------------------------------------------
-- 6.Count the number of employees by gender.
SELECT GenderCode,
COUNT(GenderCode) AS TotalCount FROM HR_Data
GROUP BY GenderCode;

------------------------------------------------------------------
-- 7.List all employees who have a 'Fully Meets' performance score, sorted by their start date.
SELECT * 
FROM HR_Data
WHERE PerformanceScore = 'Fully Meets'
ORDER BY StartDate;

------------------------------------------------------------------
-- 8.Find the top 5 employees with the highest training costs.
SELECT *
FROM HR_Data
ORDER BY TrainingCost DESC
LIMIT 5;

-------------------------------------------------------------------
-- 9.Retrieve employees who have a 'Failed' training outcome.
SELECT * 
FROM HR_Data
WHERE TrainingOutcome = 'Failed';

-------------------------------------------------------------------
-- 10.Find employees who have completed training programs and are in the 'Sales' department.
SELECT * FROM HR_Data
WHERE TrainingOutcome = 'Completed' AND DepartmentType ='Sales';

-------------------------------------------------------------------
-- 11.List employees who have a higher than average training cost.
SELECT * FROM HR_Data
WHERE TrainingCost > (SELECT AVG(TrainingCost) FROM HR_Data);

-------------------------------------------------------------------
-- 12.Find employees who have the same title as another employee in the same department.
SELECT a.*
FROM HR_Data a
JOIN HR_Data b
ON a.Title = b.Title AND a.DepartmentType = b.DepartmentType AND a.EmployeeID <> b.EmployeeID;

-------------------------------------------------------------------
-- 13.Calculate the average engagement score for each department,
--but only for employees who have a 'Fully Meets' performance score.
SELECT DepartmentType, ROUND(AVG(EngagementScore),1)
FROM HR_Data
WHERE PerformanceScore = 'Fully Meets'
GROUP BY DepartmentType;

---------------------------------------------------------------------
-- 14.Find the employee with the highest current employee rating in each department.
SELECT DepartmentType, MAX(CurrentEmployeeRating) AS MaximumRating
FROM HR_Data
GROUP BY DepartmentType;

---------------------------------------------------------------------
-- 15.List employees who have been with the company for more than 5 years (assuming 'StartDate' is in a date format).
SELECT * FROM HR_Data
WHERE DATE_PART('year',CURRENT_DATE) - DATE_PART('year', StartDate) > 5;

---------------------------------------------------------------------
-- 16.Find employees with missing or null values in the 'TrainingOutcome' column.
SELECT * FROM HR_Data
WhERE TrainingOutcome IS NULL;

---------------------------------------------------------------------
-- 17.Update the 'EmployeeStatus' to 'Inactive' for employees who have voluntarily terminated.
UPDATE HR_Data
SET EmployeeStatus = 'Inactive'
WHERE EmployeeStatus = 'Voluntarily terminated';

--------------------------------------------------------------------
--18. List employees who have the same title and are in the same department as another employee, but have different performance scores.
SELECT a.*
FROM HR_Data a
JOIN HR_Data b
ON a.Title = b.Title AND a.DepartmentType = b.DepartmentType AND a.EmployeeID = B.EmployeeID 
WHERE a.PerformanceScore <> b.PerformanceScore;

---------------------------------------------------------------------
-- 19.List employees who have been with the company for more than 10 years.
SELECT * FROM HR_Data
WHERE DATE_PART('year',CURRENT_DATE) - DATE_PART('year',StartDate) > 10;

---------------------------------------------------------------------
-- 20.Find the most common job title in the company.
SELECT Title, COUNT(Title) AS CommanJobTitle
FROM HR_Data
GROUP BY Title
ORDER BY Title DESC
LIMIT 1;

----------------------------------------------------------------------
-- 21.List employees who have a 'Needs Improvement' performance score and have been with the company for more than 3 years.
SELECT * FROM HR_Data 
WHERE PerformanceScore = 'Needs Improvement'
AND DATE_PART('year',CURRENT_DATE) - DATE_PART('year',StartDate) > 3;

-----------------------------------------------------------------------
-- 22. Find the Top 3 Employees with the Highest Training Costs in Each Department.
WITH RankedEmployees AS(
  SELECT
   EmployeeID,
   Title,
   DepartmentType,
   TrainingCost,
   ROW_NUMBER() OVER (PARTITION BY DepartmentType ORDER BY TrainingCost DESC) AS Rank
FROM HR_Data
)
SELECT EmployeeID, Title, DepartmentType, TrainingCost 
FROM RankedEmployees
WHERE Rank >= 3;

-------------------------------------------------------------------------------
-- 23.Calculate the Average Training Cost for Employees Who Exceeded Performance Expectations.
SELECT DepartmentType,
AVG(TrainingCost) AS AvgTrainingCost FROM HR_Data
WHERE PerformanceScore = 'Exceeds'
GROUP BY DepartmentType;

-------------------------------------------------------------------------------


   
