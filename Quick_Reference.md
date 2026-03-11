# Snowflake Virtual Columns — Quick Reference Card

---

## One-Liner Definition
> A virtual column stores the **formula**, not the **value**. Snowflake computes it on every read.

---

## Syntax

```sql
-- Create
column_name DATA_TYPE AS (expression)

-- Alter formula
ALTER TABLE t MODIFY COLUMN col SET DATA TYPE TYPE AS (new_expression);

-- Drop virtual column
ALTER TABLE t DROP COLUMN col;
```

---

## Decision Matrix

| Question | If YES → | If NO → |
|----------|----------|---------|
| Is this column queried in every dashboard refresh? | Stored | Virtual |
| Is this column used in JOIN/WHERE/GROUP BY on large tables? | Stored | Virtual |
| Does the business rule change frequently? | Virtual | Either |
| Is this for SCD2 hash comparison? | **Stored** | Virtual |
| Is this an audit/display field? | Virtual | Either |
| Is storage cost a major concern? | Virtual | Stored |
| Is data loaded via COPY INTO? | Stored | Either |

---

## Performance Tips

1. **Profile before deciding** — Run `EXPLAIN` on your query to see compute impact
2. **Monitor credits** — Check `QUERY_HISTORY` for warehouse credit usage with virtual vs stored
3. **Hybrid approach** — Use virtual columns in staging, stored columns in dimension tables
4. **Test at scale** — Virtual columns on 1K rows feel fast; on 100M rows, the difference is real

---

## Common Mistakes to Avoid

- Using virtual columns as MERGE comparison keys (expensive recomputation)
- Assuming COPY INTO will populate virtual columns (it won't)
- Trying to INSERT values into virtual columns (will error)
- Using complex expressions (nested UDFs) in virtual columns without testing performance

---

## Official Documentation
- [Snowflake Virtual Columns](https://docs.snowflake.com/en/sql-reference/sql/create-table#virtual-column-definition)

---

## Hashtags for LinkedIn
```
#Snowflake #DataEngineering #ETL #VirtualColumns #CloudData
#DataWarehouse #SQL #SnowflakeTips #Analytics #DataPipeline
#SCD2 #DataModeling #BigData #TechTips #DataArchitecture
```

---

**Author:** [Malaya Kumar Padhi](https://www.linkedin.com/in/mkpadhi/) | Senior Solution Architect — Data & AI Platforms  
*Part of the [Snowflake SCD2 Architect Lab](https://github.com/Techy-Malay/snowflake-virtual-columns-demo) series.*
