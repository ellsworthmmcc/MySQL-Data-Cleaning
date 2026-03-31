-- Exploratory Data Analysis

SELECT *
FROM layoffs_staging_2;

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging_2;

SELECT *
FROM layoffs_staging_2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;

SELECT *
FROM layoffs_staging_2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

SELECT company, SUM(total_laid_off) AS laid_off_sum
FROM layoffs_staging_2
GROUP BY company
ORDER by laid_off_sum DESC;

SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging_2;

SELECT industry, SUM(total_laid_off) AS laid_off_sum
FROM layoffs_staging_2
GROUP BY industry
ORDER BY laid_off_sum DESC;

SELECT country, SUM(total_laid_off) AS laid_off_sum
FROM layoffs_staging_2
GROUP BY country
ORDER BY laid_off_sum DESC;

SELECT YEAR(`date`) AS year_date, SUM(total_laid_off) AS laid_off_sum
FROM layoffs_staging_2
GROUP BY year_date
ORDER BY year_date DESC;

SELECT stage, SUM(total_laid_off) AS laid_off_sum
FROM layoffs_staging_2
GROUP BY stage
ORDER BY stage DESC;

SELECT stage, SUM(total_laid_off) AS laid_off_sum
FROM layoffs_staging_2
GROUP BY stage
ORDER BY laid_off_sum DESC;

SELECT company, AVG(percentage_laid_off) AS average
FROM layoffs_staging_2
GROUP BY company
ORDER BY average DESC;

SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off)
FROM layoffs_staging_2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY `MONTH` ASC
;

WITH Rolling_Total AS
(
SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off) AS total_off
FROM layoffs_staging_2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
)
SELECT `MONTH`, total_off,
SUM(total_off) OVER(ORDER BY `MONTH`) AS rolling_total
FROM Rolling_Total;

SELECT company, YEAR(`date`) as year_date, SUM(total_laid_off) as laid_off_sum
FROM layoffs_staging_2
GROUP BY company, year_date
ORDER BY laid_off_sum ASC;

WITH Company_Year (company, years, total_laid_off) AS
(
SELECT company, YEAR(`date`) as year_date, SUM(total_laid_off) as laid_off_sum
FROM layoffs_staging_2
GROUP BY company, year_date
), Company_Year_Rank AS
(SELECT *,
 DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_Year
WHERE years is not NULL
)
SELECT *
FROM Company_Year_Rank
WHERE Ranking <= 5
;
