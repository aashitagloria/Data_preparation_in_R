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
coffee <- read_csv("coffeeshop.csv")

#b) The data frame is not tidy. Explain what is wrong and why.

# Data is transposed (observations are in columns, variables in rows).

#c) Using pivot functions, restructure the data frame.

coffee <- coffee %>% 
  pivot_longer(!Beverage_category, names_to = "Beverage_type",
               values_to = "value") %>%
  pivot_wider(names_from = Beverage_category,
              values_from = value)

#d) Clean the first column, it should be named ‘Beverage_category’ and should have only text, 
# but no …or numbers.

coffee <- coffee %>% 
  separate_wider_delim(Beverage_type, "...", names=c("Beverage_category", "mess"))
coffee <- coffee%>% select(-mess)

# e) Check the unique values of Total fat and Caffeine. What problems do you see with them?

unique(coffee$`Total Fat (g)`)
# A value of 3 2 instead of 3.2
unique(coffee$`Caffeine (mg)`)
# Values like varies and Varies are not numbers. 

#f) Clean the Total fat. We should have numbers. 
#Also, clean Caffeine, whenever more values are possible,just use NA.
unique(coffee$`Total Fat (g)`)
coffee <- coffee %>%
  mutate(`Total Fat (g)`=ifelse(`Total Fat (g)`=="3 2", "3.2", `Total Fat (g)`))
unique(coffee$`Caffeine (mg)`)
coffee <- coffee %>%
  mutate(`Caffeine (mg)`=ifelse(`Caffeine (mg)`=="Varies", NA, `Caffeine (mg)`)) %>%
  mutate(`Caffeine (mg)`=ifelse(`Caffeine (mg)`=="varies", NA, `Caffeine (mg)`))

#g) Change variable types, use numeric where it is possible to.
coffee[4:18] <- sapply(coffee[4:18],as.numeric)
coffee <- coffee %>% mutate(across(4:18, as.numeric))
glimpse(coffee)

#h) Calculate the sugar content in grams of the drink with the highest caffeine level. (hard exercise)

cafeine <- max(coffee$`Caffeine (mg)`, na.rm=TRUE)
coffee$`Sugars (g)`[coffee$`Caffeine (mg)`==cafeine & !is.na(coffee$`Caffeine (mg)`)]
