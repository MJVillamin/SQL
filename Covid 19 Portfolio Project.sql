
select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths
order by 1,2

select location, date, total_cases, total_deaths, (convert(float,total_deaths)/nullif(Convert(float,total_cases),0))*100 as DeathPercentage
from PortfolioProject..CovidDeaths
order by 1,2

select location, date, total_cases, total_deaths, (convert(float,total_deaths)/nullif(Convert(float,total_cases),0))*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where location like 'Philippines'
order by 1,2

select location, date, total_cases, total_deaths, (convert(float,total_deaths)/nullif(Convert(float,total_cases),0))*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where location like '%states%'
order by 1,2

select location, date, total_cases, population, (convert(float,total_cases)/population)*100 as CovidPopulationPercentage
from PortfolioProject..CovidDeaths
order by 1,2

select location, date, total_cases, population, (convert(float,total_cases)/population)*100 as CovidPopulationPercentage
from PortfolioProject..CovidDeaths
where location like 'Philippines'
order by 1,2

select location, date, total_cases, population, (convert(float,total_cases)/population)*100 as CovidPopulationPercentage
from PortfolioProject..CovidDeaths
where location like '%states%'
order by 1,2

select location, population, max(convert(float,total_cases)) as HighestInfectionCount, max(convert(float,total_cases)/population)*100 as CovidPopulationPercentage
from PortfolioProject..CovidDeaths
group by location, population
order by CovidPopulationPercentage desc

select location, max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is not null
group by location
order by TotalDeathCount desc


select continent, max(cast(total_deaths as int)) as ContinentDeathCount
from PortfolioProject..CovidDeaths
where continent is not null
group by continent
order by ContinentDeathCount desc

select location, max(cast(total_deaths as int)) as ContinentDeathCount
from PortfolioProject..CovidDeaths
where continent is null and location not like '%income%' and location not like'%World%'
group by location
order by ContinentDeathCount desc



select date, sum(new_cases) as TotalCase, sum(cast(new_deaths as int)) as TotalDeath, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where continent is not null
group by date
order by DeathPercentage

select sum(new_cases) as TotalCase, sum(cast(new_deaths as int)) as TotalDeath, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where continent is not null
--group by date
order by DeathPercentage


select *
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(bigint, vac.new_vaccinations)) over (partition by dea.location
order by dea.location, dea.date) as RollingVaccinatedPeople
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3


with PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingVaccinatedPeople)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(bigint, vac.new_vaccinations)) over (partition by  dea.location
order by dea.location, dea.date) as RollingVaccinatedPeople
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
)
select *, (RollingVaccinatedPeople/Population)*100 as VaccinatedPopulationPercentage
from PopvsVac



Create Table #VaccinatedPopulationPercentage
(
Continent varchar(255),
Location varchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingVaccinatedPeople numeric
)
Insert into #VaccinatedPopulationPercentage
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(bigint, vac.new_vaccinations)) over (partition by dea.location
order by dea.location, dea.date) as RollingVaccinatedPeople
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null

select *, (RollingVaccinatedPeople/Population)*100 as VaccinatedPopulationPercentage
from #VaccinatedPopulationPercentage


Drop Table if Exists #VaccinatedPopulationPercentage
Create Table #VaccinatedPopulationPercentage
(
Continent varchar(255),
Location varchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingVaccinatedPeople numeric
)
Insert into #VaccinatedPopulationPercentage
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(bigint, vac.new_vaccinations)) over (partition by  dea.location
order by dea.location, dea.date) as RollingVaccinatedPeople
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null

select *, (RollingVaccinatedPeople/Population)*100 as VaccinatedPopulationPercentage
from #VaccinatedPopulationPercentage


create view VaccinatedPopulationPercentage
as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(bigint, vac.new_vaccinations)) over (partition by  dea.location
order by dea.location, dea.date) as RollingVaccinatedPeople
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null

select *
from VaccinatedPopulationPercentage