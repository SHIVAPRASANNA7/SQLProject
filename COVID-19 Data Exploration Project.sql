select *
from [SqlProject ]..CovidDeaths
where continent is not null
order by 3,4

--select *
--from [SqlProject ]..CovidVaccinations
--order by 3,4

-- select Data that we are going to be using 

select location,date,total_cases,new_cases,total_deaths,population
from [SqlProject ]..CovidDeaths
where continent is not null
order by 1,2

-- Looking at Totalcases vs TotalDeath

select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as Deathpercentage
from [SqlProject ]..CovidDeaths
where location like '%india%'
order by 1,2

--Looking at Total Cases vs Population

select location,date,total_cases,population,(total_cases/population)*100 as populationpercentage
from [SqlProject ]..CovidDeaths
where location like '%india%'
and continent is not null
order by 1,2

-- Looking at Countries with highest Infection Rate compared to population 

select Location,population,Max(total_cases) as HighestInfectioncount, Max((total_cases/population))*100 as 
populatioinfectedpercentage
from [SqlProject ]..CovidDeaths
group by location,population
order by populatioinfectedpercentage desc

-- Showing Countries With Highest Death Count per Population

select Location, Max(total_deaths) as deathcount
from [SqlProject ]..CovidDeaths
where continent is not null
group by location
order by deathcount desc

-- lets break things down by continent

select continent, Max(total_deaths) as deathcount
from [SqlProject ]..CovidDeaths
where continent is not null
group by continent
order by deathcount desc

--Global Numbers

select Sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths,sum(cast
 (new_deaths as int))/sum(New_Cases)*100 as Deathpercentage
from Sqlproject..CovidDeaths
where continent is not null
--group by date
order by 1,2

--Looking at total population vs vaccination

select dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as peoplevaccinated
from [SqlProject ]..CovidDeaths as dea 
join [SqlProject ]..CovidVaccinations as vac
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null
 order by 2,3

 -- USE CTE
 with popvsvac (continent,location,date,population,new_vaccination,peoplevaccinated)
 as
 (
 select dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as peoplevaccinated
from [SqlProject ]..CovidDeaths as dea 
join [SqlProject ]..CovidVaccinations as vac
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null
 --order by 2,3
 )
 select*, (peoplevaccinated/population)*100
 from popvsvac

 --Temp table

 drop table if exists #percentpopulationvaccinated
 create table #percentpopulationvaccinated
 (
 continent nvarchar(255),
 location nvarchar(255),
 date datetime,
 population numeric,
 new_vaccinations numeric,
 peoplevaccinated numeric
 )
 insert into #percentpopulationvaccinated
 select dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as peoplevaccinated
from [SqlProject ]..CovidDeaths as dea 
join [SqlProject ]..CovidVaccinations as vac
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null
 --order by 2,3

 select*,(peoplevaccinated/population)*100
 from #percentpopulationvaccinated

 --create view to store data for later visualization

 create  view percentpopulationvaccinated as
 select dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as peoplevaccinated
from [SqlProject ]..CovidDeaths as dea 
join [SqlProject ]..CovidVaccinations as vac
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null
-- order by 2,3

select *
from percentpopulationvaccinated
 


