-- **********************************************
-- Name: Hyunji Cho
-- ID: 128065182
-- Date: Jan 13, 2020
-- Purpose: Submission for Lab 1 for DBS301NDE
-- Description: to learn the interface for SQL Developer
--              and a few string formatting techniques
-- **********************************************

------------------------------------------------------------------------
-- Q1 Which one of these tables appeared to be the widest? or longest?
SELECT * 
    FROM employees;
SELECT *
    FROM departments;
SELECT * 
    FROM job_history;
    
-- Q1 Solution
-- employees table is the widest and the longest

------------------------------------------------------------------------
-- Q2 How would you fix the following SELECT statement?
-- SELECT last_name "LName", job_id "Job Title",
--        Hire Date "Job Start"
--        FROM employees;

-- Q2 Solution
SELECT last_name AS "LName", job_id AS "Job Title", hire_date AS "Job Start" 
    FROM employees; 

------------------------------------------------------------------------
-- Q3 Three errors in this statement. Identify them.
-- SELECT employee_id, last name, commission_pct Emp Comm,
-- FROM employees;

-- Q3 Solution
-- 1) last name needs to be last_name
-- 2) commission_pct Emp Comm needs to be commission_pct AS "Emp Comm"
-- 3) comma before FROM should be removed

SELECT employee_id, last_name, commission_pct AS "Emp Comm"
    FROM employees;
        
------------------------------------------------------------------------
-- Q4 What command would show the structure of the LOCATIONS table?

-- Q4 Solution
DESCRIBE locations;

------------------------------------------------------------------------
-- Q5 Create a query to display the output

-- Q5 Solution
SELECT location_id AS "City#", city as "City", 
       state_province || ' IN THE ' || country_id AS "Province with Country Code"
    FROM locations;

-- Bonus Solution
SELECT location_id AS "City#", city as "City",
    CASE 
        WHEN state_province IS NULL THEN country_id
        ELSE (state_province || ' IN THE ' || country_id) 
    END "Province with Country Code"
    FROM locations;

------------------------------------------------------------------------
-- END OF FILE
------------------------------------------------------------------------
