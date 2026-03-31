# MySQL Data Cleaning & Analysis

A two-stage SQL project that takes a raw tech-industry layoffs dataset,
cleans it in MySQL, and runs exploratory analysis to surface key trends.

## Files

| File | Description |
|------|-------------|
| `Data Cleaning.sql` | Removes duplicates, standardizes values, handles nulls |
| `Data Analysis.sql` | Exploratory queries — totals by company, industry, country, and rolling monthly trends |

## Workflow

1. Load the raw `layoffs` table into MySQL
2. Run `Data Cleaning.sql` — produces a cleaned `layoffs_staging_2` table
3. Run `Data Analysis.sql` — query the cleaned table for insights

## Key Cleaning Steps

- Duplicate removal using `ROW_NUMBER()` window function
- Whitespace trimming and industry name standardization
- Date conversion from text to `DATE` type via `STR_TO_DATE()`
- Null/blank industry backfill via self-join
- Removal of rows with no layoff data

## Key Analysis Queries

- Top companies and industries by total layoffs
- Layoffs by country, funding stage, and year
- Rolling monthly layoff totals using window functions
- Top 5 companies per year ranked by `DENSE_RANK()`

## Requirements

- MySQL 8.0+ (window functions required)
- A populated `layoffs` table as the raw data source
