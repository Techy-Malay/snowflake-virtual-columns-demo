# Snowflake Virtual Columns — The Hidden Feature Most Engineers Overlook

**Author:** [Malaya Kumar Padhi](https://www.linkedin.com/in/mkpadhi/) | Senior Solution Architect — Data & AI Platforms

---

## LinkedIn Post

Did you know Snowflake lets you define columns that **never store data**?

They're called **Virtual Columns** (Generated Columns) — and they can simplify your ETL pipelines, eliminate data drift, and reduce storage costs.

Here's what most engineers miss:

### What Are Virtual Columns?

A virtual column is a **formula** attached to your table definition. It doesn't store any value on disk — instead, Snowflake computes it **on the fly** every time you query it.

```sql
CREATE TABLE STG_CUSTOMER (
    CUSTOMER_ID STRING,
    CUSTOMER_NAME STRING,
    CUSTOMER_ADDRESS STRING,
    CUSTOMER_CITY STRING,
    CUSTOMER_STATE STRING,
    CUSTOMER_COUNTRY STRING,
    UPDATED_TS TIMESTAMP,
    ATTR_HASH STRING AS (
        MD5(CONCAT_WS('|',
            CUSTOMER_NAME,
            CUSTOMER_ADDRESS,
            CUSTOMER_CITY,
            CUSTOMER_STATE,
            CUSTOMER_COUNTRY
        ))
    )
);
```

Insert your data normally — **no need to compute the hash**:

```sql
INSERT INTO STG_CUSTOMER (CUSTOMER_ID, CUSTOMER_NAME, CUSTOMER_ADDRESS, CUSTOMER_CITY, CUSTOMER_STATE, CUSTOMER_COUNTRY, UPDATED_TS)
VALUES ('C001', 'John Doe', '123 Main St', 'New York', 'NY', 'United States', CURRENT_TIMESTAMP);
```

Query it — and `ATTR_HASH` is **automatically there**:

```sql
SELECT * FROM STG_CUSTOMER;
-- ATTR_HASH is computed on the fly — no manual calculation needed!
```

---

### When Should You Use Virtual Columns?

| Use Case | Virtual Column? |
|----------|:-:|
| Audit fields rarely queried | Yes |
| Small lookup/reference tables | Yes |
| Derived flags (e.g., IS_ACTIVE based on dates) | Yes |
| Concatenated display columns | Yes |
| Hash columns in SCD2 MERGE workloads | No |
| Columns used in JOINs / WHERE / GROUP BY on large tables | No |
| Performance-critical pipelines | No |

---

### The Cost Tradeoff Engineers Must Know

| Approach | Insert Cost | Read/Query Cost | Storage |
|----------|:-:|:-:|:-:|
| Virtual Column | Low | High (recomputed every read) | Zero |
| Stored Column | Slightly Higher (computed once) | Low (pre-computed) | Minimal |

**Rule of thumb:**
- **Write once, read many** → Stored column wins
- **Write many, read rarely** → Virtual column wins

---

### 5 Things That Will Surprise You

1. Virtual columns **cannot be clustered** — no micro-partition pruning benefit
2. **COPY INTO** skips virtual columns — they won't load from staged files
3. You **cannot manually override** the value — it's always derived from the formula
4. They work with **any scalar expression** — not just MD5
5. **Zero storage footprint** — great for large tables with derived audit fields

---

### My Take

Virtual columns are **underused** in the Snowflake ecosystem. They're perfect for simplifying ETL logic on smaller tables and ensuring derived values are always consistent.

But for **SCD Type 2** workloads where you're running MERGE statements comparing hash values across millions of rows? **Stored columns are the way to go.** Compute once at insert, compare for free during MERGE.

Know your access pattern. Choose accordingly.

---

What's your experience with virtual columns in Snowflake? Have you found a creative use case? Drop it in the comments!

#Snowflake #DataEngineering #ETL #SCD2 #VirtualColumns #DataWarehouse #CloudData #SnowflakeFeatures #DataPipeline #Analytics

---

**Author:** [Malaya Kumar Padhi](https://www.linkedin.com/in/mkpadhi/)  
*Follow me on [LinkedIn](https://www.linkedin.com/in/mkpadhi/) for more Snowflake architecture tips and data engineering insights.*  
*GitHub: [snowflake-virtual-columns-demo](https://github.com/mkpadhi/snowflake-virtual-columns-demo)*
