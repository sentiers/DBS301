-- **********************************************
-- Name: Hyunji Cho
-- ID: 128065182
-- Date: Mar 14, 2020
-- Purpose: Submission for lab 9 for DBS301NDE
-- Description: Data Definitional Language (Create and Alter)
--              and DML (Data Manipulation Language)
-- **********************************************

------------------------------------------------------------------------
-- Q1 Create table L09SalesRep and load it with data from table EMPLOYEES table.
-- only for people in department 80.

-- Q1 Solution
CREATE TABLE L09SalesRep AS (
    SELECT  employee_id "RepId", 
            first_name "FName",
            last_name "LName", 
            phone_number "Phone#", 
            salary AS "Salary",
            commission_pct AS "Commission"
        FROM employees
        WHERE department_id = 80
);

SELECT * FROM L09SalesRep;
    
------------------------------------------------------------------------
-- Q2 Create L09Cust table.

-- Q2 Solution    
CREATE TABLE L09Cust (
   Cust#	  	NUMBER(6),
   CustName 	VARCHAR2(30),
   City 		VARCHAR2(20),
   Rating		CHAR(1),
   Comments	    VARCHAR2(200),
   SalesRep#	NUMBER(7) 
);

INSERT INTO L09Cust VALUES (501, 'ABC LTD.', 'Montreal', 'C', '', 201);
INSERT INTO L09Cust VALUES (502, 'Black Giant', 'Ottawa', 'B', '', 202);
INSERT INTO L09Cust VALUES (503, 'Mother Goose', 'London', 'B', '', 202);
INSERT INTO L09Cust VALUES (701, 'BLUE SKY LTD', 'Vancouver', 'B', '', 102);
INSERT INTO L09Cust VALUES (702, 'MIKE and SAM Inc.', 'Kingston', 'A', '', 107);
INSERT INTO L09Cust VALUES (703, 'RED PLANET', 'Mississauga', 'C', '', 107);
INSERT INTO L09Cust VALUES (717, 'BLUE SKY LTD', 'Regina', 'D', '', 102);

SELECT * FROM L09Cust;

------------------------------------------------------------------------
-- Q3 Create table L09GoodCust
-- only if their rating is A or B. 

-- Q3 Solution
CREATE TABLE L09GoodCust AS (
    SELECT Cust# AS "CustID",
           CustName AS "Name",
           City AS "Location",
           SalesRep# AS "RepID"
        FROM L09Cust
        WHERE Rating IN ('A', 'B')
);

SELECT * FROM L09GoodCust

------------------------------------------------------------------------
-- Q4 add new column to table L09SalesRep called JobCode
-- Do a DESCRIBE L09SalesRep to ensure it executed

-- Q4 Solution
ALTER TABLE L09SalesRep
    ADD JobCode VARCHAR2(12);
    
DESCRIBE L09SalesRep;

------------------------------------------------------------------------
-- Q5 Declare column Salary in table L09SalesRep as mandatory one 
-- and Column Location in table L09GoodCust as optional one. 
-- Lengthen FNAME in L09SalesRep to 37
-- Do it by using SQL

-- Q5 Solution
ALTER TABLE L09SalesRep
    MODIFY "Salary" NOT NULL;
    
DESCRIBE L09SalesRep;

--------
DESCRIBE L09GoodCust;

ALTER TABLE L09GoodCust 
    MODIFY "CustID" NOT NULL;
ALTER TABLE L09GoodCust 
    MODIFY "Name" NOT NULL;
ALTER TABLE L09GoodCust
    MODIFY "Location" NULL;
ALTER TABLE L09GoodCust 
    MODIFY "RepID" NOT NULL;

DESCRIBE L09GoodCust;

--------
ALTER TABLE L09SalesRep
    MODIFY "FName" VARCHAR2(37);

DESCRIBE L09SalesRep;

--------
SELECT MAX(LENGTH(TRIM("Name"))) AS "MaxLen"
    FROM L09GoodCust;

ALTER TABLE L09GoodCust
    MODIFY "Name" VARCHAR2(17);

DESCRIBE L09GoodCust;

SELECT * FROM L09GoodCust;

------------------------------------------------------------------------
-- Q6 Now get rid of the column JobCode in table L09SalesRep 
-- in a way that will not affect daily performance. 

-- Q6 Solution
ALTER TABLE L09SalesRep
    DROP COLUMN JobCode;
    
DESCRIBE L09SalesRep;

------------------------------------------------------------------------
-- Q7 Declare PK constraints in both new tables ? RepId and CustId

-- Q7 Solution
ALTER TABLE L09SalesRep
    ADD CONSTRAINT salesrep_pk PRIMARY KEY ("RepId");
    
------------
ALTER TABLE L09Cust
    ADD CONSTRAINT cust_pk PRIMARY KEY (Cust#);

------------------------------------------------------------------------
-- Q8 Declare UK constraints in both new tables ? Phone# and Name

-- Q8 Solution
ALTER TABLE L09SalesRep
    ADD CONSTRAINT salesrep_phone_uk UNIQUE ("Phone#");

-------------
ALTER TABLE L09Cust
    ADD CONSTRAINT cust_name_uk UNIQUE (CustName);

------------------------------------------------------------------------
-- Q9 Restrict amount of Salary column to be in the range [6000, 12000]
-- and Commission to be not more than 50%.

-- Q9 Solution
ALTER TABLE L09SalesRep
    ADD CONSTRAINT salesrep_salary_ck CHECK("Salary" BETWEEN 6000 AND 12000);
    
ALTER TABLE L09SalesRep
    ADD CONSTRAINT salesrep_Commission_ck CHECK("Commission" <= 0.5);

------------------------------------------------------------------------
-- Q10 Ensure that only valid RepId numbers from table L09SalesRep 
-- may be entered in the table L09GoodCust. 
-- Why this statement has failed?

-- Q10 Solution
ALTER TABLE L09GoodCust
    ADD CONSTRAINT goodcust_salesrep_fk FOREIGN KEY ("RepID") 
        REFERENCES L09SalesRep("RepId"); 
-- an alter table validating constraint failed because the table has child records.
    
------------------------------------------------------------------------
-- Q11 Firstly write down the values for RepId column in table L09GoodCust
-- and then make all these values blank. 
-- Now redo the question 10. Was it successful? 

-- Q11 Solution
ALTER TABLE L09GoodCust 
    MODIFY "RepID" NUMBER(7) NULL;

DESCRIBE L09GoodCust;
    
UPDATE L09GoodCust SET "RepID" = NULL; 

SELECT * FROM L09GoodCust; 

ALTER TABLE L09GoodCust
    ADD CONSTRAINT goodcust_salesrep_fk FOREIGN KEY ("RepID") 
        REFERENCES L09SalesRep("RepId");
-- it was successful

------------------------------------------------------------------------
-- Q12 Disable this FK constraint
-- and enter old values for RepId in table L09GoodCust and save them. 
-- Then try to enable your FK constraint. What happened? 

-- Q12 Solution
ALTER TABLE L09GoodCust
    DISABLE CONSTRAINT goodcust_salesrep_fk;
    
SELECT * FROM L09GoodCust;

UPDATE L09GoodCust SET "RepID" = 102 WHERE "CustID" = 701;
UPDATE L09GoodCust SET "RepID" = 107 WHERE "CustID" = 702;
UPDATE L09GoodCust SET "RepID" = 202 WHERE "CustID" = 502;
UPDATE L09GoodCust SET "RepID" = 202 WHERE "CustID" = 503;

SELECT * FROM L09GoodCust;

ALTER TABLE L09GoodCust
    ENABLE CONSTRAINT goodcust_salesrep_fk;
--an alter table validating constraint failed because the table has child records.

------------------------------------------------------------------------
-- Q13 Get rid of FK constraint. 
-- Then modify your CK constraint from question 9 
-- to allow Salary amounts from 5000 to 15000.

-- Q13 Solution
ALTER TABLE L09GoodCust
    DROP CONSTRAINT goodcust_salesrep_fk;
    
ALTER TABLE L09SalesRep
    DROP CONSTRAINT salesrep_salary_ck;
    
ALTER TABLE L09SalesRep
    ADD CONSTRAINT salesrep_salary_ck CHECK ("Salary" BETWEEN 5000 AND 15000);

------------------------------------------------------------------------
-- Q14 Describe both new tables L09SalesRep and L09GoodCust 
-- and then show all constraints for these two tables

-- Q14 Solution
DESCRIBE L09SalesRep;
DESCRIBE L09GoodCust;

SELECT constraint_name,
       constraint_type,
       search_condition,
       table_name
    FROM user_constraints
    WHERE lower(table_name) IN ('l09salesrep','l09goodcust')
    ORDER BY table_name, constraint_type;

------------------------------------------------------------------------
-- Q15 Create a new table in which we will store inventory

-- Q15 Solution
DROP TABLE L09Inventory;

CREATE TABLE L09Inventory (
   productID       INT              GENERATED BY DEFAULT ON NULL AS IDENTITY,
   productName     VARCHAR2(20)     NOT NULL,
   Barcode         INT              NOT NULL,
   SerialNum	   VARCHAR2(8)      NOT NULL,
   SellingPrice	   DECIMAL(9,2)     DEFAULT 0.00,
   IsActive	       INT              DEFAULT 1,
   "Category"      VARCHAR2(12)     DEFAULT 'none',
   PRIMARY KEY (productID),
   CONSTRAINT inventory_productid_ck CHECK (productID > 0),
   CONSTRAINT inventory_productname_ck CHECK (length(productName) > 5),
   CONSTRAINT inventory_barcode_ck CHECK (Barcode > 10000),
   CONSTRAINT inventory_serialnum_ck CHECK (SerialNum > 'SN111111'),
   CONSTRAINT inventory_sellingprice_ck CHECK (SellingPrice BETWEEN 0 AND 999999.99),
   CONSTRAINT inventory_isactive_ck CHECK (IsActive IN(0,1))
);

INSERT INTO L09Inventory VALUES (1, 'NoteBook', 24356, 'SN232453', 3456.00, 1, 'Stationary');

SELECT * FROM L09Inventory;

------------------------------------------------------------------------
-- END OF FILE
------------------------------------------------------------------------