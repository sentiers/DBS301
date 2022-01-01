-- **********************************************
-- Name: Hyunji Cho
-- ID: 128065182
-- Date: Jan 26, 2020
-- Purpose: Submission for Lab 4 for DBS301NDE
-- Description: to learn SELECT command
--              and multTables
-- **********************************************

------------------------------------------------------------------------
-- Q1 display average pay and lowest pay difference
-- Name this Real Amount
-- Format the output as currency with 2 decimal places
    
-- Q1 Solution
SELECT to_char(avg(salary) - min(salary), '$999,999.99') AS "Real Amount" 
    FROM employees;
    
------------------------------------------------------------------------
-- Q2 Display each department's number and Highest,Lowest and Average pay. 
-- Name these results High, Low and Avg
-- sort by average salary
-- Format the output as currency where appropriate

-- Q2 Solution
SELECT  department_ID AS "Department ID",
        to_char(max(salary), '$999,999.99') AS "High",
        to_char(min(salary), '$999,999.99') AS "Low",
        to_char(avg(salary), '$999,999.99') AS "Avg"
    FROM employees
    GROUP BY department_id
    ORDER BY avg(salary) DESC;

------------------------------------------------------------------------
-- Q3 Display how many people work the same job in the same department.
-- Name these results Dept#, Job and How Many
-- Include only jobs that involve more than one person
-- sort by jobs with the most people involved

-- Q3 Solution
SELECT  department_id AS "Dept#",
        job_id AS "Job",
        count(employee_id) AS "How Many"
    FROM employees
    GROUP BY department_id, job_id
	HAVING count(employee_id) > 1
    ORDER BY "How Many" DESC;

------------------------------------------------------------------------
-- Q4 For each job title display the job title (Exclude AD_PRES and AD_VP)
-- and display total amount paid each month for this type of the job
-- include only jobs that require more than $11,000
-- sort by top paid jobs

-- Q4 Solution
SELECT  job_id AS "Job ID",
        sum(salary) AS "Total Amount Paid"
    FROM employees
    GROUP BY job_id
    HAVING  (job_id NOT IN('AD_PRES','AD_VP'))
        AND (sum(salary) > 11000)
    ORDER BY "Total Amount Paid" DESC;

------------------------------------------------------------------------
-- Q5 For each manager number display how many persons he/she supervises
-- Exclude managers with numbers 100, 101 and 102
-- include only those managers that supervise more than 2 persons
-- Sort by manager numbers with the most supervised persons

-- Q5 Solution
SELECT  manager_id AS "Manager ID",
        count(employee_id) AS "Supervised Employees"
    FROM employees
    GROUP BY manager_id
    HAVING (manager_id NOT IN(100,101,102))
        AND (count(employee_id) > 2)
    ORDER BY "Supervised Employees" DESC;

------------------------------------------------------------------------
-- Q6 For each department show the latest and earliest hire date
-- exclude departments 10 and 20
-- exclude departments where the last person was hired in this decade
-- Sort by the latest hire dates

-- Q6 Solution
SELECT  department_id AS "Department ID",
        max(hire_date) AS "Latest Date",
        min(hire_date) AS "Earliest Date"
    FROM employees
    GROUP BY department_id
    HAVING (department_id NOT IN (10, 20))
        AND (max(hire_date) < to_date('2010-12-31','yyyy-mm-dd'))
        AND (max(hire_date) > to_date('2021-01-01','yyyy-mm-dd'))
    ORDER BY "Latest Date" DESC;

------------------------------------------------------------------------
-- END OF FILE
------------------------------------------------------------------------
