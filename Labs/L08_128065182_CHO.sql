-- **********************************************
-- Name: Hyunji Cho
-- ID: 128065182
-- Date: Mar 7, 2020
-- Purpose: Submission for lab 8 for DBS301NDE
-- Description: Views and Permissions
-- **********************************************

------------------------------------------------------------------------
-- Q1 Display the names of the employees whose salary is 
-- the same as the lowest salaried employee in any department.

-- Q1 Solution
SELECT first_name || ' ' || last_name AS "Full Name"
    FROM employees
    WHERE salary IN (
        SELECT MIN(salary)
            FROM employees
            GROUP BY department_id)
    ORDER BY first_name;
    
------------------------------------------------------------------------
-- Q2 Display the names of the employee(s) 
-- whose salary is the lowest in each department.

-- Q2 Solution    
SELECT first_name || ' ' || last_name AS "Full Name",
       department_id AS "Department",
       salary AS "Salary"
    FROM employees
    WHERE (salary, department_id) IN (
        SELECT MIN(salary),
               department_id
            FROM employees
            GROUP BY department_id)
    ORDER BY department_id;
      
------------------------------------------------------------------------
-- Q3 Give each of the employees in question 2 a $120 bonus

-- Q3 Solution
SELECT first_name || ' ' || last_name AS "Full Name",
       department_id AS "Department",
       salary + 120 AS "Salary + 120"
    FROM employees
    WHERE (salary, department_id) IN (
        SELECT MIN(salary),
               department_id
            FROM employees
            GROUP BY department_id)
    ORDER BY department_id;

------------------------------------------------------------------------
-- Q4 Create a view named vwAllEmps that consists of all employees 
-- includes employee_id, last_name, salary, department_id, 
-- department_name, city and country (if applicable)

-- Q4 Solution
DROP VIEW vwAllEmps;

CREATE VIEW vwAllEmps AS (
    SELECT employee_id, 
           last_name,
           salary,
           e.department_id, 
           department_name,
           city,
           country_name
        FROM employees e 
        LEFT JOIN departments d ON e.department_id = d.department_id
        LEFT JOIN locations l ON l.location_id = d.location_id
        LEFT JOIN countries c ON c.country_id = l.country_id
);
        
SELECT * FROM vwAllEmps;

------------------------------------------------------------------------
-- Q5 Use the vwAllEmps view to:
-- a.Display the employee_id, last_name, salary and city for all employees

-- Q5-a Solution
SELECT employee_id AS "Employee ID", 
        last_name AS "Last Name", 
        salary AS "Salary", 
        city AS "City"
    FROM vwAllEmps;

-- b.Display the total salary of all employees by city

-- Q5-b Solution
SELECT city AS "City",
       sum(salary) "Total Salary"
    FROM vwAllEmps
    WHERE city IS NOT NULL
    GROUP BY city
    ORDER BY city;

-- c.Increase the salary of the lowest paid employee(s)in each 
--   department by 120

-- Q5-c Solution
SELECT last_name AS "Last Name",
       department_id AS "Department",
       salary + 120 AS "Salary + 120"
    FROM vwAllEmps
    WHERE (salary, department_id) IN (
        SELECT MIN(salary),
               department_id
            FROM vwAllEmps
            GROUP BY department_id)
    ORDER BY department_id;

-- d.What happens if you try to insert an employee by providing values 
--   for all columns in this view?

-- Q5-d Solution
INSERT INTO vwAllEmps 
    VALUES ( 207, 'Cho', 15000, 60, 'IT_PROG', 'North York', 'Canada');
-- **Error "cannot modify more than one base table through a join view"

-- e.Delete the employee named Vargas. Did it work? Show proof.

-- Q5-e Solution
DELETE FROM vwAllEmps
    WHERE upper(last_name) = 'VARGAS';
-- it works

------------------------------------------------------------------------
-- Q6 Create a view named vwAllDepts that consists of all departments 
-- and includes department_id, department_name, city and country

-- Q6 Solution
DROP VIEW vwAllDepts;

CREATE VIEW vwAllDepts AS ( 
    SELECT department_id,
           department_name,
           city,
           country_name
        FROM departments d 
        LEFT JOIN locations l ON d.location_id = l.location_id
        LEFT JOIN countries c ON l.country_id = c.country_id
);
            
SELECT * FROM vwAllDepts;

------------------------------------------------------------------------
-- Q7 Use the vwAllDepts view to:
-- a.For all departments display the department_id, name and city

-- Q7-a Solution
SELECT department_id AS "Department ID", 
        department_name AS "Department Name", 
        city AS "City"
    FROM vwAllDepts;

-- b.For each city that has departments located in it 
--   display the number of departments by city

-- Q7-b Solution
SELECT city AS "City", 
       count(department_id) AS "Number of Department"
    FROM vwAllDepts
    GROUP BY city;

------------------------------------------------------------------------
-- Q8 Create a view called vwAllDeptSumm that consists of all departments
-- and includes for each department: department_id, department_name, 
-- number of employees, number of salaried employees, 
-- total salary of all employees. 
-- Number of Salaried must be different from number of employees. 
-- The difference is some get commission.

-- Q8 Solution
DROP VIEW vwAllDeptSumm;

CREATE VIEW vwAllDeptSumm AS (
    SELECT e.department_id AS "Departmetn ID",
           department_name AS "Department", 
           COUNT(employee_id) AS "Employees", 
           (SELECT COUNT(employee_id) 
                FROM employees
                WHERE commission_pct IS NULL 
                AND department_id = e.department_id) AS "Salaried Employees",
           SUM(salary) AS "Total Salary"
        FROM employees e 
        LEFT JOIN departments d ON e.department_id = d.department_id
        GROUP BY e.department_id, department_name
);

SELECT * FROM vwAllDeptSumm; 

------------------------------------------------------------------------
-- Q9 Use the vwAllDeptSumm view to display department name 
-- and number of employees for departments that 
-- have more than the average number of employees 

-- Q9 Solution
SELECT "Department", 
       "Employees"
    FROM vwAllDeptSumm
    WHERE "Employees" > (
        SELECT avg("Employees")
            FROM vwAllDeptSumm
    );

------------------------------------------------------------------------
-- Q10 a.Use the GRANT statement to allow another student (Neptune account)
-- to retrieve data for your employees table and to allow them to retrieve,
-- insert and update data in your departments table. Show proof

-- Q10-a Solution
GRANT SELECT
    ON employees
    TO dbs301_201d19;
    
GRANT INSERT, UPDATE
    ON departments
    TO dbs301_201d19;

-- b.Use the REVOKE statement to remove permission for that student 
-- to insert and update data in your departments table

-- Q10-b Solution
REVOKE INSERT, UPDATE
    ON departments
    FROM dbs301_201d19;

------------------------------------------------------------------------
-- END OF FILE
------------------------------------------------------------------------