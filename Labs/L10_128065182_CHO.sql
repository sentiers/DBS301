-- **********************************************
-- Name: Hyunji Cho
-- ID: 128065182
-- Date: Mar 27, 2020
-- Purpose: Submission for lab 10 for DBS301NDE
-- Description: Transactional SQL using the DBMS Oracle
-- **********************************************

------------------------------------------------------------------------
-- Q1 Create table L10Cities from table LOCATIONS, 
--  but only for location numbers less than 2000

-- Q1 Solution
CREATE TABLE L10Cities AS (
    SELECT * 
        FROM locations
        WHERE location_id < 2000
);

SELECT * FROM L10Cities;
DESCRIBE L10Cities;

------------------------------------------------------------------------
-- Q2 Create table L10Towns from table LOCATIONS,
-- but only for location numbers less than 1500
-- have same structure as table L10Cities.

-- Q2 Solution
CREATE TABLE L10Towns AS (
    SELECT *
        FROM locations
        WHERE location_id < 1500
);

SELECT * FROM L10Towns;
DESCRIBE L10Towns;

------------------------------------------------------------------------
-- Q3 Now you will empty your RECYCLE BIN with one powerful command. 
-- Then remove your table L10Towns, so that will remain in the recycle bin. 
-- Check that it is really there and what time was removed.  

-- Q3 Solution
PURGE RECYCLEBIN;

DROP TABLE L10Towns;

SHOW RECYCLEBIN;
-- drop time: 2020-03-30:17:28:43 

------------------------------------------------------------------------
-- Q4 Restore your table L10Towns from recycle bin and describe it.
-- Check what is in your recycle bin now.

-- Q4 Solution
FLASHBACK TABLE L10Towns TO BEFORE DROP;

DESCRIBE L10Towns;

SHOW RECYCLEBIN;

------------------------------------------------------------------------
-- Q5 Now remove table L10Towns so that does NOT remain in the recycle bin. 
-- Check that is really NOT there and then try to restore it. 
-- Explain what happened?

-- Q5 Solution
DROP TABLE L10Towns PURGE;

SHOW RECYCLEBIN;
-- "Object "" is INVALID, it may not be described."

FLASHBACK TABLE L10Towns TO BEFORE DROP;
-- ERROR: object not in RECYCLE BIN

------------------------------------------------------------------------
-- Q6 Create simple view called vwCAN_CITY_VU, based on table L10Cities 
-- contain only columns Street_Address, Postal_Code, City and State_Province
-- for locations only in CANADA. 
-- Then display all data from this view.

-- Q6 Solution
CREATE VIEW vwCAN_CITY_VU AS (
    SELECT street_address,
           postal_code,
           city,
           state_province
        FROM L10Cities
        WHERE upper(country_id) = 'CA'
);

SELECT * FROM vwCAN_CITY_VU;

------------------------------------------------------------------------
-- Q7 Modify your simple view so that will have following aliases 
-- instead of original column names: Str_Adr, P_Code, City and Prov 
-- and also will include cities from ITALY as well. 
-- Then display all data from this view. 

-- Q7 Solution
CREATE OR REPLACE VIEW vwCAN_CITY_VU AS (
    SELECT street_address AS "Str_Adr", 
           postal_code AS "P_Code", 
           city AS "City", 
           state_province AS "Prov"
        FROM L10Cities
        WHERE upper(country_id) IN('CA', 'IT')
);

SELECT * FROM vwCAN_CITY_VU;

------------------------------------------------------------------------
-- Q8 Create complex view called vwCity_DName_VU, 
-- based on tables LOCATIONS and DEPARTMENTS, 
-- contain only columns Department_Name, City and State_Province 
-- for locations in ITALY or CANADA. 
-- Include situations even when city does NOT have department yet. 
-- Then display all data from this view.

-- Q8 Solution
CREATE VIEW vwCity_DName_VU AS (
    SELECT department_name,
           city,
           state_province
        FROM locations
        LEFT JOIN departments USING(location_id)
        WHERE upper(country_id) IN('CA', 'IT')
);

SELECT * FROM vwCity_DName_VU;

------------------------------------------------------------------------
-- Q9 Modify your complex view so that will have following aliases 
-- instead of original column names: DName, City and Prov 
-- and also will include all cities outside United States 
-- Include situations even when city does NOT have department yet.
-- Then display all data from this view.

-- Q9 Solution
CREATE OR REPLACE VIEW vwCity_DName_VU AS (
    SELECT department_name AS "DName", 
           city AS "City", 
           state_province AS "Prov"
        FROM locations
        LEFT JOIN departments USING(location_id)
        WHERE upper(country_id) NOT IN ('US')
);        

SELECT * FROM vwCity_DName_VU;

------------------------------------------------------------------------
-- Q10 Create a transaction, ensuring a new transaction is started, 
-- merge the Marketing and Sales departments into “Marketing and Sales”.
-- 1. Create a new department such that the history of employees departments remains intact.
-- 2. The Sales staff will change locations to the existing Marketing department’s location.
-- 3. All staff from both previous departments will change to the new department.
-- Add appropriate save points where the transaction could potentially be rolled back to
-- Execute these statements, double check everything worked as intended,
-- and then once it works through a single execution, commit it.

-- Q10 Solution

COMMIT;

INSERT INTO departments VALUES (
    200, 'Marketing and Sales', NULL, (SELECT location_id 
                                          FROM departments 
                                          WHERE upper(department_name) = 'MARKETING'));
SAVEPOINT marketsale;

UPDATE departments 
    SET location_id = (SELECT location_id
                          FROM departments
                          WHERE upper(department_name) = 'MARKETING')
    WHERE department_id = (SELECT department_id
                              FROM departments
                              WHERE upper(department_name) = 'SALES');

SAVEPOINT movesales;

UPDATE employees
    SET department_id = (SELECT department_id
                            FROM departments
                            WHERE upper(department_name) = 'MARKETING AND SALES')
    WHERE department_id IN (SELECT department_id
                               FROM departments
                               WHERE upper(department_name) IN('SALES', 'MARKETING'));
    
SAVEPOINT movestaff;
    
COMMIT;
    
------------------------------------------------------------------------
-- Q11 Check in the Data Dictionary 
-- what Views (their names and definitions) are created so far in your account.
-- Then drop your vwCity_DName_VU and check Data Dictionary again.
-- What is different?

-- Q11 Solution
SELECT object_name
    FROM user_objects
    WHERE object_type = 'VIEW';
    
DROP VIEW vwCity_DName_VU;

SELECT object_name
    FROM user_objects
    WHERE object_type = 'VIEW';
    
--vwCity_DName_VU is deleted from the data dictionary

------------------------------------------------------------------------
-- END OF FILE
------------------------------------------------------------------------