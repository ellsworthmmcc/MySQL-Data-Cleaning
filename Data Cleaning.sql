-- Data Cleaning

SELECT *
FROM layoffs;

-- 1. Remove duplicates
-- 2. Standardize the data
-- 3. Null values or blank values
-- 4. Remove any columns

-- Create table to alter data
CREATE TABLE layoffs_staging
LIKE layoffs;

INSERT layoffs_staging
SELECT *
FROM layoffs;

-- Removing duplicates
WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, 
total_laid_off, percentage_laid_off, `date`, 
stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

CREATE TABLE `layoffs_staging_duplicates` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO layoffs_staging_duplicates
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, 
total_laid_off, percentage_laid_off, `date`, 
stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

SELECT *
FROM layoffs_staging_duplicates;

DELETE
FROM layoffs_staging_duplicates
WHERE row_num > 1;

-- Standardizing data

SELECT company, TRIM(COMPANY)
FROM layoffs_staging_duplicates;

UPDATE layoffs_staging_duplicates
SET company = TRIM(company);

SELECT DISTINCT industry
FROM layoffs_staging_duplicates
ORDER BY industry;

UPDATE layoffs_staging_duplicates
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT DISTINCT location
FROM layoffs_staging_duplicates
ORDER BY location;

SELECT DISTINCT country
FROM layoffs_staging_duplicates
ORDER BY country;

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging_duplicates
ORDER BY country;

UPDATE layoffs_staging_duplicates
SET country = TRIM(TRAILING '.' FROM country)
WHERE country like 'United States%';

SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoffs_staging_duplicates;

UPDATE layoffs_staging_duplicates
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_staging_duplicates
MODIFY COLUMN `date` DATE;

SELECT *
FROM layoffs_staging_duplicates
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

UPDATE layoffs_staging_duplicates
SET industry = NULL
WHERE industry = '';

SELECT *
FROM layoffs_staging_duplicates
WHERE industry IS NULL
OR industry = '';

SELECT *
FROM layoffs_staging_duplicates t1
JOIN layoffs_staging_duplicates t2
	ON t1.company = t2.company
    AND t1.location = t2.location
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

UPDATE layoffs_staging_duplicates t1
JOIN layoffs_staging_duplicates t2
	ON t1.company = t2.company
    AND t1.location = t2.location
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

DELETE
FROM layoffs_staging_duplicates
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

ALTER TABLE layoffs_staging_duplicates
DROP COLUMN row_num;


