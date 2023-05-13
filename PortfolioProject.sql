SELECT
	*
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
ORDER BY 3, 4;

SELECT
	location,
	date,
	total_cases,
	new_cases,
	total_deaths,
	population
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
ORDER BY 1, 2;

-- Looking at Total Cases vs Total Deaths
-- Shows chance of dying if you contract covid in your country

SELECT
	location,
	date,
	total_cases,
	total_deaths,
	(total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE location = 'Indonesia' and continent is not null
ORDER BY 1, 2;

-- Looking at Total Cases vs Population
-- Shows what percentage of population got Covid

SELECT
	location,
	date,
	population,
	total_cases,
	(total_cases/population)*100 as PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
ORDER BY 1, 2;

-- Looking at Country with Highest Infection Rate compared to Population

SELECT
	location,
	population,
	MAX(total_cases) as HighestInfectionCount,
	MAX(total_cases/population)*100 as PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
GROUP BY 1, 2
ORDER BY PercentPopulationInfected desc;


-- Showing Countries with Highest Death Count per Population

SELECT
	location,
	MAX(CAST(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
GROUP BY location 
ORDER BY TotalDeathCount desc;

-- Lets break things down by continent

-- Showing Continents with the Highest Death Count per Population

SELECT
	continent,
	MAX(CAST(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount desc;

-- Global Numbers

SELECT
	SUM(new_cases) as total_cases,
	SUM(CAST(new_deaths as int)) as total_deaths,
	SUM(CAST(new_deaths as int)) / SUM(new_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
ORDER BY 1, 2;

SELECT
	date,
	SUM(new_cases) as total_cases,
	SUM(CAST(new_deaths as int)) as total_deaths,
	SUM(CAST(new_deaths as int)) / SUM(new_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
GROUP BY date
ORDER BY 1, 2;


-- Total at Total Population vs Vaccinations


SELECT 
	dea.continent,
	dea.location,
	dea.date,
	dea.population, 
	vac.new_vaccinations,
	SUM(CAST(vac.new_vaccinations as int)) OVER (
						PARTITION BY dea.location
						ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null
	AND dea.date >'2022-01-01'
ORDER BY 2,3;


-- CTE or subqueries

With PopVsVac (
	continent, 
	location, 
	date, 
	population, 
	new_vaccinations, 
	RollingPoepleVaccinated
) as
(
SELECT 
	dea.continent,
	dea.location,
	dea.date,
	dea.population,
	vac.new_vaccinations,
	SUM(CAST(vac.new_vaccinations as int)) OVER (
						PARTITION BY dea.location
						ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null
	AND dea.date >'2022-01-01'
)

SELECT
	*,
	(RollingPoepleVaccinated/population)*100
FROM PopVsVac;


-- Temp table

Drop table if exists #PercentPopulationVaccinated
Create table #PercentPopulationVaccinated
(
	Continent nvarchar(255),
	Location nvarchar(255),
	Date datetime,
	Population numeric,
	New_vaccinations numeric,
	RollingPeopleVaccinated numeric
)

INSERT INTO #PercentPopulationVaccinated
SELECT
	dea.continent,
	dea.location,
	dea.date,
	dea.population,
	vac.new_vaccinations,
	SUM(CAST(vac.new_vaccinations as int)) OVER (
						PARTITION BY dea.location
						ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null
	AND dea.date >'2022-01-01'
	
SELECT 
	*,
	(RollingPeopleVaccinated/Population)*100
FROM #PercentPopulationVaccinated;



-- Creating view to store data for later visualizations

Create view PercentPopulationVaccinated as
SELECT
	dea.continent,
	dea.location,
	dea.date,
	dea.population,
	vac.new_vaccinations,
	SUM(CAST(vac.new_vaccinations as int)) OVER (
						PARTITION BY dea.location 
						ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null
	AND dea.date >'2022-01-01'


SELECT
	*
FROM PercentPopulationVaccinated;
