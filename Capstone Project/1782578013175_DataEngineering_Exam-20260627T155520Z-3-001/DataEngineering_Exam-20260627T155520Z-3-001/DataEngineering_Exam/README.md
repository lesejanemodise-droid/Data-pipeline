# BrightLearn — Data Engineering Assessment

**Organisation:** BrightLearn  
**Division:** Technology & Data Division  
**Issued by:** Ketro Sithole, Head of Data Engineering  
**Approved by:** Rofhiwa, CEO | Lerato, Business Analyst  
**Document Ref:** BL-DE-EXAM-2026-07  
**Date:** 23 June 2026  
**Classification:** CONFIDENTIAL — INTERNAL USE ONLY

---

## Overview

This folder contains the complete assessment package for the BrightLearn Data Engineering Exam. Candidates are required to build a full data engineering solution using **SSIS**, **SSMS (SQL Server)**, and **GitHub** — working independently from a single raw data file.

---

## Folder Structure

```
DataEngineering_Exam/
│
├── README.md                          ← This file
├── BrightMart_Scope_Document.html     ← Full project scope (open in browser or Word)
│
└── data/
    └── BrightLearn_Raw_Data.csv       ← The ONLY data source — one flat, raw CSV
```

---

## What Candidates Must Do

Read the full scope document (`BrightMart_Scope_Document.html`) before starting.  
A summary of required deliverables is below:

| # | Deliverable | Tool |
|---|---|---|
| 1 | Public GitHub repository with full commit history | GitHub |
| 2 | Normalised SQL Server database (tables, keys, data types) | SSMS / T-SQL |
| 3 | SSIS ETL package loading and transforming the raw CSV | SSIS / SSDT |
| 4 | Data Quality Findings Report (all issues identified + decisions) | Written document |
| 5 | T-SQL queries answering all 8 business questions (BQ-01 to BQ-08) | SSMS / T-SQL |
| 6 | README.md in their repository explaining structure & run order | GitHub |

---

## Source Data

**File:** `data/BrightLearn_Raw_Data.csv`  
**Format:** Single flat, denormalised CSV — one row per line item in a transaction  
**Period:** January 2026 – June 2026  
**Columns:** 32 fields covering transaction, customer, store, and product data

> ⚠️ The source file contains data quality issues. Candidates must identify and resolve all anomalies independently. No issues are disclosed in advance.

---

## Assessment Weighting

| Area | Weight |
|---|---|
| Database Design (Schema & Normalisation) | 20% |
| SSIS ETL Package | 30% |
| Data Quality Findings Report | 15% |
| Analytical Queries (BQ-01 to BQ-08) | 25% |
| GitHub & Version Control | 5% |
| Live Code Walkthrough | 5% |
| **TOTAL** | **100%** |

---

## Submission

- GitHub repository must be **public** and accessible before the deadline
- Final commit message: `submission: final — BrightLearn DE Exam complete`
- Send repository URL to your facilitator via the designated submission channel
- Late penalty: **-15 marks per day**

---

## Academic Integrity

> By submitting, candidates confirm that all work is their own.  
> **AI tools (ChatGPT, Copilot, Gemini, etc.) are strictly prohibited.**  
> Live code walkthroughs will be conducted. Violations = 0%.

---

## Sign-Off

| Name | Role | Date |
|---|---|---|
| Lerato | Business Analyst | 23 June 2026 |
| Ketro Sithole | Head of Data Engineering | 23 June 2026 |
| Rofhiwa | Chief Executive Officer | 23 June 2026 |

---

*BrightLearn — Technology & Data Division | Document Ref: BL-DE-EXAM-2026-07 | CONFIDENTIAL*
