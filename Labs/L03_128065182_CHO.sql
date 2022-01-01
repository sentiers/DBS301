-- **********************************************
-- Name: Hyunji Cho
-- ID: 128065182
-- Date: Jan 19, 2020
-- Purpose: Submission for Lab 3 for DBS301NDE
-- Description: to learn SELECT command
--              and interfaces for SQL Developer
-- **********************************************

------------------------------------------------------------------------
-- Q1 display the tomorrow's date
-- format: September 28th of year 2016
    
-- Q1 Solution
SELECT to_char(sysdate + 1 , 'fmMonth ddth "of year" yyyy') AS "Tomorrow" 
    FROM dual;
    
-- Bonus Solution
DEFINE tomorrow = sysdate + 1;
SELECT to_char(&tomorrow, 'fmMonth ddth "of year" yyyy') AS "Tomorrow"
    FROM dual;
UNDEFINE tomorrow;

------------------------------------------------------------------------
-- Q2 For each employee in departments 20, 50 and 60 
-- display last name, first name, salary, 
-- add salary increased by 4% (whole number) -> "Good Salary"  
-- add (new salary - old salary)*12 -> "Annual Pay Increase".

-- Q2 Solution
SELECT last_name AS "Last Name",
       first_name AS "First Name",
       salary AS "Salary",
       ROUND(salary * 1.04, 0) AS "Good Salary",
       (ROUND(salary * 1.04, 0) - salary) * 12 AS "Annual Pay Increase"
    FROM employees
    WHERE department_id IN (20, 50, 60);       
    
------------------------------------------------------------------------
-- Q3 display the employee's Full Name & Job Title
-- foramt: DAVIES, CURTIS is ST_CLERK 
-- last name ends with S and first name starts with C or K.  
-- Give this column an appropriate label like Person and Job.  
-- Sort the result by the last names.

-- Q3 Solution
SELECT upper(last_name || ', ' || first_name) || ' is ' || job_id AS "Person and Job"
    FROM employees
    WHERE (upper(last_name) LIKE '%S')
        AND (substr(upper(first_name),1,1) IN ('C', 'K'))
    ORDER BY last_name;
    
------------------------------------------------------------------------
-- Q4 display the employee’s last name, hire date(hired before 2012)
-- and calculate the number of YEARS (hired date - TODAY)
-- Label the column Years worked. 
-- Order your results by the number of years employed.  
-- Round the number of years employed up to the closest whole number.

-- Q4 Solution
SELECT last_name AS "Last Name",
       hire_date AS "Hire Date",
       round(months_between(sysdate, hire_date)/12 ,0) AS "Years Worked"
    FROM employees
    WHERE hire_date < to_date('2012-01-01', 'yyyy-mm-dd')
    ORDER BY "Years Worked" DESC;

------------------------------------------------------------------------
-- Q5 displays the city names, country codes and state province names
-- cities that starts with S and has at least 8 characters in their name
-- If city does not have a province name assigned, put Unknown Province
-- Be cautious of case sensitivity

-- Q5 Solution
SELECT city AS "City",
       country_id AS "Country Code",
       NVL(state_province, 'Unknown Province')  AS "Province"
    FROM locations
    WHERE (upper(city) LIKE 'S%')
        AND (length(city) >= 8);

------------------------------------------------------------------------
-- Q6 employee’s last name, hire date, and salary review date
-- salary review date: first Thursday after a year of service
-- only for those hired after 2017
-- sort by review date
-- format: WEDNESDAY, SEPTEMBER the Eighteenth of year 2019

-- Q6 Solution
SELECT last_name AS "Last Name",
       hire_date AS "Hire Date",
       to_char(next_day( add_months(hire_date, 12), 'Thursday'),
       'fmDAY, MONTH "the" Ddspth "of year" yyyy') AS "REVIEW DAY"
    FROM employees
    WHERE hire_date >= to_date('2017-01-01', 'yyyy-mm-dd')
    ORDER BY next_day(add_months(hire_date, 12), 'Thursday');

------------------------------------------------------------------------
-- END OF FILE
------------------------------------------------------------------------
