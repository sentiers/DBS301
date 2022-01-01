-- **********************************************
-- Name: Hyunji Cho
-- ID: 128065182
-- Date: Feb 17, 2020
-- Purpose: Submission for lab 7 for DBS301NDE
-- Description: incorporating multiple tables
--              various set operators to produce results
-- **********************************************

------------------------------------------------------------------------
-- Q1 a list of Department IDs for departments
-- don't contain jobID of ST_CLERK

-- Q1 Solution
SELECT department_id 
    FROM departments 
MINUS
SELECT department_id
    FROM employees
    WHERE upper(job_id) = 'ST_CLERK';

------------------------------------------------------------------------
-- Q2 a list of countries that have no departments located in them
-- Display country ID and the country name

-- Q2 Solution    
SELECT country_id,
       country_name
    FROM countries
MINUS
SELECT country_id, 
       country_name
    FROM locations 
    JOIN countries USING(country_id)
    JOIN departments USING(location_id);
        
------------------------------------------------------------------------
-- Q3 a list of departments 10, 50, 20 in that order
-- job and department ID are to be displayed

-- Q3 Solution
SELECT DISTINCT job_id, 
                department_id
    FROM employees
    WHERE department_id = 10
UNION ALL
SELECT DISTINCT job_id, 
                department_id
    FROM employees
    WHERE department_id = 50
UNION ALL
SELECT DISTINCT job_id, 
                department_id
    FROM employees
    WHERE department_id = 20;

------------------------------------------------------------------------
-- Q4 lists the employeeIDs and JobIDs
-- employees who currently have a job title that is the same as 
-- their job title when they were initially hired by the company

-- Q4 Solution
SELECT employee_id, 
       job_id
    FROM job_history
    WHERE (employee_id, start_date) IN (
                                       SELECT employee_id,
                                              min(start_date) 
                                       FROM job_history
                                       GROUP BY employee_id
                                       )
INTERSECT 
SELECT employee_id,
       job_id
    FROM employees;   

------------------------------------------------------------------------
-- Q5 SINGLE report with the following specifications
-- Last name and department ID of all employees 
-- regardless of whether they belong to a department or not
-- Department ID and department name of all departments 
-- regardless of whether they have employees in them or not

-- Q5 Solution
SELECT last_name,
       department_id,
       NULL AS "DEPARTMENT_NAME"
    FROM employees
UNION
SELECT NULL,
       department_id,
       department_name
    FROM departments;
    
------------------------------------------------------------------------
-- END OF FILE
------------------------------------------------------------------------
