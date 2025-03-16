#Session 5: Missing values and duplicates, units, and outliers

#It's about focusing on each column one by one

#Why missing values are a problem?
#1. We lose info
#2. The analysis can be biased

#How to deal with missing values?
#1. Detect them
#2,.Use other sources to reconstruct the data
#3. Interpolate: Use inferences in the data to reconstruct
#4. Choose to ignore the missing data 

numbirds <-c(1, 2, 3, 4/0, 0/0, NA) 
#NA is null value (Not applicable) wheras Nan is Not a Number, it is different from NA
numbirds

is.na(numbirds) #Nan is treated as a missing value so it will return true for both 0/0 and NA

is.nan(numbirds) #Only 0/0 is NAN so it will return true only for 0/0

is.infinite(numbirds) #only 4/0 is infinite

is.finite(numbirds) #4/0, 0/0, and NA is not finite

# USING INSPECTIONS DATABASE
library(tidyverse)
library(readxl)

names <- c("ID", "DBAName", "AKAName", "License", "FacilityType", "Risk", "Address",
           "City", "State", "ZIP", "InspectionDate", "InspectionType", "Results",
           "Violations", "Latitude","Longitude","Location")

inspections <- read_csv('inspections.csv', col_names=names, skip=1)

summary(inspections)

unlicensed <- inspections %>% filter(is.na(License))

licensed <- inspections %>% filter(!is.na(License)) #Not of missing: It is present

#It will be hot
heating <- read_csv("heating.csv")
glimpse(heating)

#We transform the other half of the Source column to characters
heating <- heating %>%
  pivot_longer(-Source, names_to ="age", values_to="homes",
               values_transform = list(homes = as.character))

heating %>% mutate(homes=as.numeric(homes))

heating %>% filter(is.na(as.numeric(homes)))

heating %>%
  mutate(homes=ifelse(homes==".", 0, homes)) %>% 
  mutate(homes=ifelse(homes=="Z", 0, homes)) %>%
  mutate(homes=as.numeric(homes)) %>%
  filter(Source=="Cooking stove")

#Where are my states

land <- read_csv("publiclands.csv")
summary(land) #We know that there are 50 states in the USA but there are only 42 present

missing_states <- tibble(State=c('Connecticut', 'Delaware', 'Hawaii', 'Iowa', 'Maryland', 'Massachusetts',
                                 'New Jersey', 'Rhode Island'), PublicLandAcres=c(0,0,0,0,0,0,0,0))

land_full <- rbind(land, missing_states)
land_full <- bind_rows(land, missing_states)

mean(land$PublicLandAcres)
mean(land_full$PublicLandAcres)

# Iris data
iris <-read_csv("dirty petal.csv")

# THESE FUNCTIONS DO NOT LIKE NA (missing values so we put an additional argument called na.rm)
sum(iris$Petal.Length, na.rm=TRUE)
mean(iris$Sepal.Length, na.rm=TRUE)
max(iris$Sepal.Length, na.rm=TRUE)


#Duplicates

olympics <- read_csv("olympic games.txt") 
view(olympics) #we observe that Sydney is exact duplicate so we drop 2 of them 
# 2020 Japan Olympic games entry is wrong since it was cancelled during COVID

olympics <- unique(olympics)

olympics <- olympics %>%
  filter(!(City=='Tokyo, Japan' & Year==2020))


# FRANCE POPULATION 2015 DATABASE
library(readxl)
france <- read_excel("France population 2015.xlsx")
glimpse(france)

france <- read_excel("France population 2015.xlsx", range = "C4:D12")
 
# Total population of France
sum(france$Population) # this is wrong as some data is overlapping

france <- france %>%
  filter(!(Category %in% c('Total', 'Male', 'Female')))
sum(france$Population)

#Mexican weather 

weather <- read_csv("mexicanweather.csv")
weather<- pivot_wider(weather, names_from=element, values_from=value)
weather

tail(weather) # To check the last rows of the data

weather <- weather %>%
  filter(!(is.na(TMAX) & is.na(TMIN))) #if both are NA the data is useless and we both this record

tail(weather)

weather <- weather %>%
  mutate(TMAX = TMAX/10) %>%
  mutate(TMIN = TMIN/10)

#Renaming the column names from TMAX, TMIN to maxtemp, mintemp using rename function
#rename is quicker than mutate,. Mutate is a powerful but slower function
weather <- weather %>%
  rename(maxtemp=TMAX, mintemp=TMIN) %>%
  select(station, date, mintemp, maxtemp)

#Exercise 5.1
#a) Read the coffeeshop.csv file to a data frame as it is using the tidyverse library. 
#Do not change variable types and names.

library(tidyverse)
coffee_shop <- read_csv("coffeeshop.csv")

#b) The data frame is not tidy. Explain what is wrong and why.

#The data frame is dirty because the columns are unstructured and 
#drink sizes, beverage categories should be in rows instead of  columns

#c) Using pivot functions, restructure the data frame.

coffee_long <- coffee_shop %>%
  pivot_longer(
    cols = -1, # i did this to get rid of the 1st column
    names_to = "Variable",
    values_to = "Value"
  )

#d) Clean the first column, it should be named ‘Beverage_category’ and should have only text, 
# but no …or numbers.

coffee_long$Beverage_category <- as.character(coffee_long$Beverage_category)
glimpse(coffee_long)

# e) Check the unique values of Total fat and Caffeine. What problems do you see with them?

unique_total_fat <- coffee_long %>%
  filter(Beverage_category == "Total Fat") %>%
  pull(Value) %>%
  unique()

unique_caffeine <- coffee_long %>%
  filter(Beverage_category == "Caffeine") %>%
  pull(Value) %>%
  unique()

unique_total_fat
unique_caffeine

#f) Clean the Total fat. We should have numbers. 
#Also, clean Caffeine, whenever more values are possible,just use NA.
#g) Change variable types, use numeric where it is possible to.
#h) Calculate the sugar content in grams of the drink with the highest caffeine level. (hard exercise)







