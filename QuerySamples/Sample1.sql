-- Convert string to date. 

-- 1. Microsoft SQL Server (MSSQL):
SELECT CAST('31-01-2021' as DATE) as date_value;

-- 2. PostgreSQL:
SELECT TO_DATE('31-01-2021', 'DD-MM-YYYY') as date_value;

---------
-- Microsoft SQL Server (MSSQL): GETDATE() will returns today’s date along with timestamp value.
-- Below query would return the date and timestamp.

SELECT DATEADD(DAY, -1, GETDATE());

-- Below query only returns the date.
SELECT DATEADD(DAY, -1, CAST(GETDATE() AS DATE));

-- PostgreSQL: In PostgreSQL as well, we can simple subtract an integer from a date value hence
-- we do not need to use a function to find yesterday’s date as shown in below query. CURRENT_DATE will return today’s date.
SELECT CURRENT_DATE - 1 as previous_day FROM DUAL;

-- Get the first name from the full name.
-- Microsoft SQL Server (MSSQL)

SELECT SUBSTRING(full_name, 1, CHARINDEX(' ', full_name) - 1) as first_name;

-- PostgreSQL

SELECT SUBSTR(full_name, 1, POSITION(' ' IN full_name) - 1) as first_name;

-- What is the difference between RANK DENSE_RANK AND ROW_NUMBER()?

-- Where are stored table varables?
DECLARE @ExperiementTable TABLE
( 
TestColumn_1 INT, TestColumn_2 VARCHAR(40), TestColumn_3 VARCHAR(40)
);
SELECT TABLE_CATALOG, TABLE_SCHEMA, COLUMN_NAME, DATA_TYPE
FROM tempdb.INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME LIKE 'TestColumn%';
-- Answer: table variables are stored in the tempdb database
-- T: declare table and add primary key.
DECLARE @TestTable TABLE
(ID INT NOT NULL  )
    
ALTER TABLE @TestTable
ADD CONSTRAINT PK_ID PRIMARY KEY (ID)
-- Above example won't work because you add all constraints during 
-- table creation.
-- T: add all possible constraints to temp table.
DECLARE @TestTable TABLE
(ID INT PRIMARY KEY,
Col1 VARCHAR(40) UNIQUE,
Col2 VARCHAR(40) NOT NULL,
Col3 int CHECK (Col3>=18))
    
 INSERT INTO @TestTable
 VALUES(1,'Value1',12 , 20)
    
 SELECT * FROM @TestTable
--