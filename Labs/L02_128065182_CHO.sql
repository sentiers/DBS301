-- **********************************************
-- Name: Hyunji Cho
-- ID: 128065182
-- Date: Jan 13, 2020
-- Purpose: Submission for Lab 2 for DBS301NDE
-- Description: to learn SELECT command
--              and interfaces for SQL Developer
-- **********************************************

------------------------------------------------------------------------
-- Q1 display the employee_id, last name and salary
-- employee earning range $8,000 - $11,000
-- sort the output by top salaries first and then by last name
    
-- Q1 Solution
SELECT employee_id AS "Emp ID", last_name AS "Last Name", 
    to_char(salary, '$99,999.99') AS "Salary"
    FROM employees
    WHERE salary >= 8000 AND salary <= 11000
    ORDER BY salary DESC, last_name;

------------------------------------------------------------------------
-- Q2 Modify previous query (#1)
-- display only if they work as Programmers or Sales Representatives. 
-- use same sorting as before.

-- Q2 Solution
SELECT employee_id AS "Emp ID", last_name AS "Last Name", 
       to_char(salary, '$99,999.99') AS "Salary", job_id AS "Job ID"
    FROM employees
    WHERE (salary >= 8000 AND salary <= 11000)
        AND (job_id IN ('SA_REP', 'IT_PROG'))
    ORDER BY salary DESC, last_name;
        
------------------------------------------------------------------------
-- Q3 Modify previous query (#2)
-- displays the same job titles 
-- people who earn outside the given salary range $8,000 - $11,000
-- Use same sorting as before.

-- Q3 Solution
SELECT employee_id AS "Emp ID", last_name AS "Last Name", 
    to_char(salary, '$99,999.99') AS "Salary", job_id AS "Job ID"
    FROM employees
    WHERE (salary < 8000 OR salary > 11000)
        AND (job_id in('SA_REP', 'IT_PROG'))
    ORDER BY salary DESC, last_name;
    
------------------------------------------------------------------------
-- Q4 Display the last name, job_id and salary
-- employees hired before 2018
-- List the most recently hired employees first.

-- Q4 Solution
SELECT  hire_date AS "Hired Date", last_name AS "Last Name",
        job_id AS "Job ID", to_char(salary, '$99,999.99') AS "Salary"
    FROM employees
    WHERE hire_date < to_date ('2018-01-01', 'yyyy-mm-dd')
    ORDER BY hire_date DESC;

------------------------------------------------------------------------
-- Q5 Modify previous query (#4) 
-- displays only employees earning more than $11,000
-- List the output by job title alphabetically 
-- and then by highest paid employees.

-- Q5 Solution
SELECT  hire_date AS "Hired Date", last_name AS "Last Name",
        job_id AS "Job ID", to_char(salary, '$99,999.99') AS "Salary"
    FROM employees
    WHERE (hire_date < to_date('2018-01-01','yyyy-mm-dd'))
        AND (salary > 11000)
    ORDER BY job_id, salary DESC;

------------------------------------------------------------------------
-- Q6 Display the job titles and full names of employees 
-- whose first name contains an 'e' or 'E' anywhere
-- BONUS MARK for not using the OR keyword

-- Q6 Solution
SELECT job_id AS "Job Title", 
    first_name || ' ' || last_name AS "Full Name"
    FROM employees
    WHERE upper(first_name) LIKE '%E%';

------------------------------------------------------------------------
-- Q7 display the address of the various locations of offices.  
-- Add a parameter that the user can enter all, or part of,
-- the city name and all locations will be shown.

-- Q7 Solution
SELECT street_address AS "Street", city AS "City",
       state_province AS "Province", postal_code AS "Postal Code",
       country_id AS "Country"
    FROM locations
    WHERE upper(city) LIKE upper('%&City%');
    
------------------------------------------------------------------------
-- END OF FILE
------------------------------------------------------------------------
