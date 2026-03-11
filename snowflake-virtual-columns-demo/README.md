# Snowflake Virtual Columns Demo

> **The hidden feature most data engineers overlook** — columns that store a formula, not a value.

---

## What Are Virtual Columns?

Virtual columns (Generated Columns) are computed **on the fly** at query time. They store zero data on disk and always reflect the latest business logic — no backfills, no data drift.

```sql
FULL_NAME STRING AS (FIRST_NAME || ' ' || LAST_NAME)
```

---

## What's Inside

| File | Description |
|------|-------------|
| `virtual_columns_demo.sql` | End-to-end runnable demo — create, insert, query, compare, alter, and explore limitations |
| `Scenario.md` | Real-world e-commerce scenario showing when virtual columns shine (and when they don't) |
| `Quick_Reference.md` | Decision matrix, syntax cheat sheet, performance tips, and common mistakes |
| `LinkedIn_Post.md` | Ready-to-publish LinkedIn post explaining virtual columns with code examples |

---

## Quick Start

1. Open `virtual_columns_demo.sql` in Snowflake (Snowsight or VS Code)
2. Run the script top-to-bottom — it creates its own database and schema
3. Observe how virtual columns auto-populate without being explicitly inserted

---

## Key Takeaways

| Virtual Column | Stored Column |
|:-:|:-:|
| Formula stored, value computed on read | Value stored, computed at write time |
| Zero storage cost | Minimal storage cost |
| Business rule change = instant ALTER TABLE | Rule change = backfill + redeploy |
| Adds compute cost on every query | Pre-computed, faster reads |

### When to Use Virtual Columns

- Audit/display fields queried infrequently
- Business rules that change often
- Small reference/lookup tables
- Concatenated labels, status flags, derived fields

### When NOT to Use

- SCD2 MERGE hash comparisons on large tables
- JOIN / WHERE / GROUP BY keys on high-volume data
- Data loaded via COPY INTO (virtual columns are skipped)
- Performance-critical pipelines

---

## Decision Cheat Sheet

> **Write once, read many** → Stored column wins  
> **Write many, read rarely** → Virtual column wins

---

## Prerequisites

- Snowflake account with `ACCOUNTADMIN` role (or equivalent)
- A warehouse (script uses default `COMPUTE_WH`)

---

## Cleanup

```sql
DROP DATABASE VIRTUAL_COL_DEMO;
```

---

## Part of the Series

This demo is part of the **Snowflake SCD2 Architect Lab** — a hands-on series exploring Snowflake features for data engineers and architects.

---

## Tags

`#Snowflake` `#DataEngineering` `#VirtualColumns` `#SQL` `#SCD2` `#DataModeling` `#ETL`
