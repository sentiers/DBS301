-- **********************************************
-- Name: Hyunji Cho
-- ID: 128065182
-- Date: Feb 03, 2020
-- Purpose: Submission for Lab 5 for DBS301NDE
-- Description: using SELECT command and
--              incorporating multiple tables
-- **********************************************

------------------------------------------------------------------------
-- Part A
------------------------------------------------------------------------
-- Q1 display department name, city, street and postal code for departments
-- sorted by city and department name
    
-- Q1 Solution
SELECT  department_name AS "Department",
        city AS "City",
        street_address AS "Street",
        postal_code AS "Postal Code"
    FROM departments
    JOIN locations
        USING (location_id)
    ORDER BY city, department_name;
    
------------------------------------------------------------------------
-- Q2 Display full name of employees as a single field ex) “Last, First”
-- display their hire date, salary, department name and city
-- but only for departments with names starting with an A or S 
-- sorted by department name and employee name

-- Q2 Solution
SELECT  last_name || ', ' || first_name AS "Employee Name",
        hire_date AS "Hired Date",
        salary AS "Salary",
        department_name AS "Department",
        city As "City"
    FROM employees 
    JOIN (departments JOIN locations USING (location_id))
        USING (department_id)
    WHERE (upper(department_name) LIKE 'A%')
        OR (upper(department_name) LIKE 'S%')
    ORDER BY department_name, "Employee Name";

------------------------------------------------------------------------
-- Q3 Display the full name of the manager of each department 
-- in states/provinces of Ontario, New Jersey and Washington
-- along with the department name, city, postal code and province name
-- Sort by city and then by department name

-- Q3 Solution
SELECT  first_name || ' ' || last_name AS "Manager Name",
        department_name AS "Department",
        city AS "City",
        postal_code AS "Postal Code",
        state_province AS "State/Province"
    FROM employees 
    JOIN (departments JOIN locations USING (location_id))
        ON departments.manager_id = employees.employee_id
    WHERE lower(state_province) IN ('ontario', 'new jersey', 'washington')
    ORDER BY city, department_name;

------------------------------------------------------------------------
-- Q4 Display employee’s last name and employee number
-- along with their manager’s last name and manager number
-- Label the columns Employee, Emp#, Manager, and Mgr# respectively

-- Q4 Solution
SELECT  e.last_name AS "Employee",
        e.employee_id AS "Emp#",
        m.last_name AS "Manager",
        m.employee_id AS "Mgr#"
    FROM employees e, employees m
        WHERE (m.employee_id = e.manager_id);

------------------------------------------------------------------------
-- Part B
------------------------------------------------------------------------
-- Q5 Display the department name, city, street address, postal code 
-- and country name for all Departments
-- Use the JOIN and USING form of syntax
-- Sort by department name descending

-- Q5 Solution
SELECT  department_name AS "Department",
        city AS "City",
        street_address AS "Street",
        postal_code AS "Postal Code",
        country_name AS "Country"
    FROM departments 
    JOIN locations USING (location_id) 
    JOIN countries USING (country_id)
    ORDER BY department_name DESC;

------------------------------------------------------------------------
-- Q6 Display employee's full name, hire date and salary together with
-- department name, but only for departments which names start with A or S
--      Full name should be formatted:  First / Last
--      Use the JOIN and ON form of syntax.
--      Sort the output by department name and then by last name

-- Q6 Solution
SELECT  first_name || ' / ' || last_name AS "Employee Name",
        hire_date AS "Hired Date",
        to_char(salary,'$99,999.99') AS "Salary",
        department_name AS "Department"
    FROM employees 
    JOIN departments 
        ON employees.department_id = departments.department_id
    WHERE (upper(department_name) LIKE 'A%') 
        OR (upper(department_name) LIKE 'S%')
    ORDER BY department_name, last_name;

------------------------------------------------------------------------
-- Q7 Display full name of the manager of each department 
-- in provinces Ontario, New Jersey and Washington 
-- plus department name, city, postal code and province name
--      Full name should be formatted: Last, First
--      Use the JOIN and ON form of syntax
--      Sort the output by city and then by department name

-- Q7 Solution
SELECT  last_name || ', ' || first_name AS "Manager",
        department_name AS "Department",
        city AS "City",
        postal_code AS "Postal Code",
        state_province AS "State/Province"
    FROM employees, departments, locations
    WHERE (departments.manager_id = employees.employee_id)
        AND (departments.location_id = locations.location_id)
        AND (lower(state_province) IN('ontario', 'new jersey', 'washington'))
    ORDER BY city, department_name;
    
------------------------------------------------------------------------
-- Q8 Display the department name and Highest, Lowest and Average pay 
-- per each department, and Name these results High, Low and Avg
--      Use JOIN and ON form of the syntax
--      Sort by department with highest average salary

-- Q8 Solution
SELECT  department_name AS "Department",
        to_char(MAX(salary),'$999,999.99') AS "High",
        to_char(MIN(salary),'$999,999.99') AS "Low",
        to_char(AVG(salary),'$999,999.99') AS "Avg"
    FROM employees e 
    JOIN departments d
        ON e.department_id = d.department_id
    GROUP BY department_name
    ORDER BY ROUND(AVG(salary),2) DESC;

------------------------------------------------------------------------
-- Q9 Display the employee last name and employee number
-- along with their manager’s last name and manager number
--      Label the columns Employee, Emp#, Manager, and Mgr#, respectively. 
--      Include also employees who do NOT have a manager 
--      and also employees who do NOT supervise anyone 

-- Q9 Solution
SELECT  e.last_name AS "Employee",
        e.employee_id AS "Emp#",
        m.last_name AS "Manager",
        m.employee_id AS "Mgr#"
    FROM employees e 
    FULL OUTER JOIN employees m 
        ON e.manager_id = m.employee_id;
        
------------------------------------------------------------------------
-- END OF FILE
------------------------------------------------------------------------
