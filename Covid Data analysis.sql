select * from CovidDeaths

-- removing duplicates from the data

select distinct * into CovidDeaths
from CovidDeath


--  creating a separate table for Germany data and used distinct to remove any duplicates

select distinct * into Germanydata
from CovidDeaths 
where location = 'Germany'

--  creating a separate table for pakistan data and used distinct to remove any duplicates

select distinct * into Pakistandata
from CovidDeaths 
where location = 'Pakistan'

select * from GermanyData

-- accessing specific columns from the table 

select location, date, population, total_cases, total_deaths
from CovidDeaths
order by 1,2

-- data for Germany

select location, date, population, total_cases, total_deaths
from CovidDeaths
where location like '%Germany%'
order by 1,2

-- data for pakistan

select location, date, population, total_cases, total_deaths
from CovidDeaths
where location like '%Pakistan'
order by 1,2

-- total number of infected cases and deaths from around the world

select location, 
max(cast(total_cases as int)) as [Highest Infection Count] , 
MAX(cast(total_deaths as int)) as [Total Deaths] 
from CovidDeaths
group by location
order by 1

-- countries with highest infection rate 

select location, population, 
max(cast (total_cases as int ))  as [Highest Infection Count] , 
round((((max(total_cases)/population))*100), 2) as [Percentage Population Infected] 
from CovidDeaths
group by location, population
order by [Percentage Population Infected] desc
 
-- countris with highest death rate

select location, population, 
max(cast (total_deaths as int)) as [Highest Death Count], 
((max(total_deaths)/population))*100 as [Percentage Population died] 
from CovidDeaths
where continent is not null
group by location, population
order by [Percentage Population died] desc

-- countris with total deaths from covid-19

select location, population, max(cast (total_deaths as int)) as [Total Death Count]
from CovidDeaths
where continent is not null
group by location, population
order by [Total Death Count] desc
 
-- total death count by continent 

select continent,  max(cast (total_deaths as int)) as [Total Death Count]
from CovidDeaths
where continent is not null
group by continent
order by 2 desc

-- percentage death count by continent 

select continent, 
max(population) as [Total Population], 
max(cast (total_deaths as int)) as [Total Death Count],  
(max(cast (total_deaths as int)) /  max(population) )*100 as [Death Percentage]
from CovidDeaths
where continent is not null
group by continent

--  Numbers of new cases and deaths per month reported in Pakistan 

select year(date) as [Year], month(date) as [Month],
sum(new_cases) as [Total Covid cases], 
sum(new_deaths) as [Total Deaths]
from CovidDeaths
where continent is not NUll and location ='Pakistan'
group by month(date) , year(date)
order by 1,2

---  Numbers of new cases and deaths per month reported in Germany 

select year(date) as [Year], month(date) as [Month],
sum(new_cases) as [Total Covid cases], 
sum(new_deaths) as [Total Deaths]
from GermanyData
where continent is not NUll
group by year(date), month(date) 
order by 1,2

-- world wide cases and deaths date wise

select date, sum(new_cases) as [Total Covid Cases], 
sum (new_deaths) as [Total Covid Deaths]
from CovidDeaths
where continent is not NUll
group by date
order by date

-- world wide cases and deaths per month

select year(date) as [Year], month(date) as [Month],
sum(new_cases) as [Total Covid cases], 
sum(new_deaths) as [Total Deaths]
from CovidDeaths
where continent is not NUll
group by year(date), month(date) 
order by 1,2

select date, sum(new_cases) as [Total New Cases], 
sum (new_deaths) as [Total New Deaths], 
sum(new_deaths)/sum(new_cases)*100 as [Death Percentage]
from CovidDeaths
where continent is not NUll 
group by date
order by 1,2

-- covid Vaccinations by joining the 2 tables

select distinct (d.date), d.continent, d.location,  d.population, v.new_vaccinations
from CovidDeaths d
inner join CovidVaccinations v
on d.date = v.date
where d.location = 'Germany'
order by 2, 3


-----
create table #covidDeaths(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric
)
insert into #covidDeaths
select continent, location, date, population from CovidDeaths

create table #covidVaccinaations(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric, 
New_vaccinations numeric
)

insert into #covidVaccinaations
select continent, location, date, population, new_vaccinations 
from CovidVaccinations

select distinct (c.date), c.continent, c.location,  c.	population, v.new_vaccinations,
sum(cast(v.new_vaccinations as numeric)) over 
(partition by c.location)
from CovidDeaths c
join CovidVaccinations v
on c.location = v.location 
and c.date = v.date
where c.continent is not Null
order by 3,1


-- Total Number of population vaccinated 
-- percentage of population vaccinated 

select location, population, 
sum(cast(new_vaccinations as numeric)) as [Total Vaccinations], 
max(cast(people_fully_vaccinated as numeric)) as [Total People Vaccinations],
max(cast(people_fully_vaccinated as numeric))/ population * 100 as [Percentage population vaccinated]
from CovidVaccinations
where continent is not null
group by location, population
order by sum(cast(new_vaccinations as numeric)) desc

-- with CTE

with PopVaccinated (Location, Population, [Total Vaccinations], [Total People Vaccinated])
as
(
select location, population, 
sum(cast(new_vaccinations as numeric)) as [Total Vaccinations], 
max(cast(people_fully_vaccinated as numeric)) as [Total People Vaccinations]
from CovidVaccinations
where continent is not null
group by location, population
)
select *, [Total People Vaccinated] / Population *100 as [Percentage People Vaccinated]
from PopVaccinated 
where [Total Vaccinations] is not null
order by 4 desc