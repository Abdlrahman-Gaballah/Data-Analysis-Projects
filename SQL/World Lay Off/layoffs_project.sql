-- over view data base 
select *
from layoffs;
 -- See the structure of your table (data types and column names)
SELECT column_name, data_type, character_maximum_length
FROM information_schema.columns
WHERE table_name = 'layoffs';
 -- Peek at the first few rows to understand the content
select *
from layoffs
limit 10;
-- 3. Check for NULL values in critical columns (Data cleaning is 80% of the job!)
select count(*)
from layoffs
where total_laid_off is null ;
-- 4 remove duplicates (1 find duplicates , create stanning tale with new coulm named rn , insert data data from the table to staging tale , find duplicates , remove sql safe , remove dplicates , make sure their is no duplicate)
 -- 4.1-find ulicates y cte 
with duplicate_cte as(
select *,
row_number() over(
PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions
) as rn
from layoffs
)
select *
from duplicate_cte
where rn >1;
-- 4.2-create staning tale with rn coulmn 
CREATE TABLE `layoffs_staging` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
   `rn` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
select * from layoffs_staging;
-- 4.3- inserting
insert into layoffs_staging
select * ,
row_number() over(
PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions
) As rn
from layoffs;
-- 4.4 select the dulicated rows 
select *
 from layoffs_staging;
-- where rn >1;
-- 4.5 remove the security of sql 
set sql_safe_updates=0;
set sql_safe_updates=1;
--  4.6 delete duplicates 
delete
from layoffs_staging 
WHERE rn > 1;
--  4.7 make sure that duplicates removed 
select *
 from layoffs_staging
where rn >1;
--  5 organizing data 
-- 5.1 trim  
update layoffs_staging 
set industry  =trim(industry);
set company =trim(company);
set contry =trim(country);
-- 5.2 descover the industry names 
select distinct industry 
from layoffs_staging
order by 1;
 -- 5.3 changing names to be  one name 
update layoffs_staging 
set industry = 'Crypto' where industry like 'Crypto%';
-- 5.4 descover the countries 
select distinct country  
from layoffs_staging
order by 1 ;
-- 5.5 changing names of the countries 
 update layoffs_staging 
set country  = 'United States' where country like 'United States%';
-- 6- formating date 
-- 6.11 changing  date to date form 
update layoffs_staging 
set `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

-- 6.2 change colmn type 
alter table layoffs_staging
modify column `date` date;
-- 6.3  to make sure every thing is oay 
SELECT `date`
FROM layoffs_staging
WHERE `date` IS NOT NULL
LIMIT 10;
-- 7- dealings with blanks and nulls 
-- 7.1 dealing with blanks so we have to change it to null fist 
update layoffs_staging
set industry = null
where industry = ''; 
-- 7.2 conerting null  of the lanks 
update layoffs_staging t1
join  layoffs_staging t2
on t1.company =t2.company 
set t1.industry = t2.industry 
where t1.industry is null 
and t2.industry is not null ;
-- 7.3 show the effects 
select * 
from layoffs_staging
where industry is null
or industry =''; 
-- 7.4 if i found null after cleaning it depends on the colum 
update  layoffs_staging
set industry ='not provided'
where industry is null;
select * 
from layoffs_staging
where total_laid_off is null
or total_laid_off =''; 
 -- 7.5 deleete nulls in total laid off and recentage laid of 
SELECT * FROM layoffs_staging 
WHERE total_laid_off IS NULL 
AND percentage_laid_off IS NULL;
-- 7.6 delete 
DELETE FROM layoffs_staging
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;
-- 8 starting analysis :-
-- 8.1 desprictive analysis 
-- maxmum 	5 companies numer of layoff at one time 
select company, total_laid_off
from layoffs_staging 
order by total_laid_off desc
limit 5;
-- maxmum presentage 5 companies numer of layoff at one time 
select company, percentage_laid_off
from layoffs_staging 
order by percentage_laid_off desc
limit 5;
-- find  5 companies which totaly layed off 
select *
from layoffs_staging
where percentage_laid_off =1
order by total_laid_off desc
limit 5;
-- mamum  10 companies of layoff
select company, sum(total_laid_off)
from layoffs_staging
group by company 
order by  2 desc
limit 10;
-- industry which is more effected 
select industry, sum(total_laid_off)
from layoffs_staging
group by industry 
order by  2 desc
limit 10;
--  maxmum countries has  layoff 
select country , sum(total_laid_off)
from layoffs_staging
group by country 
order by  2 desc
limit 10;
-- 8.2 diagnostic analysis 
-- relation between stage o company with the total lay off
select stage , sum(total_laid_off) as total , avg(percentage_laid_off)as avarege_presentage 
from layoffs_staging
group by stage
order by total desc;
-- proving the effection of the companies 
select (`date`) as year  , month (`date`) as month ,stage, sum(total_laid_off) as total
from layoffs_staging
where stage ='Post-IPO'
group by year, month ,stage
order by year asc , month asc; 
-- the effec is from stage or from industry
select industry,stage, sum(total_laid_off) as total
from layoffs_staging
where stage ='Post-IPO'
group by industry,stage
order by 3 desc;
-- relation between fund of cumpany and layoff
select company ,funds_raised_millions , sum(total_laid_off) as total  
from layoffs_staging
group by funds_raised_millions,company 
order by funds_raised_millions desc
limit 10 ;
-- location impact on industry  
select location,industry , sum(total_laid_off) as total  
from layoffs_staging
where location = 'sf bay area'
group by location,industry 
order by 3 desc;
-- 8.3 prdictive analysis 
-- rolling total 
with rolling_total_cte as (
select substring(`date`,1,7) as `month` ,sum(total_laid_off) as total
from layoffs_staging
where substring(`date`,1,7) is not null
group by `month`
order by 1 asc
)
select `month`,total,sum(total) over(order by	`month`)as rolling_total 
from rolling_total_cte;
-- find 5 largest compampany  individual ech year 
with company_year_cte as (
select company,year(`date`) as years , sum(total_laid_off)as total_laid_off
from layoffs_staging
group by  company, year(`date`)
),
 company_year_rank_cte as	(
select *, 
dense_rank() over(partition by years order by total_laid_off desc) as rankig 
from company_year_cte
where years is not null
)
select * 
from  company_year_rank_cte
where rankig  <= 5
order by years asc , total_laid_off desc ;
-- 8.4 representative analysis 
-- knowing the low fund companies 
select company, industry,total_laid_off,percentage_laid_off, funds_raised_millions
from layoffs_staging
where percentage_laid_off >0.7
and funds_raised_millions<100
order by funds_raised_millions asc;
-- safe haven through layoffs
 
SELECT industry, SUM(total_laid_off) as total, AVG(percentage_laid_off) as avg_pct
FROM layoffs_staging
GROUP BY industry
HAVING avg_pct < 0.05 
ORDER BY total ASC;

-- efficancy of layoff
with company_round as (
select company ,count(*) as layoff_round ,SUM(total_laid_off) as total
from layoffs_staging
group by company
)
select * from company_round
where layoff_round > 3
order by layoff_round desc ;

-- 9- Funding Efficiency
select	company , industry , funds_raised_millions,total_laid_off,(funds_raised_millions / total_laid_off) as fund_burn_index 
from layoffs_staging
where funds_raised_millions is not null and total_laid_off >0
order by fund_burn_index  asc 
limit 10;
-- 10 geographic concentration 
select	 location, count(distinct company) as num_companies  , sum(total_laid_off) as total_off
from layoffs_staging
group by location 
having total_off >0 
order by total_off desc 
limit 10;
-- 11 Surviving Companies
select company, industry, stage, funds_raised_millions
from  layoffs_staging
where total_laid_off is not null OR total_laid_off >0
order by  funds_raised_millions desc ;
