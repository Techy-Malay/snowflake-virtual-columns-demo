# Snowflake Virtual Columns Demo

[![Snowflake](https://img.shields.io/badge/Snowflake-29B5E8?style=for-the-badge&logo=snowflake&logoColor=white)](https://www.snowflake.com/)
[![SQL](https://img.shields.io/badge/SQL-336791?style=for-the-badge&logo=postgresql&logoColor=white)](#)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)

> **The hidden feature most data engineers overlook** — columns that store a formula, not a value.

---

## About This Project

Virtual columns (Generated Columns) are computed **on the fly** at query time. They store zero data on disk and always reflect the latest business logic — no backfills, no data drift.

```sql
FULL_NAME STRING AS (FIRST_NAME || ' ' || LAST_NAME)
```

This repo provides a complete, runnable demo with real-world scenarios and an architectural decision guide to help you evaluate when to use virtual columns vs stored columns in Snowflake.

---

## Repository Structure

```
snowflake-virtual-columns-demo/
├── README.md                    ← You are here
├── virtual_columns_demo.sql     ← End-to-end runnable SQL demo
├── Scenario.md                  ← Real-world e-commerce use case
├── Quick_Reference.md           ← Decision matrix & cheat sheet
├── LinkedIn_Post.md             ← Technical article on virtual columns

```

---

## Quick Start

1. Open `virtual_columns_demo.sql` in **Snowsight** or any Snowflake-connected IDE
2. Run the script top-to-bottom — it creates its own database and schema
3. Observe how virtual columns auto-populate without being explicitly inserted

---

## What You'll Learn

| Section | What It Covers |
|---------|---------------|
| **Create** | Define virtual columns using `AS (expression)` syntax |
| **Insert** | Load data without computing derived fields |
| **Query** | See auto-populated values at read time |
| **Compare** | Virtual vs stored column side-by-side |
| **Alter** | Change business rules instantly — no backfill |
| **Limitations** | COPY INTO, clustering, and MERGE constraints |

---

## Virtual vs Stored — At a Glance

| | Virtual Column | Stored Column |
|---|:-:|:-:|
| **Storage** | Zero | Minimal |
| **Compute** | On every read | Once at write |
| **Rule Change** | Instant (ALTER TABLE) | Backfill + redeploy |
| **Best For** | Audit fields, display labels | JOIN keys, MERGE hashes |

### Decision Rule

> **Write once, read many** → Stored column wins  
> **Write many, read rarely** → Virtual column wins

---

## Real-World Scenario

An e-commerce platform with **5M daily orders** uses virtual columns for `PRIORITY_FLAG` and `DELIVERY_STATUS`. When the business changes priority thresholds from $1,000 to $500, a single `ALTER TABLE` updates every row — no ETL changes, no backfill, no risk.

Full scenario with code: [`Scenario.md`](Scenario.md)

---

## Prerequisites

- Snowflake account with `ACCOUNTADMIN` role (or equivalent privileges)
- A running warehouse (script defaults to `COMPUTE_WH`)

---

## Cleanup

```sql
DROP DATABASE VIRTUAL_COL_DEMO;
```

---

## Part of the Series

This project is part of the **Snowflake SCD2 Architect Lab** — a hands-on series exploring Snowflake features for data engineers and architects building production-grade data platforms.

| Topic | Status |
|-------|:------:|
| Virtual Columns | This repo |
| SCD Type 2 Implementation | Coming soon |
| MERGE Deep Dive | Coming soon |
| Streams + Tasks Automation | Coming soon |

---

## Author

**Malaya Kumar Padhi**  
Senior Solution Architect | Data & AI Platforms

[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/mkpadhi/)

---

## License

This project is open source and available under the [MIT License](https://opensource.org/licenses/MIT).

---

## Tags

`#Snowflake` `#DataEngineering` `#VirtualColumns` `#SQL` `#SCD2` `#DataModeling` `#ETL` `#DataArchitecture`
