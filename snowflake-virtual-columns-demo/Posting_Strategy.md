# LinkedIn Posting Strategy — Virtual Columns Post

---

## LinkedIn Formatting Rules (What Works & What Doesn't)

| Feature | Works? | Alternative |
|---------|:------:|-------------|
| Bold (**text**) | No | Use CAPS or → arrows for emphasis |
| Italic | No | Use quotes or dashes |
| Headers (#, ##) | No | Use CAPS + line breaks |
| Code blocks (```) | No | Use monospace workaround: wrap in special chars or post code as IMAGE |
| Tables | No | Use aligned text with emojis or → bullets |
| Bullet points | Yes | Use • or - or numbered lists |
| Line breaks | Yes | Essential — use single line per thought |
| Emojis | Yes | Use sparingly for visual anchors |
| Links | Yes | Place in comments, not in post body (algorithm penalizes external links) |
| Images | Yes | Best engagement — post code as screenshots |
| Carousels (PDF) | Yes | Highest reach — convert key points to slides |

---

## Recommended Post Strategy

### FORMAT: Carousel Post (PDF) + Text Hook

This gives you the BEST of both worlds:
- **Text hook** → grabs attention in the feed
- **Carousel PDF** → preserves tables, code, formatting perfectly

---

### STEP 1: The Text Post (Copy-Paste Ready for LinkedIn)

```
Did you know Snowflake has columns that NEVER store data?

They are called Virtual Columns — and most engineers have never used them.

Here is what they do:
→ You define a formula in the table definition
→ Snowflake computes the value ON EVERY READ
→ Zero storage cost
→ No need to compute during INSERT

Sounds amazing right? But there is a catch.

For SCD Type 2 workloads where you MERGE and compare hash values across millions of rows — virtual columns RECOMPUTE the hash every single time.

That means MORE compute credits. SLOWER merges.

So when should you use them?

USE virtual columns when:
• The column is rarely queried
• Business rules change frequently (just ALTER TABLE — instant update)
• You need audit/display fields with zero storage overhead
• Small to medium tables

AVOID virtual columns when:
• The column is used in JOIN / WHERE / GROUP BY on large tables
• You run SCD2 MERGE comparing hash values
• Data is loaded via COPY INTO (virtual columns are skipped)
• Performance-critical pipelines

The rule of thumb:
→ Write once, read many = STORED column
→ Write many, read rarely = VIRTUAL column

I have shared the full demo SQL and a real-world scenario in the comments below.

Swipe through the carousel for the complete breakdown with code examples.

---

What is your experience with virtual columns? Drop your use case in the comments.

#Snowflake #DataEngineering #ETL #VirtualColumns #SQL #DataWarehouse #CloudData #SCD2 #DataModeling #Analytics
```

---

### STEP 2: Carousel PDF (Slides Breakdown)

Create a PDF with these slides (use Canva, Google Slides, or PowerPoint):

**Slide 1 — Cover**
- Title: "Snowflake Virtual Columns — The Feature Most Engineers Miss"
- Subtitle: "Zero storage. Auto-computed. But when should you actually use them?"
- Your name + profile photo

**Slide 2 — What Is a Virtual Column?**
- One-liner: "A formula stored in the table definition. Value computed on every read."
- Simple diagram: TABLE → [stored cols] + [virtual col = formula]

**Slide 3 — The Syntax**
- Screenshot of CREATE TABLE with virtual column (from demo SQL)
- Highlight the AS (...) part

**Slide 4 — INSERT Without Computing**
- Show INSERT statement — no hash column needed
- Arrow pointing: "ATTR_HASH auto-computes on SELECT"

**Slide 5 — The Cost Tradeoff**
- Two-column comparison:
  - LEFT: Virtual → Low insert cost, High read cost, Zero storage
  - RIGHT: Stored → Slightly higher insert, Low read cost, Minimal storage

**Slide 6 — When to Use**
- Green checkmarks: Audit fields, display labels, small tables, changing business rules

**Slide 7 — When NOT to Use**
- Red X marks: SCD2 MERGE, JOIN keys, COPY INTO, large table filters

**Slide 8 — Real-World Scenario**
- E-commerce example: PRIORITY_FLAG and DELIVERY_STATUS as virtual columns
- "Business rule change? Just ALTER TABLE. No backfill."

**Slide 9 — Instant Rule Changes**
- Show ALTER TABLE MODIFY COLUMN with new formula
- "Old way: Update ETL + backfill + validate. New way: One ALTER statement."

**Slide 10 — Key Takeaway**
- "Know your access pattern. Choose accordingly."
- "Virtual = read-time compute. Stored = write-time compute."
- CTA: "Follow me for more Snowflake tips"

---

### STEP 3: First Comment (Post Immediately After Publishing)

```
Full demo SQL and real-world scenario available on GitHub:
[YOUR GITHUB LINK]

Covers:
→ Creating virtual columns
→ Inserting data (virtual cols auto-compute)
→ Comparing virtual vs stored performance
→ Altering formulas instantly
→ Limitations (COPY INTO, clustering, MERGE)

Let me know if you want me to cover SCD Type 2 implementation next.
```

---

## Posting Schedule & Tips

### Best Time to Post
- Tuesday to Thursday, 8:00–10:00 AM (your audience's timezone)
- Avoid weekends and Mondays

### Engagement Hacks
1. Reply to EVERY comment within the first 2 hours (algorithm boost)
2. Ask a question at the end of the post (drives comments)
3. Tag 2-3 people who might find it useful (extends reach)
4. Do NOT edit the post within the first hour (resets algorithm)
5. Post the GitHub link in COMMENTS, not in the main post (external links reduce reach by 50%)

### Follow-Up Posts (Content Series)
- Post 1: Virtual Columns (THIS POST)
- Post 2: SCD Type 2 — Full Implementation in Snowflake
- Post 3: MERGE Statement Deep Dive — Hash Comparison Strategy
- Post 4: Streams + Tasks — Automating SCD2 in Snowflake
- Post 5: Performance Tuning — Virtual vs Stored at Scale (Benchmarks)

Tag each post as part of the series to build a following.

---

## File Checklist for GitHub Repository

```
snowflake-scd2-architect-lab/
├── linkedin-virtual-columns/
│   ├── LinkedIn_Post.md          ← Full formatted post (reference)
│   ├── Posting_Strategy.md       ← THIS FILE
│   ├── Scenario.md               ← Real-world e-commerce scenario
│   ├── Quick_Reference.md        ← Decision matrix + cheat sheet
│   └── virtual_columns_demo.sql  ← Runnable SQL demo
```

---

*Strategy prepared for the Snowflake SCD2 Architect Lab series.*
