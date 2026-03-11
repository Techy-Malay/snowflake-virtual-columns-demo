# Real-World Scenario: Virtual Columns in Action

---

## Scenario: E-Commerce Order Monitoring Dashboard

### Business Context

An e-commerce company processes **5 million orders daily**. The analytics team needs a dashboard that shows order status labels and priority flags. Currently, the ETL pipeline computes these derived fields during transformation — adding complexity and maintenance overhead.

---

### The Problem

Every time business rules change (e.g., "orders above $500 are now HIGH priority instead of $1000"), the team must:
1. Update the ETL transformation logic
2. Backfill historical data
3. Validate consistency across all downstream tables

This leads to **data drift**, **stale values**, and **deployment risk**.

---

### The Solution: Virtual Columns

```sql
CREATE OR REPLACE TABLE ORDERS (
    ORDER_ID STRING,
    CUSTOMER_ID STRING,
    ORDER_DATE TIMESTAMP,
    ORDER_AMOUNT NUMBER(12,2),
    SHIP_DATE TIMESTAMP,
    DELIVERY_DATE TIMESTAMP,

    -- Virtual Columns (auto-computed, never stored)
    PRIORITY_FLAG STRING AS (
        CASE
            WHEN ORDER_AMOUNT >= 500 THEN 'HIGH'
            WHEN ORDER_AMOUNT >= 100 THEN 'MEDIUM'
            ELSE 'LOW'
        END
    ),

    DELIVERY_STATUS STRING AS (
        CASE
            WHEN DELIVERY_DATE IS NOT NULL THEN 'DELIVERED'
            WHEN SHIP_DATE IS NOT NULL THEN 'SHIPPED'
            ELSE 'PROCESSING'
        END
    ),

    DAYS_TO_DELIVER NUMBER AS (
        DATEDIFF('day', ORDER_DATE, COALESCE(DELIVERY_DATE, CURRENT_DATE))
    )
);
```

---

### What Changed?

| Before (Stored) | After (Virtual) |
|------------------|-----------------|
| ETL computes PRIORITY_FLAG during load | Formula lives in table — always current |
| Rule change = backfill + redeploy | Rule change = ALTER TABLE, instant |
| Risk of stale/inconsistent values | Always consistent — computed on read |
| Extra storage for derived columns | Zero storage overhead |

---

### When This Works Best

- Dashboard queries that **filter/display** these fields but don't **JOIN or GROUP BY** them on massive datasets
- Tables where **business rules change frequently** — virtual columns update instantly via ALTER TABLE
- **Audit columns** like `IS_LATE` or `RISK_SCORE` that are informational, not used in heavy aggregations

---

### When This Does NOT Work

- If you run a nightly **MERGE/SCD2** comparing `PRIORITY_FLAG` across 100M rows — stored is better
- If `DAYS_TO_DELIVER` is used in a **WHERE clause** filtering large tables — no clustering benefit
- If data is loaded via **COPY INTO** from staged files — virtual columns are skipped

---

### Key Takeaway

Virtual columns shift computation from **write time to read time**. Use them when your read patterns are light and business rules change often. Avoid them in performance-critical pipelines where pre-computed values save credits.

---

**Author:** [Malaya Kumar Padhi](https://www.linkedin.com/in/mkpadhi/) | Senior Solution Architect — Data & AI Platforms  
*Part of the [Snowflake SCD2 Architect Lab](https://github.com/mkpadhi/snowflake-virtual-columns-demo) series.*
