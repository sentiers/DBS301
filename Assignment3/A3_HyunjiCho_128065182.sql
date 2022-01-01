-- **********************************************
-- Name: Hyunji Cho
-- ID: 128065182
-- Date: April 14, 2020
-- Purpose: Submission for Assignment3 for DBS301NDE
-- Description: Bank accounts and everyday transactions
-- **********************************************

-- ---------------------------------------------------------------
-- CREATING TABLES
-- ---------------------------------------------------------------
DROP TABLE A3_TRANSACTIONS;
DROP TABLE A3_ACCOUNTS;
DROP TABLE A3_CUSTOMERS;
DROP TABLE A3_ACCOUNT_TYPES;
DROP SEQUENCE accountNO_seq;

CREATE TABLE A3_ACCOUNT_TYPES(
    AccountType     VARCHAR2(1)   NOT NULL,
    TypeName        VARCHAR2(15)  NOT NULL,
    CONSTRAINT a3_account_types_pk PRIMARY KEY(AccountType)
);

CREATE TABLE A3_CUSTOMERS(
    customerID      NUMBER(10)    GENERATED by default on null as IDENTITY(START with 1 INCREMENT by 1),
    firstname       VARCHAR2(20)  NOT NULL,
    lastname        VARCHAR2(20)  NOT NULL,
    email           VARCHAR2(50)  NOT NULL,
    DOB             DATE,
    phone           VARCHAR2(10),
    CONSTRAINT a3_customers_pk PRIMARY KEY(customerID)
);

CREATE SEQUENCE accountNO_seq
    INCREMENT BY 15
    START WITH 600000
    MAXVALUE 9999999;

CREATE TABLE A3_ACCOUNTS(
    accountNo       NUMBER(10),
    accountType     VARCHAR2(1)   DEFAULT('C'),
    customerID      NUMBER(10)    NOT NULL,
    currentBalance  DECIMAL(10,2) DEFAULT(0.00),
    dtOpen          DATE          DEFAULT(sysdate),
    isActive        NUMBER(3)     DEFAULT(1),
    CONSTRAINT a3_accounts_accountNo_pk PRIMARY KEY(accountNo),
    CONSTRAINT a3_accounts_accounttype_fk FOREIGN KEY(accountType)
        REFERENCES A3_ACCOUNT_TYPES(AccountType),
    CONSTRAINT a3_accounts_customerid_fk FOREIGN KEY(customerID)
        REFERENCES A3_CUSTOMERS(customerID),
    CONSTRAINT a3_accounts_isactive_chk CHECK(isActive IN(1, 0)),
    CONSTRAINT a3_accounts_currentbalance_chk CHECK(currentBalance >= 0.00)
);

CREATE TABLE A3_TRANSACTIONS(
    transactionID   NUMBER(10)    GENERATED by default on null as IDENTITY(START with 1 INCREMENT by 1),
    accountNo       NUMBER(10)    NOT NULL,
    transactionType VARCHAR2(1)   NOT NULL,
    amount          DECIMAL(10,2) DEFAULT(0.00),
    descriptions    VARCHAR2(25)  NOT NULL,
    transDate       DATE          DEFAULT(sysdate),
    refNum          VARCHAR2(12),
    CONSTRAINT a3_transactions_pk PRIMARY KEY(transactionID),
    CONSTRAINT a3_transactions_accountno_fk FOREIGN KEY(accountNo)
        REFERENCES A3_ACCOUNTS(accountNo),
    CONSTRAINT a3_transactions_type_chk CHECK(transactionType IN ('D','C'))
);





-- ---------------------------------------------------------------
-- Tasks - 1
-- ---------------------------------------------------------------
-- Create a series of transactions that suit the following scenarios.  
-- Make sure that each transaction includes the updating of the currentBalance in the accounts table.



-- a. Create a customer with your name
INSERT INTO A3_CUSTOMERS (firstname, lastname, email, DOB, phone)
    VALUES('Hyunji', 'Cho', 'sentiersg@gmail.com', to_date(19970309,'yyyymmdd'), '6478315779');

COMMIT;



-- b. You open a chequing account at the bank and deposit $500.00

-------- Add Chequeing account type into system

INSERT INTO A3_ACCOUNT_TYPES (AccountType, TypeName)
    VALUES('C', 'Chequing');
    
COMMIT;

-------- Open a chequing account at the bank

SAVEPOINT open_chequing;

INSERT INTO A3_ACCOUNTS(accountNo, accountType, customerID)
    VALUES(accountNo_seq.NEXTVAL, 'C', 1);

INSERT INTO A3_TRANSACTIONS(accountNo, transactionType, descriptions)
    VALUES(600000, 'C', 'Opening Chequing');

-- ROLLBACK TO open_chequing;    //If there is an error 

COMMIT;

-------- Deposit $500.00

SAVEPOINT cash_deposit;

INSERT INTO A3_TRANSACTIONS(accountNo, transactionType, amount, descriptions)
    VALUES(600000, 'C', 500.00, 'Cash Deposit');

UPDATE A3_ACCOUNTS
    SET currentBalance = currentBalance + 500
    WHERE customerID = 1 AND accountType = 'C';

-- ROLLBACK TO cash_deposit;    //If there is an error

COMMIT;



-- c. You open a savings account at the bank and your parents deposit $1000.00 through e-transfer

-------- Add Savings account type into system

INSERT INTO A3_ACCOUNT_TYPES (AccountType, TypeName)
    VALUES('S', 'Savings');

COMMIT;

-------- Open a savings account at the bank

SAVEPOINT open_savings;

INSERT INTO A3_ACCOUNTS(accountNo, accountType, customerID)
    VALUES(accountNo_seq.NEXTVAL, 'S', 1);

INSERT INTO A3_TRANSACTIONS(accountNo, transactionType, descriptions)
    VALUES(600015, 'C', 'Opening Savings');
    
-- ROLLBACK TO open_savings;    //If there is an error 

COMMIT;

-------- Parents deposit $1000.00 through e-transfer

SAVEPOINT e_transfer;

INSERT INTO A3_TRANSACTIONS(accountNo, transactionType, amount, descriptions)
    VALUES(600015, 'C', 1000.00, 'e-Transfer');

UPDATE A3_ACCOUNTS
    SET currentBalance = currentBalance + 1000.00
    WHERE customerID = 1 AND accountType = 'S';

-- ROLLBACK TO e_transfer;    //If there is an error 

COMMIT;



-- d. You buy groceries at Walmart and debit $112.34 from chequing

SAVEPOINT debit_walmart;

INSERT INTO A3_TRANSACTIONS(accountNo, transactionType, amount, descriptions)
    VALUES(600000, 'D', -112.34, 'Walmart');

UPDATE A3_ACCOUNTS
    SET currentBalance = currentBalance - 112.34
    WHERE customerID = 1 AND accountType = 'C';

-- ROLLBACK TO debit_walmart;    //If there is an error 

COMMIT;



-- e. You purchase a song from iTunes for $1.99 from chequing. You receive a confirmation code of CQ3E5RZ.

SAVEPOINT debit_itunes;

INSERT INTO A3_TRANSACTIONS(accountNo, transactionType, amount, descriptions, refNum)
    VALUES(600000, 'D', -1.99, 'iTunes', 'CQ3E5RZ');

UPDATE A3_ACCOUNTS
    SET currentBalance = currentBalance - 1.99
    WHERE customerID = 1 AND accountType = 'C';

-- ROLLBACK TO debit_itunes;    //If there is an error 

COMMIT;



-- f. You have to pay first and last months rent on your new apartment.
--    The monthly rent is $800 and you write a cheque (#005) for it (i.e. chequing account).

SAVEPOINT create_cheque;

INSERT INTO A3_TRANSACTIONS(accountNo, transactionType, amount, descriptions, refNum)
    VALUES(600000, 'D', -1600, 'Cheque', '#005');

UPDATE A3_ACCOUNTS
    SET currentBalance = currentBalance - 1600
    WHERE customerID = 1 AND accountType = 'C';

--------  ERROR! NEED TO ROLLBACK

ROLLBACK TO create_cheque;

COMMIT;



-- g. The cheque you wrote bounces (NSF-Non-Sufficient Funds) and the bank charges you a $45 fee

SAVEPOINT nsf;

INSERT INTO A3_TRANSACTIONS(accountNo, transactionType, amount, descriptions)
    VALUES(600000, 'D', -45, 'NSF');
    
UPDATE A3_ACCOUNTS
    SET currentBalance = currentBalance - 45
    WHERE customerID = 1 AND accountType = 'C';

-- ROLLBACK TO nsf;    //If there is an error 

COMMIT;



-- h. Your Mom and Dad withdrawal money from your RESP for school expenses $2000 
--    which they deposit directly into your savings account.

SAVEPOINT direct_deposit;

INSERT INTO A3_TRANSACTIONS(accountNo, transactionType, amount, descriptions)
    VALUES(600015, 'C', 2000, 'Direct Deposit');

UPDATE A3_ACCOUNTS
    SET currentBalance = currentBalance + 2000
    WHERE customerID = 1 AND accountType = 'S';

-- ROLLBACK TO direct_deposit;    //If there is an error 

COMMIT;



-- i. You get a certified cheque for the first and last month's rent plus the $25 fee your landlord charges you.
--    There is an $8 fee for the certified cheque charged to you by the bank.

-------- Transfer money from savings to chequing in order to get certified cheque

SAVEPOINT transfer;

INSERT INTO A3_TRANSACTIONS(accountNo, transactionType, amount, descriptions)
    VALUES(600015, 'D', -2000, 'Transfer to 600000');

UPDATE A3_ACCOUNTS
    SET currentBalance = currentBalance - 2000
    WHERE customerID = 1 AND accountType = 'S';

INSERT INTO A3_TRANSACTIONS(accountNo, transactionType, amount, descriptions)
    VALUES(600000, 'C', 2000, 'Transfer from 600015');

UPDATE A3_ACCOUNTS
    SET currentBalance = currentBalance + 2000
    WHERE customerID = 1 AND accountType = 'C';

-- ROLLBACK TO transfer;    //If there is an error 

COMMIT;

-------- Get certified cheque and landloard charges the rent

SAVEPOINT rent;

INSERT INTO A3_TRANSACTIONS(accountNo, transactionType, amount, descriptions, refNum)
    VALUES(600000, 'D', -1600, 'Cheque', '#005');

UPDATE A3_ACCOUNTS
    SET currentBalance = currentBalance - 1600
    WHERE customerID = 1 AND accountType = 'C';

-- ROLLBACK TO rent;    //If there is an error 

COMMIT;

-------- additional $25 fee for landlord

SAVEPOINT landlord;

INSERT INTO A3_TRANSACTIONS(accountNo, transactionType, amount, descriptions)
    VALUES(600000, 'D', -25, 'Withdraw');

UPDATE A3_ACCOUNTS
    SET currentBalance = currentBalance - 25
    WHERE customerID = 1 AND accountType = 'C';

-- ROLLBACK TO landlord;    //If there is an error 

COMMIT;

-------- additional $8 fee for certified cheque

SAVEPOINT cheque_bank;

INSERT INTO A3_TRANSACTIONS(accountNo, transactionType, amount, descriptions)
    VALUES(600000, 'D', -8, 'Certified cheque fee');

UPDATE A3_ACCOUNTS
    SET currentBalance = currentBalance - 8
    WHERE customerID = 1 AND accountType = 'C';

-- ROLLBACK TO cheque_bank;    //If there is an error 

COMMIT;



-- j. You go to the ATM to take out $40 cash to pay your friend back 
--    for helping you move your stuff into your new apartment.

SAVEPOINT withdraw;

INSERT INTO A3_TRANSACTIONS(accountNo, transactionType, amount, descriptions)
    VALUES(600000, 'D', -40, 'Withdraw');

UPDATE A3_ACCOUNTS
    SET currentBalance = currentBalance - 40
    WHERE customerID = 1 AND accountType = 'C';

-- ROLLBACK TO withdraw;    //If there is an error 

COMMIT;



-- k. Using online banking, you pay your Rogers mobile phone bill of $64.45.
--    You receive a confirmation code of X8U2 and your rogers account number is 345678.

SAVEPOINT online_banking;

INSERT INTO A3_TRANSACTIONS(accountNo, transactionType, amount, descriptions, refNum)
    VALUES(600000, 'D', -64.45, 'Rogers 345678', 'X8U2');

UPDATE A3_ACCOUNTS
    SET currentBalance = currentBalance - 64.45
    WHERE customerID = 1 AND accountType = 'C';

-- ROLLBACK TO online_banking;    //If there is an error 

COMMIT;





-------- Result

SELECT * FROM A3_TRANSACTIONS;

SELECT * FROM A3_ACCOUNTS;





-- ---------------------------------------------------------------
-- Tasks - 2
-- ---------------------------------------------------------------
-- Each month, the bank runs a balance statement.
-- This statement produces a list of transactions and includes each transaction amount,
-- the details of the transaction along with the total debits, total credits and ending bank balance.  



-- a. Outputs a list of transactions, in chronological order.  
--    Show the running balance beside each transaction in the transaction list.

SELECT transactionID AS "transID",
       to_char(transDate, 'mm/dd/yyyy') AS "Date",
       descriptions AS "Details",
       to_char(amount,'$9,990.99') AS "Amount",
       to_char((sum(amount) over (order by transactionID)),'$9,990.99') AS "Balance"
    FROM A3_TRANSACTIONS;



-- a. BONUS MARKS

-- I also sepearated balance into chequing balance and savings balance

SELECT transactionID AS "transID",
       to_char(transDate, 'mm/dd/yyyy') AS "Date",
       descriptions AS "Details",
       CASE when transactionType = 'C' THEN to_char(amount,'$9,990.99') ELSE ' ' END AS "Credits",
       CASE when transactionType = 'D' THEN to_char(amount,'$9,990.99') ELSE ' ' END AS "Debits",
       CASE when accountNo = 600000 
            THEN to_char((sum(CASE when accountNo = 600000 
                                    THEN amount 
                                    ELSE 0 
                                    END) over (order by transactionID)),'$9,990.99') 
            ELSE ' ' 
            END AS "Chequing",
       CASE when accountNo = 600015 
            THEN to_char((sum(CASE when accountNo = 600015 
                                    THEN amount 
                                    ELSE 0 
                                    END) over (order by transactionID)),'$9,990.99') 
            ELSE ' ' 
            END AS "Savings"
    FROM A3_TRANSACTIONS;



-- b. Write SQL to calculate the total debits and credits (separate totals even though the amounts are in the same field)

SELECT to_char((sum(CASE when transactionType = 'C' THEN amount ELSE 0 END)), '$9,990.99') AS "Credits Total",
       to_char((sum(CASE when transactionType = 'D' THEN amount ELSE 0 END)), '$9,990.99') AS "Debits Total"
    FROM A3_TRANSACTIONS;



-- c. Write SQL to verify that the sum of all transactions adds up to the same amount as the currentBalance.
--    If not, output the difference.

-------- Sum of all Transaction that used Chequing account & current balance of Chequing account

SELECT sum(t.amount) AS "Chequing Transaction Total",
       a.currentBalance AS "Chequing Current Balance",
       (sum(t.amount)-a.currentBalance) AS "Difference"
FROM A3_TRANSACTIONS t
JOIN A3_ACCOUNTS a USING(accountNO)
WHERE a.accountType = 'C'
GROUP BY a.currentBalance;

-------- Sum of all Transaction that used Savings account & current balance of Savings account

SELECT sum(t.amount) AS "Savings Transaction Total",
       a.currentBalance AS "Savings Current Balance",
       (sum(t.amount)-a.currentBalance) AS "Difference"
FROM A3_TRANSACTIONS t
JOIN A3_ACCOUNTS a USING(accountNO)
WHERE a.accountType = 'S'
GROUP BY a.currentBalance;





-- ---------------------------------------------------------------
-- Tasks - 3
-- ---------------------------------------------------------------
-- Write a short paragraph (100-150 words) about your own personal experience of learning in DBS301.
-- What overall things did you learn and how did this course help you become a better IT professional?

/* 
My overall experience in this course was challenging but rewarding. I have gained a deeper knowledge 
of SQL such as data definition language and data manipulation language using Oracle SQL developer. The
labs that were provided for this course encouraged me to try numerous SQL statements, which made me 
realize how important it is to enter data accurately, as one small mistake such as entering a wrong 
value accidentally can completely affect the outcome and create errors when running the code. 
Also, I learned that the SQL style guide cannot be ignored since it allows programmers to understand
the flow of the code better and discover the error in the code more easily if there are any. 
Finally, this course has allowed me to learn the practical skills needed to become a better IT
professional, as major assignments help in learning how to work as a group, design databases 
logically, handle data efficiently, and also understand transactions.
*/





   
   
