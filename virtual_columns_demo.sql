/*
=============================================================================
  Snowflake Virtual Columns — Complete Demo
  GitHub: snowflake-scd2-architect-lab
  
  This script demonstrates:
    1. Creating tables with virtual columns
    2. Inserting data (virtual columns auto-compute)
    3. Querying virtual columns
    4. Comparing virtual vs stored column performance
    5. Altering virtual column formulas (instant business rule changes)
    6. Limitations demo (COPY INTO, clustering)
=============================================================================
*/

-- ============================================
-- SETUP
-- ============================================

USE ROLE ACCOUNTADMIN;
CREATE DATABASE IF NOT EXISTS VIRTUAL_COL_DEMO;
CREATE SCHEMA IF NOT EXISTS VIRTUAL_COL_DEMO.DEMO;
USE SCHEMA VIRTUAL_COL_DEMO.DEMO;

-- ============================================
-- 1. CREATE TABLE WITH VIRTUAL COLUMNS
-- ============================================

CREATE OR REPLACE TABLE CUSTOMER_VIRTUAL (
    CUSTOMER_ID STRING,
    FIRST_NAME STRING,
    LAST_NAME STRING,
    ADDRESS STRING,
    CITY STRING,
    STATE STRING,
    COUNTRY STRING,
    CREATED_TS TIMESTAMP,

    FULL_NAME STRING AS (FIRST_NAME || ' ' || LAST_NAME),

    ATTR_HASH STRING AS (
        MD5(CONCAT_WS('|', FIRST_NAME, LAST_NAME, ADDRESS, CITY, STATE, COUNTRY))
    ),

    LOCATION_SUMMARY STRING AS (
        CITY || ', ' || STATE || ' - ' || COUNTRY
    )
);

-- ============================================
-- 2. INSERT DATA (no need to compute virtual columns)
-- ============================================

INSERT INTO CUSTOMER_VIRTUAL (CUSTOMER_ID, FIRST_NAME, LAST_NAME, ADDRESS, CITY, STATE, COUNTRY, CREATED_TS)
VALUES 
    ('C001', 'John',    'Doe',     '123 Main St',     'New York',      'NY', 'United States', CURRENT_TIMESTAMP),
    ('C002', 'Jane',    'Smith',   '456 Oak Ave',     'Los Angeles',   'CA', 'United States', CURRENT_TIMESTAMP),
    ('C003', 'Raj',     'Patel',   '789 MG Road',     'Mumbai',        'MH', 'India',         CURRENT_TIMESTAMP),
    ('C004', 'Maria',   'Garcia',  '321 Gran Via',    'Madrid',        'MD', 'Spain',         CURRENT_TIMESTAMP),
    ('C005', 'Wei',     'Zhang',   '555 Nanjing Rd',  'Shanghai',      'SH', 'China',         CURRENT_TIMESTAMP);

-- ============================================
-- 3. QUERY — Virtual columns are auto-populated
-- ============================================

SELECT 
    CUSTOMER_ID, 
    FULL_NAME, 
    LOCATION_SUMMARY, 
    ATTR_HASH 
FROM CUSTOMER_VIRTUAL;

-- ============================================
-- 4. COMPARE: Virtual vs Stored Column
-- ============================================

CREATE OR REPLACE TABLE CUSTOMER_STORED (
    CUSTOMER_ID STRING,
    FIRST_NAME STRING,
    LAST_NAME STRING,
    ADDRESS STRING,
    CITY STRING,
    STATE STRING,
    COUNTRY STRING,
    CREATED_TS TIMESTAMP,
    FULL_NAME STRING,
    ATTR_HASH STRING,
    LOCATION_SUMMARY STRING
);

INSERT INTO CUSTOMER_STORED
SELECT 
    CUSTOMER_ID, FIRST_NAME, LAST_NAME, ADDRESS, CITY, STATE, COUNTRY, CREATED_TS,
    FIRST_NAME || ' ' || LAST_NAME,
    MD5(CONCAT_WS('|', FIRST_NAME, LAST_NAME, ADDRESS, CITY, STATE, COUNTRY)),
    CITY || ', ' || STATE || ' - ' || COUNTRY
FROM CUSTOMER_VIRTUAL;

SELECT 'VIRTUAL' AS TYPE, * FROM CUSTOMER_VIRTUAL WHERE CUSTOMER_ID = 'C001'
UNION ALL
SELECT 'STORED'  AS TYPE, * FROM CUSTOMER_STORED  WHERE CUSTOMER_ID = 'C001';

-- ============================================
-- 5. INSTANT BUSINESS RULE CHANGE
--    Change LOCATION_SUMMARY format — no backfill needed!
-- ============================================

ALTER TABLE CUSTOMER_VIRTUAL MODIFY COLUMN LOCATION_SUMMARY 
    SET DATA TYPE STRING AS (COUNTRY || ' > ' || STATE || ' > ' || CITY);

SELECT CUSTOMER_ID, LOCATION_SUMMARY FROM CUSTOMER_VIRTUAL;

-- ============================================
-- 6. LIMITATIONS DEMO
-- ============================================

-- 6a. Cannot cluster on virtual column (will error)
-- ALTER TABLE CUSTOMER_VIRTUAL CLUSTER BY (ATTR_HASH);  -- UNCOMMENT TO SEE ERROR

-- 6b. DESCRIBE shows virtual columns with "VIRTUAL" kind
DESCRIBE TABLE CUSTOMER_VIRTUAL;

-- 6c. Virtual columns are skipped during COPY INTO
-- COPY INTO CUSTOMER_VIRTUAL FROM @my_stage;  -- ATTR_HASH, FULL_NAME, LOCATION_SUMMARY are skipped

-- ============================================
-- CLEANUP (optional)
-- ============================================

-- DROP DATABASE VIRTUAL_COL_DEMO;

/*
=============================================================================
  KEY TAKEAWAYS:
  
  1. Virtual columns = formula stored, value computed on read
  2. Zero storage cost, but adds compute on every query
  3. Perfect for: audit fields, display labels, infrequently queried derivations
  4. Avoid for: SCD2 MERGE hash comparisons, JOIN keys, WHERE filters on large tables
  5. Business rule changes are instant — ALTER TABLE, no backfill
=============================================================================
*/
