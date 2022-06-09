select *
from PortfolioProject..covidDeath$
where continent is not null
order by 3,4

-- Select Data that we are going to be using.

select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..covidDeath$
order by 1,2

-- Calculating total cases vs total deaths for Malawi
select location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..covidDeath$
where  location like '%Malawi%'
order by 1,2


-- Total cases vs Population
select location, date, total_cases, population,(total_cases/population)*100 as DeathPercentage
from PortfolioProject..covidDeath$
where location Like '%Malawi%'
order by 1,2

-- COuntries with highest infection rate compared to population
select location, population, MAX(total_cases)as HighestInfection,Max(total_cases/population)*100 as PercentPolutionInffected
from PortfolioProject..covidDeath$
--where location Like '%Malawi%'
group by location,population
order by PercentPolutionInffected desc

-- Calculation of the highest death per population
select location, MAX(cast(total_deaths as int) )as TotalDeath
from PortfolioProject..covidDeath$
where continent is not null
group by location
order by TotalDeath desc

-- Looking the data based on continent
select continent, MAX(cast(total_deaths as int) )as TotalDeath
from PortfolioProject..covidDeath$
where continent is not null
group by continent
order by TotalDeath desc

-- World Daily Numbers 
select  date, sum(new_cases)as TotalNewCases, sum(cast(new_deaths as int))as TotalDeaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as WorldDeathPercentage 
from PortfolioProject..covidDeath$
where continent is not null
group by date
order by 1,2

-- world population vs Vaccanations
select  dea.continent,dea.location,dea.date,dea.population, vaxx.new_vaccinations
from PortfolioProject..covidDeath$ dea
join PortfolioProject..covidVAX$ vaxx
on dea.location = vaxx.location
and dea.date = vaxx.date
where dea.continent is not null
order by 1,2

-- Wordl Vaccination per_day
select  dea.continent,dea.location,dea.date,dea.population, vaxx.new_vaccinations,
sum(convert(int,vaxx.new_vaccinations ))  over (partition by dea.location order by dea.location,dea.date) as Continuedvaccinations
from PortfolioProject..covidDeath$ dea
join PortfolioProject..covidVAX$ vaxx
on dea.location = vaxx.location
and dea.date = vaxx.date
where dea.continent is not null
order by 2,3

-- calculating per country
with popvsvax (continent,location,date,population,new_vaccinations,Continuedvaccinations)
as
(
select  dea.continent,dea.location,dea.date,dea.population, vaxx.new_vaccinations,
sum(convert(int,vaxx.new_vaccinations ))  over (partition by dea.location order by dea.location,dea.date) as Continuedvaccinations

from PortfolioProject..covidDeath$ dea
join PortfolioProject..covidVAX$ vaxx
on dea.location = vaxx.location
and dea.date = vaxx.date
where dea.continent is not null
--order by 2,3
)
select*, (Continuedvaccinations/population)*100 as TotalCountryVaccinations
from popvsvax