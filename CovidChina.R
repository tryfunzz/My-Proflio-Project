----------------------------------------------------------------Covid Cases Analysis(China)-----------------------------------------------------------------------

For the global data analysis ,I use the OWID dataset , select the cases and deaths ,recovered and population columns.

For the China data analysis, I use the  Johns Hopkins University dataset, select 32 provinces in CHina data ,and pivot long by R.

install.packages("readxl")
library("readxl")
library(tidyr)
library(dplyr)

#Load the  1st Dataset
confirmed <- read_excel("D:\\analysis\\case study 3\\op_time_series_covid19_China_confirmed.xlsx")
confirmed_long <- pivot_longer(confirmed,cols =-1,names_to = "province", values_to = "cases" )
China_confirmed <- confirmed_long %>%
  select(province,everything())

#Load the  2nd Dataset
deaths <- read_excel("D:\\analysis\\case study 3\\op_time_series_covid19_China_deaths.xlsx")
deaths_long <- pivot_longer(deaths,cols =-1,names_to = "province", values_to = "deaths" )

China_deaths <- deaths_long %>%
  select(province,everything()) 
 
#Load the  3rd Dataset
recovered<- read_excel("D:\\analysis\\case study 3\\op_time_series_covid19_China_recovered.xlsx")

recovered_long <- pivot_longer(recovered,cols =-1,names_to = "province", values_to = "recovered" )
China_recovered <- recovered_long %>%
  select(province,everything())

#write data
write.csv(China_recovered,file="D:\\analysis\\case study 3\\China_recover.csv")
write.csv(China_deaths,file="D:\\analysis\\case study 3\\China_deaths.csv")
write.csv(China_confirmed,file="D:\\analysis\\case study 3\\China_cases.csv")

#merge the 3 tables
m_1 <- merge(x=China_confirmed,y=China_deaths,all=TRUE)
m_2 <- merge(x=m_1,y=China_recovered,all=TRUE)

#write data
write.csv(m_2,file = "D:\\analysis\\case study 3\\China_covid.csv" )
