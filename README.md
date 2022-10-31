# A look Behind Novel Coronavirus (COVID-19) China Cases VS the whole World-SQL-Tableau
Xinmei Luo

2022-10-27

🧰  Bigquery;  R; Spreadsheet; Tableau

# 1.**Context**

The 2019-nCoV is a contagious coronavirus that hailed from Wuhan, China. This new strain of virus has striked fear in many countries as cities are quarantined and hospitals are overcrowded. This dataset will help us understand how 2019-nCoV is spread aroud the world.

### **Inspiration**

Until now, China still not open and continue strict control the covid new cases, and  China has the most tough policy to get vaccinated .How the data will show the difference in China with other countries?

Unfortunately , I could not get the exactly GPA data of every province in China ,which can exactly show  the economy influence by the Epidemic prevention policy .

Anyway ,I will present my analysis to give myself the answer  , and show for anyone interested that.

There are six tips of the case: Ask , Prepare,  Process, Analysis, Share and Act.

# 2.Ask

- What are some trends in world cases?
- How could these trends apply to different countries ?
- China is the lowest Infection by the Epidemic prevention policy  ?

# 3.Prepare

### Data source

The data for this project is taken from Johns Hopkins University , and OWID .

[data source 1](https://data.humdata.org/dataset/novel-coronavirus-2019-ncov-cases)

[data source 2](https://github.com/owid/covid-19-data)

### Dataset Summary

I used excel to take a glimpse of the data .The data  collected information (01-01-2020 to 10-07-2022). 

The data contents timeseries cases , recovered , deaths, vaccinated and other foundation data about every country. More details show in the data source information.

# 4.Process and Analysis

## 4.1 **Data Import**

There are two part to prepare :

For the global data analysis ,I use the OWID dataset , select the cases and deaths ,recovered and population columns.

For the China data analysis, I use the  Johns Hopkins University dataset, select 32 provinces in CHina data ,and pivot long by R.
After checke the date and NULL , I opened Bigquery Console ,then select my Project. Create covid_19  name of the dataset .I imported the .csv datasets I previously prepared. 
### 4.2 Catch a glimpse of table 

--**calculate total cases and total deaths**

--**Six continents** 

![image](https://user-images.githubusercontent.com/113983558/198981492-84a2b7be-6916-4328-aae8-c46fbe2ff607.png)

✍️Key takeaway : 

- Most deaths occurred in Europe, nearly 20,00,000. The least in Oceania, nearly 21,000.
- High Death Percentage  occurred in Africa and Africa.

### 4.3 Prepare Tables (within Cleaning) for Visualization
--**Latest Total Cases, Deaths and Death Rate**

![image](https://user-images.githubusercontent.com/113983558/198982342-115e7999-a8d4-4ad1-9800-f21ae83492af.png)

--**Looking at Countries with highest infection rate compared to population**

![image](https://user-images.githubusercontent.com/113983558/198982387-ab305a79-7a26-47b8-be74-aeabee734b42.png)

-- **Looking at Countries with highest infection rate compared to population**

![image](https://user-images.githubusercontent.com/113983558/198982579-b55b7f55-d3d5-47e3-b6c3-46d923969d61.png) 

-- **Showing countries with highest death count per population**

![image](https://user-images.githubusercontent.com/113983558/198982658-b88dacae-e550-4bb6-a0e5-2b1541b8a5b5.png) 

-- **Overall across the world**

-- **Timesereis DeathPercentage**

![image](https://user-images.githubusercontent.com/113983558/198982737-b7710df0-c991-409f-a80a-ad575a443c5b.png)

-- **Timesereis PopulationInfected**

![image](https://user-images.githubusercontent.com/113983558/198982787-cd14e1a5-dfa3-4510-89c3-17b6df59674b.png)

-- **USE CTE to get Rolling percetage of people vaccinated**

![image](https://user-images.githubusercontent.com/113983558/198982849-8980f919-3b39-4fd5-8d2f-a09d660fd896.png)

-- **Looking at Top 10 Vaccinate Count Person-times**

![image](https://user-images.githubusercontent.com/113983558/198982887-eb64d46a-0336-4082-aa52-632bf6004aa2.png)

✍️**Key takeaway** : 

      Compared all the charts 

- **Infect rate** -
    1. The global high infect rate occurred in Europe and Australia . The highest Infected rate  around **60%** ,which happened more than 10 countries. **Around 80 countries with above 20% infect rate.**
    2. **Omicron** has the high influence , which the rolling infect rate show **the common point of inflection in the Dec 2021**.Also anastomosis death count wave.
- **Death rate** -
    1. Until Oct 2022, the global covid death rate is around **1%**, and the highest counts is happened in **United States** , which more than **1  million**. 
    2. The death wave is average before May 2022, and the death rate is continuous reduction after May 2020.
- **Vaccinated vs Waves** :
    1. the global vaccinate time starts in  the Dec 2020 ,but the highest infect wave around world is in the beginning of the 20222.Cause the Omicron.  
    2. The highest deathrate wave in the beginning of the  covid , the next wave around the 2020 ending and 2021 beginning , with the highest death counts . After that, the vaccinate influent the deathrate mostly.
    3. China have the highest Vaccinate Count Person-times count , and  **low than 1%** infect rate .


### 4.4 China data

**Check the date and prepare the crucial dataset for visulization**

--Total province-wise Confirmed cases till date

--Maximum Per-Day Confirmed case per province

--Maximum Per-Day Deaths case per province

![image](https://user-images.githubusercontent.com/113983558/198986686-ab7b9838-1376-4983-83f1-ed5d7eb2f00d.png)

![image](https://user-images.githubusercontent.com/113983558/198986711-6658fc62-e459-4422-aec1-1a4823667ab5.png)

--Calculating the State-wise Mortality Rate

![image](https://user-images.githubusercontent.com/113983558/198986879-b759afa2-2987-45f9-b5ec-283dd268d4cb.png)

--Finding the 'Time' when Covid Waves attacked “Hong Kong"

-- Finding the 'Time' when Covid Waves attacked “Hubei"

-- Finding the 'Time' when Covid Waves attacked “Shanghai"

--Percent Covid Cases in China till date

![image](https://user-images.githubusercontent.com/113983558/198987016-bcf811d5-ae27-477e-9302-7efde667f614.png)

✍️**Key takeaway** : 

      Compared all the charts province-wise

- **Infect Percentage**  -
    1. The China high infect count Percentage occurred in Hubei(**3%**)  ,ShangHai(**3%**) and Hongkong(**87%)** .  **Other provinces** **Around low than 1% infect count.**
    2. **Omicron** has the high influence , which the rolling infect count show **the common point of inflection in the Feb 2022, which later than the Omicron attack in other countries.**
- **Death Percentage** -
    1. The  high deaths count Percentage also occurred in Hubei(**29%**)  ,ShangHai(**3%**) and Hongkong(**65%)** .  **Other provinces** **Around low than 1% infect count.**
    2. The death wave is average before Feb 2022, and the death count is continuous increase until  May 2022. 
- **Vaccinated vs Waves** :
    1. With the most  tough Epidemic prevention policy , Almost  the wave is the same speed with global data.
    2. Expect Hubei ,ShangHai and HongKong are the port city ,which higher infection rate probability than inland cities . The death wave  increasing show the vaccinate lose efficacy.
