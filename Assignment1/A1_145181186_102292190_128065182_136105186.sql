-- ***********************
-- Name: Mohammed Jaber
-- ID: 145181186

-- Name: Clinton Sheppard
-- ID: 102292190

-- Name: Hyunji Cho
-- ID: 128065182

-- Name: Vinicius Carassini
-- ID: 136105186

-- Date: February 21st, 2020
-- Purpose: Assignment 1 - DBS301
-- ***********************

/* ---- Question 1 -------------------------------
Display the employee number, full employee name, job and hire date of all employees hired in May or November of any year
------- Q1 Solution ---------------------------- */
SELECT  employee_id,
        substr(last_name ||', ' || first_name,1,25) AS "Full Name",
        job_id,
        to_char(LAST_DAY(hire_date), '"["fmMonth ddth "of" yyyy"]"') AS "Hire_Date"
    FROM employees
    WHERE to_char(hire_date,'fmMonth') IN ('May','November')
       AND to_char(hire_date,'YYYY') NOT IN (2015, 2016)
       ORDER BY hire_date DESC;
   
/* ---- Question 2 -------------------------------
List VPs and Managers whose monthly earning is outside the range of $6,000 and $11,000
------- Q2 Solution ---------------------------- */
SELECT  'Emp# ' || employee_id || ' named ' || first_name || ' ' || last_name || 
        ' who is ' || job_id || ' will have a new salary of ' || '$' ||
        CASE
            WHEN upper(job_id) LIKE ('%VP%') THEN round(salary * 1.25)
            ELSE round(salary * 1.18)
        END AS "Employees with increased Pay"
    FROM employees
    WHERE salary NOT BETWEEN 6000 AND 11000
        AND ( upper(job_id) LIKE ('%VP%')
              OR upper(job_id) LIKE ('%MAN%')
              OR upper(job_id) LIKE ('%MGR%')
               )
    ORDER BY salary DESC;
        
/* ---- Question 3 -------------------------------
Display the employee last name, salary, job title and manager# of 
all employees not earning a commission OR if they work in the SALES department, 
but only  if their total monthly salary with $1000 included bonus and  commission (if  earned) 
is  greater  than  $15,000.  
------- Q3 Solution ---------------------------- */
SELECT last_name AS "Last Name",
       salary AS "Salary",
       job_id AS "Job ID",
       NVL(to_char(manager_id), 'NONE') AS "Manager#",
       to_char((salary * (1 + NVL(commission_pct, 0)) + 1000 ) * 12, '$999,999.99') AS "Total Income"
    FROM employees
    WHERE (salary * (1 + NVL(commission_pct, 0)) > 14000)
        AND (commission_pct IS NULL OR department_id = 80) 
    ORDER BY "Total Income" DESC; 
    
    
/* ---- Question 4 -------------------------------
Display Department_id, Job_id and the Lowest salary for this combination 
under the alias Lowest Dept/Job Pay, but only if that Lowest Pay falls in the range $6000 - $17000. 
------- Q4 Solution ---------------------------- */
SELECT  department_id,
        job_id, 
        to_char(min(salary), '$999,999.99') AS "Lowest Dept/Job Pay"
    FROM employees
    WHERE upper(job_id) NOT LIKE '%REP'
        AND department_id NOT IN (60,80)
    GROUP BY job_id, department_id
    HAVING min(salary) BETWEEN 6000 AND 17000
    ORDER BY department_id, job_id;

/* ---- Question 5 -------------------------------
Display last_name, salary and job for all employees who earn more than 
all lowest paid employees per department outside the US locations.
------- Q5 Solution ---------------------------- */   
SELECT  last_name,
        salary,
        job_id
    FROM employees 
    WHERE salary > ALL (
        SELECT  NVL(min(salary), 0) AS "Lowest Salary"
          FROM employees e LEFT JOIN departments d ON e.department_id = d.department_id
              LEFT JOIN locations l ON d.location_id = l.location_id
          WHERE upper(country_id) NOT LIKE 'US'
          GROUP BY e.department_id
    )
        AND upper(job_id) NOT IN ('AD_PRES','AD_VP')
    ORDER BY job_id ASC;

/* ---- Question 6 -------------------------------
Who are the employees (show last_name, salary and job) who work either 
in IT or MARKETING department and earn more than the worst paid person in the ACCOUNTING department. 
------- Q6 Solution ---------------------------- */ 
SELECT  last_name AS "Last Name",
        job_id AS "Job ID",
        salary AS "Salary"
    FROM employees
    WHERE (department_id IN (
        SELECT department_id
        FROM departments
        WHERE upper(department_name) IN ('IT', 'MARKETING')
        ))
        AND (salary > (
            SELECT min(salary)
                FROM employees
                WHERE department_id = (
                    SELECT department_id
                        FROM departments
                        WHERE upper(department_name) = 'ACCOUNTING'
                )
            ))
    ORDER BY last_name;

/* ---- Question 7 -------------------------------
Display alphabetically the full name, job, 
salary (formatted as a currency amount incl. thousand separator, but no decimals) 
and department number for each employee who earns less than the best paid unionized employee 
(i.e. not the president nor any manager nor any VP), and who work in either SALES or MARKETING department.  
------- Q7 Solution ---------------------------- */ 
SELECT  substr(first_name ||' '|| last_name,1,25) AS "Employee",
        job_id AS "Job ID",
        LPAD(to_char(salary, '$999,999'), 15, '=') AS "Salary",
        e.department_id AS "Department ID"
    FROM employees e LEFT JOIN departments d ON e.department_id = d.department_id
    WHERE (upper(department_name) IN ('SALES','MARKETING'))
        AND ( salary < ( 
            SELECT  max(salary)
                FROM employees
                WHERE upper(job_id) NOT LIKE '%MAN%'
                    AND upper(job_id) NOT LIKE '%VP%'
                    AND upper(job_id) NOT LIKE '%PRES%'
            ))
    ORDER BY "Employee";

/* ---- Question 8 - Tricky One -------------------
Display department name, city and number of different jobs in each department. 
- If city is null, you should print Not Assigned Yet.
- This column should have alias City.
- Column that shows # of different jobs in a department should have the heading # of Jobs
- You should display ONE row per output line by limiting the width of the City to 24 characters.
- You need to show complete situation from the EMPLOYEE point of view, 
meaning include also employees who work for NO department (but do NOT display empty departments) 
and from the CITY point of view meaning you need to display all cities without departments as well.
------- Q8 Solution ---------------------------- */ 
SELECT  NVL(department_name, 'No Department') AS "Department Name",
        substr(NVL(to_char(city), 'Not Assigned Yet'), 1, 24) AS "City",
        count(distinct(job_id)) AS "# of Jobs"
    FROM employees e LEFT JOIN departments d ON e.department_id = d.department_id
       FULL JOIN locations l ON d.location_id = l.location_id
    GROUP BY department_name, city
    ORDER BY department_name;


