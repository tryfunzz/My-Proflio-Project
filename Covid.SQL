----------------------------------------------------------------Covid Cases Analysis(Global)-----------------------------------------------------------------------
--catch a glimpse of location
select distinct 
  location
from 
  `invertible-now-355003.covid_19.covid`
--244 locations including 'High income'etc description classify

--Checking Start-End Date 
SELECT
  MIN(date) AS start_date,
  MAX(date) AS end_date
FROM
  `invertible-now-355003.covid_19.covid`
--start_date	end_date	
--2020-01-01  2022-10-07

--calculate total cases and total deaths
--Six continents
SELECT
  continent,MAX(cast(total_Cases as int )) AS TotalCasesCount, 
  MAX(cast(total_deaths as int ))AS TotalDeathsCount,
  (MAX(cast(total_deaths as int ))/MAX(cast(total_Cases as int )))*100 as DeathPercentage
FROM
  `invertible-now-355003.covid_19.covid`
WHERE continent is not NULL
GROUP BY continent
ORDER BY DeathPercentage DESC

--Latest Total Cases, Deaths and Death Rate
SELECT
  continent,MAX(cast(total_Cases as int )) AS TotalCasesCount, 
  MAX(cast(total_deaths as int ))AS TotalDeathsCount,
  (MAX(cast(total_deaths as int ))/MAX(cast(total_Cases as int )))*100 as DeathPercentage
FROM
  `invertible-now-355003.covid_19.covid`
WHERE continent is  NULL
GROUP BY continent
ORDER BY DeathPercentage DESC

--Looking at Total Cases vs Population 
SELECT
 location, date, total_Cases, population, 
(total_deaths/population)*100 as PercentPopulationInfected
FROM
  `invertible-now-355003.covid_19.covid`
WHERE  date = '2022-10-06'
ORDER BY PercentPopulationInfected DESC

-- Looking at Countries with highest infection rate compared to population
SELECT 
  location, population, MAX (total_cases) AS HighestInfectionCount, 
	(MAX(total_cases)/population)*100 AS PercentPopulationInfected
FROM
  `invertible-now-355003.covid_19.covid`
WHERE continent is not null
GROUP BY location , population
ORDER BY PercentPopulationInfected DESC


-- Looking at Countries with highest infection rate compared to population
SELECT 
  location, population, MAX (total_cases) AS HighestInfectionCount, 
	(MAX(total_cases)/population)*100 AS PercentPopulationInfected
FROM
  `invertible-now-355003.covid_19.covid`
WHERE continent is not null
GROUP BY location , population
ORDER BY PercentPopulationInfected DESC

-- Showing countries with highest death count per population

SELECT 
  location, population, MAX(cast (total_deaths as int )) AS TotalDeathCount
FROM
  `invertible-now-355003.covid_19.covid`
WHERE continent is not null
GROUP BY location ,population
ORDER BY TotalDeathCount DESC


-- Overall across the world
-- Timesereis DeathPercentage
SELECT
  date, SUM(new_cases) AS total_cases, SUM(cast(new_deaths as int )) AS total_deaths, SUM(cast(new_deaths as int)) / SUM(new_cases )*100 AS DeathPercentage
FROM
  `invertible-now-355003.covid_19.covid`
WHERE continent is not null
GROUP BY date
ORDER BY 1,2

-- Timesereis PopulationInfected
SELECT
  continent, location,date,population,total_cases, 
  total_cases / population *100 AS InfectedPercentage
FROM
  `invertible-now-355003.covid_19.covid`
WHERE continent is not null AND location in ('United States', 'United Kingdom', 'France','Russia', 'China', 'India', 'Japan')
GROUP BY continent, location,date,population,total_cases
ORDER BY 1,2

-- USE CTE to get Rolling percetage of people vaccinated

WITH PopvsVac 
AS (
SELECT 
  continent, location, date, population,new_vaccinations,
  SUM (cast(new_vaccinations as int )) over (partition by location order by location, date) AS RollingPeopleVaccinated
FROM
  `invertible-now-355003.covid_19.covid`
WHERE continent is not null
  )
SELECT * , (RollingPeopleVaccinated/population)*100 AS VaccinatedPercentage
FROM PopvsVac

-- Looking at Top 10 Vaccinate Count Person-times
WITH PopvsVac 
AS (
SELECT 
  continent, location, date, population,new_vaccinations,
  SUM (cast(new_vaccinations as int )) over (partition by location order by location, date) AS RollingPeopleVaccinated 
FROM
  `invertible-now-355003.covid_19.covid`
WHERE continent is not null
  )
SELECT * 
FROM PopvsVac
WHERE  date in ('2022-10-06')
ORDER BY RollingPeopleVaccinated DESC LIMIT 10

----------------------------------------------------------------Covid Cases Analysis(China)-----------------------------------------------------------------------

--Data Cleaning

SELECT DISTINCT
  province
FROM 
  `invertible-now-355003.covid_19.covid_China` 

--33 results

--Checking Start-End Date 
SELECT
  MIN(date) AS start_date,
  MAX(date) AS end_date
FROM
   `invertible-now-355003.covid_19.covid_China`

--start_date	end_date	
--2020-01-22  2022-09-28

--Adding extra Features to the table:
 
SELECT 
  province,date,cases,deaths,recovered,
  cases - LAG(cases) OVER (PARTITION BY province ORDER BY date ) AS perDayCase,
  deaths - LAG(deaths)  OVER (PARTITION BY province ORDER BY date ) AS perDaydeath,
  recovered - LAG(recovered)  OVER (PARTITION BY province ORDER BY date ) AS perDayrecovered
FROM
   `invertible-now-355003.covid_19.covid_China`

--Total province-wise Confirmed cases till date

SELECT  
  province,
	MAX(cases) AS TotalCases
FROM 
   `invertible-now-355003.covid_19.covid_China`  
GROUP BY province 
ORDER BY TotalCases DESC LIMIT 10

SELECT  
  province,
	MAX(deaths) AS TotalDeath
FROM 
   `invertible-now-355003.covid_19.covid_China`  
GROUP BY province 
ORDER BY TotalDeath DESC LIMIT 10

--Maximum Per-Day Confirmed case per province

SELECT  DISTINCT
  province,
  date,
	MaxPerDayCase
FROM
  (SELECT  
     date,
		province,
		MAX(PerDayCase) OVER (PARTITION BY province) AS MaxPerDayCase,
		DENSE_RANK() OVER (PARTITION BY province ORDER BY PerDayCase desc) AS HighestCase,
    ROW_NUMBER() OVER(PARTITION BY province ORDER BY PerDayCase DESC) AS RowNumber
FROM `invertible-now-355003.covid_19.covid_China_ALL`  ) cte
WHERE HighestCase = 1 and RowNumber = 1
ORDER BY MaxPerDayCase DESC

--Maximum Per-Day Deaths case per province

SELECT  
  province,
  date,
	MaxPerDayDeath,
FROM
  (SELECT  
    date,
		province,
		MAX(perDaydeath) OVER (PARTITION BY province) AS MaxPerDayDeath,
		DENSE_RANK() OVER (PARTITION BY province ORDER BY perDaydeath desc) AS HighestDeath,
    ROW_NUMBER() OVER(PARTITION BY province ORDER BY perDaydeath DESC) AS RowNumber
FROM `invertible-now-355003.covid_19.covid_China_ALL`  ) CTE
WHERE HighestDeath = 1 and RowNumber = 1
ORDER BY MaxPerDayDeath DESC

--Calculating the State-wise Mortality Rate


SELECT  
  province, 
	Round((CovidDeaths/CovidCases)*100, 2)  AS DeathRate
FROM 
    (SELECT  
      province,
		  Max(deaths) as CovidDeaths,
		  Max(cases) as CovidCases
    FROM `invertible-now-355003.covid_19.covid_China_ALL`
    GROUP BY province)
GROUP BY province,CovidDeaths,CovidCases
ORDER BY DeathRate DESC


--Finding the 'Time' when Covid Waves attacked “Hong Kong"

CREATE TABLE invertible-now-355003.covid_19.HK_MonthlyCases AS 
SELECT  
  province,
	date,
  Year_Month,
	ROUND(Spike,2) as AvgSpikeInCases
FROM  (
  SELECT  
      province,
		  date,
		  year,
      month,
      Year_Month,
		  perDayCase,
		  AVG(PerDayCase) OVER (PARTITION BY Year_Month) as Spike
FROM `invertible-now-355003.covid_19.covid_China_Y`
WHERE province  in ( 'Hong Kong' ) 
ORDER BY date


SELECT 
  province,
	date,
  Year_Month,
  AvgSpikeInCases
FROM (
SELECT 
  province,
	date,
  Year_Month,
  AvgSpikeInCases,
  ROW_NUMBER() OVER(PARTITION BY Year_Month ORDER BY AvgSpikeInCases DESC) AS RowNumber
FROM `invertible-now-355003.covid_19.HK_MonthlyCases`)
WHERE RowNumber = 1
ORDER BY date

-- Finding the 'Time' when Covid Waves attacked “Hubei"

CREATE TABLE invertible-now-355003.covid_19.HB_MonthlyCases AS 
SELECT  
  province,
	date,
  Year_Month,
	ROUND(Spike,2) as AvgSpikeInCases
FROM  (
  SELECT  
      province,
		  date,
		  year,
      month,
      Year_Month,
		  perDayCase,
		  AVG(PerDayCase) OVER (PARTITION BY Year_Month) as Spike
FROM `invertible-now-355003.covid_19.covid_China_Y`)
WHERE province = 'Hubei' 
ORDER BY date


SELECT 
  province,
	date,
  Year_Month,
  AvgSpikeInCases
FROM (
SELECT 
  province,
	date,
  Year_Month,
  AvgSpikeInCases,
  ROW_NUMBER() OVER(PARTITION BY Year_Month ORDER BY AvgSpikeInCases DESC) AS RowNumber
FROM `invertible-now-355003.covid_19.HB_MonthlyCases`)
WHERE RowNumber = 1
ORDER BY date


-- Finding the 'Time' when Covid Waves attacked “Shanghai"

CREATE TABLE invertible-now-355003.covid_19.SH_MonthlyCases AS 
SELECT  
  province,
	date,
  Year_Month,
	ROUND(Spike,2) as AvgSpikeInCases
FROM  (
  SELECT  
      province,
		  date,
		  year,
      month,
      Year_Month,
		  perDayCase,
		  AVG(PerDayCase) OVER (PARTITION BY Year_Month) as Spike
FROM `invertible-now-355003.covid_19.covid_China_Y`)
WHERE province = 'Shanghai' 
ORDER BY date


SELECT 
  province,
	date,
  Year_Month,
  AvgSpikeInCases
FROM (
SELECT 
  province,
	date,
  Year_Month,
  AvgSpikeInCases,
  ROW_NUMBER() OVER(PARTITION BY Year_Month ORDER BY AvgSpikeInCases DESC) AS RowNumber
FROM `invertible-now-355003.covid_19.SH_MonthlyCases`)
WHERE RowNumber = 1
ORDER BY date

--Percent Covid Cases in China till date

SELECT 
  province,
	date,
  cases,
   SAFE_DIVIDE(cases,SUM(cases) OVER()) *100 AS percent 
FROM  `invertible-now-355003.covid_19.covid_China`
WHERE date = '2022-9-28'
GROUP BY province,cases,date

--Percent Covid deaths in China till date
SELECT 
  province,
	date,
  deaths,
   SAFE_DIVIDE(deaths,SUM(deaths) OVER()) *100 AS percent 
FROM  `invertible-now-355003.covid_19.covid_China`
WHERE date = '2022-9-28'
GROUP BY province,deaths,date






