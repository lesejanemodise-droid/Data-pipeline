# BrightLearn Data Warehouse Build

## Project Overview

This project delivers a complete end-to-end Data Engineering solution for BrightLearn, a South African retail company operating five stores nationwide.

The objective was to transform a single denormalized Point-of-Sale (POS) export into a structured, queryable Data Warehouse capable of supporting business intelligence and analytical reporting requirements.

The solution includes:

* Data ingestion from CSV
* Data quality assessment and cleansing
* Database normalization
* ETL development using SSIS
* Data warehouse implementation using a Star Schema
* Analytical SQL queries answering all business questions
* Documentation and data quality reporting

---

# Business Problem

BrightLearn's transactional data was exported from multiple POS systems into a single flat file containing:

* Customer data
* Product data
* Store data
* Transaction data
* Inventory data

All entities existed in one table with:

* Duplicate records
* Inconsistent formatting
* Mixed date formats
* Missing values
* Data quality issues

This prevented the Business Intelligence team from producing meaningful reports.

---

# Solution Architecture

## Medallion Architecture

The solution follows a Medallion Architecture approach.

```text
CSV Source File
       │
       ▼
BRONZE LAYER
(stg_sales_raw)
       │
       ▼
SILVER LAYER
(stg_sales_clean)
       │
       ▼
GOLD LAYER
Data Warehouse Star Schema
```

---

# Bronze Layer

## Purpose

The Bronze Layer stores the raw source data exactly as received from the POS export.

### Table

```sql
stg_sales_raw
```

### Activities

* CSV ingestion
* No transformations
* Historical source preservation
* Audit and traceability

---

# Silver Layer

## Purpose

The Silver Layer contains cleansed and standardized data ready for modelling.

### Table

```sql
stg_sales_clean
```

### Data Cleansing Activities

#### Duplicate Removal

Removed duplicate transaction rows using:

```sql
ROW_NUMBER()
```

#### Date Standardization

Converted mixed formats:

```text
yyyy/mm/dd
dd/mm/yyyy
```

into:

```text
yyyy-mm-dd
```

using:

```sql
TRY_CONVERT()
```

#### Text Standardization

Applied:

```sql
LTRIM()
RTRIM()
UPPER()
LOWER()
```

to:

* Payment Methods
* Customer Names
* Product Codes
* Email Addresses

#### Null Handling

Validated:

* Transaction Date
* Customer Email
* Product SKU

Records failing validation were excluded.

#### Revenue Validation

Negative values corrected using:

```sql
ABS()
```

for:

* Transaction Amount
* Line Amount

#### Data Type Casting

Converted:

* Dates
* Currency values
* Quantities
* Inventory metrics

into appropriate SQL Server data types.

---

# Database Normalization

The source file was fully denormalized.

Normalization was applied to eliminate:

* Redundancy
* Repeated customer information
* Repeated product information
* Repeated store information

## Third Normal Form (3NF)

The database was normalized into:

### Customer

```sql
Customer
```

### Product

```sql
Product
```

### Store

```sql
Store
```

### Payment

```sql
Payment
```

### Cashier

```sql
Cashier
```

### Transaction

```sql
Transaction
```

Benefits:

* Reduced data duplication
* Improved data integrity
* Improved maintainability
* Consistent master data management

---

# Data Warehouse Design

A dimensional model was created to support reporting and analytics.

## Star Schema

### Fact Table

```sql
fact_sales
```

### Dimension Tables

```sql
dim_date
dim_customer
dim_product
dim_store
dim_payment
dim_cashier
```

---

## Star Schema Model

```text
              dim_date
                   │
                   │
dim_customer ─ fact_sales ─ dim_product
                   │
                   │
             dim_store
                   │
                   │
          dim_payment
                   │
                   │
          dim_cashier
```

---

# ETL Process

## Tool

SQL Server Integration Services (SSIS)

## ETL Flow

### Step 1

Load CSV into:

```sql
stg_sales_raw
```

### Step 2

Execute cleansing procedures:

```sql
usp_Load_Stg_Sales_Clean
```

### Step 3

Populate dimensions:

```sql
dim_customer
dim_product
dim_store
dim_payment
dim_cashier
dim_date
```

### Step 4

Populate:

```sql
fact_sales
```

### Step 5

Execute validation checks

### Step 6

Generate analytical reporting outputs

---

# Data Quality Findings

The following issues were identified:

| Issue                       | Resolution                             |
| --------------------------- | -------------------------------------- |
| Duplicate records           | Removed using ROW_NUMBER()             |
| Mixed date formats          | Standardized using TRY_CONVERT()       |
| Leading/trailing spaces     | Removed using TRIM functions           |
| Negative transaction values | Converted using ABS()                  |
| Inconsistent casing         | Standardized using UPPER() and LOWER() |
| Missing critical fields     | Excluded from warehouse load           |
| Invalid email formatting    | Standardized and validated             |

---

# Business Questions Supported

The warehouse supports the following analytical requirements:

### BQ-01

Top 5 best-selling products by revenue

### BQ-02

Revenue per store by month

### BQ-03

Month-over-month revenue growth

### BQ-04

Top 10 loyalty customers by spend

### BQ-05

Inactive loyalty customers for win-back campaigns

### BQ-06

Average transaction value by loyalty tier

### BQ-07

Quantity sold by category and store

### BQ-08

Products below reorder threshold

---

# Technology Stack

| Component      | Technology             |
| -------------- | ---------------------- |
| Database       | SQL Server 2019        |
| Development    | SSMS                   |
| ETL            | SSIS                   |
| Source Control | GitHub                 |
| Language       | T-SQL                  |
| Data Model     | Star Schema            |
| Architecture   | Medallion Architecture |

---

# Repository Structure

```text
BrightLearn-DE-Exam/

│
├── data/
│   └── BrightLearn_Raw_Data.csv
│
├── sql/
│   ├── create_tables.sql
│   ├── stored_procedures.sql
│   ├── load_dimensions.sql
│   ├── load_fact_sales.sql
│
├── queries/
│   ├── BQ01.sql
│   ├── BQ02.sql
│   ├── BQ03.sql
│   ├── BQ04.sql
│   ├── BQ05.sql
│   ├── BQ06.sql
│   ├── BQ07.sql
│   └── BQ08.sql
│
├── ssis/
│   └── BrightLearn_ETL.dtsx
│
├── documentation/
│   ├── Data_Quality_Report.md
│   ├── Data_Model.png
│   └── ETL_Architecture.png
│
└── README.md
```

---

# Execution Order

1. Create database
2. Run schema creation scripts
3. Execute staging table scripts
4. Run SSIS package
5. Populate dimensions
6. Populate fact table
7. Execute validation queries
8. Run business queries (BQ01–BQ08)

---

# Author

Data Engineering Candidate

BrightLearn Data Warehouse Build Assessment

2026
