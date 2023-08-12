
select*
from PortfolioProject..CovidDeaths$
where continent is not null
order by 3,4


--select*
--from PortfolioProject..CovidVaccinations$
--order by 3,4

--select data we are going to be using

select Location , date,total_cases,new_cases,total_deaths,population
from PortfolioProject..CovidDeaths$
order by 1,2

--looking at total cases vs total deaths

select Location ,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as deathpercent
from PortfolioProject..CovidDeaths$
where location like '%states%'
and continent is not null
order by 1,2

--looking at the total cases vs the population
--shows percentage of population got covid

select Location ,date,population,total_cases,(total_cases/population)*100 as deathpercent
from PortfolioProject..CovidDeaths$
--where location like '%states%'
order by 1,2


--looking at countries with highest infection rate compared to population

select Location,population,Max(total_cases)as highestinfectionCount,Max((total_cases/population))*100 as percentpopulationinfected
from PortfolioProject..CovidDeaths$
--where location like '%states%'
group by Location,population
order by percentpopulationinfected desc


--showing countries with highest death count perpopulation

select Location,  Max(cast(total_deaths as int))as TotalDeathCount
from PortfolioProject..CovidDeaths$
--where location like '%states%'
where continent is not null
group by Location
order by TotalDeathCount desc  


--LET'S BREAK THINGS DOWN BY CONTINENT

select continent,  Max(cast(total_deaths as int))as TotalDeathCount
from PortfolioProject..CovidDeaths$
--where location like '%states%'
where continent is not null
group by continent
order by TotalDeathCount desc  


--LET'S BREAK THINGS DOWN BY CONTINENT


--showing the continents with the highest death count per population


select continent,  Max(cast(total_deaths as int))as TotalDeathCount
from PortfolioProject..CovidDeaths$
--where location like '%states%'
where continent is not null
group by continent
order by TotalDeathCount desc 



--GLOBAL NUMBERS


select Sum(new_cases)as total_cases, Sum(cast(new_deaths as int))as total_deaths,Sum(cast(new_deaths as int))/Sum(new_cases)*100 as deathpercentage
from PortfolioProject..CovidDeaths$
--where location like '%states%'
where continent is not null
--group by date
order by 1,2


--looking at Total population vs vaccination

-- USE CTE

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,Sum(Cast(vac.new_vaccinations as int)) Over (Partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
    on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select*, (RollingPeopleVaccinated/Population)*100
from PopvsVac



--TEMP TABLE

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
continent nvarchar(255),
Location nvarchar(255),
Date datetime,
population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)


Insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,Sum(Cast(vac.new_vaccinations as int)) Over (Partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
    on dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null
--order by 2,3


select*, (RollingPeopleVaccinated/Population)*100
from #PercentPopulationVaccinated



--Creating view to store data for visualizations

create view PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,Sum(Cast(vac.new_vaccinations as int)) Over (Partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
    on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3







