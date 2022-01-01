-- **********************************************
-- Name: Hyunji Cho
-- ID: 128065182
-- Date: Feb 09, 2020
-- Purpose: Submission for Lab 6 for DBS301NDE
-- Description: using SELECT command and
--              incorporating multiple tables
-- **********************************************

------------------------------------------------------------------------
-- Q1 SET AUTOCOMMIT ON (do this each time you log on) 
-- so any updates, deletes and inserts are automatically committed 

-- Q1 Solution
SET AUTOCOMMIT ON;

------------------------------------------------------------------------
-- Q2 Create an INSERT statement to do this add yourself as an employee
-- a NULL salary, 0.21 commission_pct, in department 90, and Manager 100
-- You started TODAY.

-- Q2 Solution
INSERT INTO employees 
    VALUES (207, 'Hyunji', 'Cho', 'hcho51@myseneca.ca',
            '647.831.5779', sysdate, 'IT_PROG', NULL, 0.21, 100, 90);

------------------------------------------------------------------------
-- Q3 Create an Update statement to: Change the salary of the employees
-- with a last name of Matos and Whalen to be 2500.

-- Q3 Solution
UPDATE employees SET salary = 2500 
    WHERE last_name IN ('Matos', 'Whalen');

------------------------------------------------------------------------
-- Must use subqueries
------------------------------------------------------------------------
-- Q4 Display the last names of all employees 
-- who are in the same department as the employee named Abel.

-- Q4 Solution
SELECT last_name AS "Last Name"
    FROM employees
    WHERE department_id = (
                           SELECT department_id 
                           FROM employees 
                           WHERE upper(last_name) = 'ABEL'
                           );

------------------------------------------------------------------------
-- Q5 Display the last name of the lowest paid employee(s)

-- Q5 Solution
SELECT last_name AS "Last Name"
    FROM employees
    WHERE salary = (
                    SELECT min(salary) 
                    FROM employees
                    );

------------------------------------------------------------------------
-- Q6 Display the city that the lowest paid employee(s) are located in

-- Q6 Solution
SELECT DISTINCT city AS "City"
    FROM locations 
    JOIN departments USING (location_id) 
    JOIN employees USING (department_id)
    WHERE salary = (
                    SELECT MIN(salary) 
                    FROM employees
                    );

------------------------------------------------------------------------
-- Q7 Display the last name, department_id
-- and salary of the lowest paid employee(s) in each department.
-- Sort by Department_ID. (HINT: careful with department 60)

-- Q7 Solution
SELECT last_name AS "Last Name", 
       department_id AS "Department ID", 
       salary AS "Salary"
    FROM employees
    WHERE (department_id, salary) IN (
                                      SELECT department_id, 
                                             min(salary)
                                      FROM employees
                                      GROUP BY department_id
                                      )
    ORDER BY department_id;
------------------------------------------------------------------------
-- Q8 Display the last name of the lowest paid employee(s) in each city

-- Q8 Solution
SELECT last_name AS "Last Name"
    FROM employees
    WHERE salary IN (
                    SELECT min(salary)
                    FROM locations 
                    JOIN departments USING (location_id) 
                    JOIN employees USING (department_id)
                    GROUP BY city
                    );

------------------------------------------------------------------------
-- Q9 Display last name and salary for all employees 
-- who earn less than the lowest salary in ANY department.  
-- Sort the output by top salaries first and then by last name.

-- Q9 Solution
SELECT last_name AS "Last Name",
       salary AS "Salary"
    FROM employees
    WHERE salary < ANY (
                        SELECT min(salary) 
                        FROM employees 
                        GROUP BY department_id
                        )
    ORDER BY salary DESC, last_name;

------------------------------------------------------------------------
-- Q10 Display last name, job title and salary for all employees 
--  whose salary matches any of the salaries from the IT Department
-- Sort the output by salary ascending first and then by last_name

-- Q10 Solution
SELECT last_name AS "Last Name",
       job_id AS "Job ID",
       salary AS "Salary"
    FROM employees
    WHERE salary = ANY (
                        SELECT salary 
                        FROM employees 
                        WHERE upper(job_id)= 'IT_PROG'
                        )
    ORDER BY salary, last_name;
        
------------------------------------------------------------------------
-- END OF FILE
------------------------------------------------------------------------
