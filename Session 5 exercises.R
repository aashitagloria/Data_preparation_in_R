###########################
### Session 5 Exercises ###
###########################

#NA, NaN, nanana!
# What happens if I divide a number by 0

numbirds <- c(1,2,3,4/0,0/0,NA)
numbirds
is.na(numbirds)
is.nan(numbirds)
is.infinite(numbirds)
is.finite(numbirds)

#Filter missing
library(tidyverse)

names <- c("ID", "DBAName", "AKAName", "License", "FacilityType", "Risk", "Address", 
           "City", "State", "ZIP", "InspectionDate", "InspectionType", "Results",
           "Violations", "Latitude","Longitude","Location")

inspections <- read_csv('inspections.csv', 
                        col_names=names, skip=1)

# Look at a summary of the data
summary(inspections)

# Which inspections have NA values for license?
unlicensed <- inspections %>%
  filter(is.na(License))

licensed <- inspections %>%
  filter(!is.na(License))


#Solving the mystery of missing zeros. It will be hot. 

# Load the data file
heating <- read_csv("heating.csv")
glimpse(heating)


# Tidy the data
heating <- heating %>% 
  pivot_longer(-Source, names_to ="age", values_to="homes", 
               values_transform = list(homes = as.character))

# Look at a summary
glimpse(heating)
summary(heating)

# Attempt to convert homes from character to numeric
heating %>%
  mutate(homes=as.numeric(homes))

# Find those values
heating %>%
  filter(is.na(as.numeric(homes)))

# Replace with zeros
heating %>%
  mutate(homes=ifelse(homes==".", 0, homes)) %>%
  mutate(homes=ifelse(homes=="Z", 0, homes)) %>%
  mutate(homes=as.numeric(homes)) %>%
  filter(Source=="Cooking stove")

#Apply on the dataset
heating <- heating %>%
  mutate(homes=ifelse(homes==".", 0, homes)) %>%
  mutate(homes=ifelse(homes=="Z", 0, homes)) %>%
  mutate(homes=as.numeric(homes))

#When nothing is missing... Doch, vermisste Schizophrene sind nicht allein

# Load the data file
land <- read_csv("publiclands.csv")

# Look at the data
summary(land)

# How many rows are there?
nrow(land)
unique(land$State)

# Insert missing states
missing_states <- tibble(State=c('Connecticut', 'Delaware', 'Hawaii', 'Iowa', 'Maryland', 
                                 'Massachusetts','New Jersey', 'Rhode Island'), 
                         PublicLandAcres=c(0,0,0,0,0,0,0,0))

land_full <- rbind(land, missing_states)
#Alternatively
land_full <- bind_rows(land, missing_states)
View(land_full)

mean(land$PublicLandAcres)
mean(land_full$PublicLandAcres)

#Almost ready for ML 101 course

# Load the data file
iris <- read_csv("dirty petal.csv")

# Look at the data
View(iris)

# What happens when we try some aggregate functions?
sum(iris$Petal.Length)
mean(iris$Petal.Length)
max(iris$Petal.Length)

# We can remove missing values before our calculation
sum(iris$Petal.Length, na.rm=TRUE)
mean(iris$Petal.Length, na.rm=TRUE)
max(iris$Petal.Length, na.rm=TRUE)

#Olympics forever
# Load the data file
olympics <- read_csv("olympic games.txt")

# Remove duplicated rows
olympics <- unique(olympics)

# Filter out illogical records for Japan
olympics <- olympics %>%
  filter(!(City=='Tokyo, Japan' & Year==2020))

# View the dataset again
View(olympics)


# Pop
# Load the data file
library(readxl)

france <- read_excel("France population 2015.xlsx")

#Focus on the right range:
france <- read_excel("France population 2015.xlsx", range = "C4:D12")

# Take a look
glimpse(france)

# What is the population of France?
sum(france$Population)

# Remove total and gender breakouts
france <- france %>%
  filter(!(Category %in% c('Total', 'Male', 'Female')))

# What is the population of France?
sum(france$Population)

#Mexican weather cleaner
# Load the data file
weather <- read_csv("mexicanweather.csv")

# Let's look at what we have
weather

# And use pivot_wider() to make it wider
weather<- pivot_wider(weather, names_from=element, values_from=value)

# Where are we now?
weather

# That's the right format, but take a look at the data

tail(weather)

# It's pretty sparse.  We really don't need all of those lines that have two NA values
weather <- weather %>%
  filter(!(is.na(TMAX) & is.na(TMIN)))

# Let's make those column names nicer
# And just for tidyness, let's put the min before the max
weather <- weather %>%
  rename(maxtemp=TMAX, mintemp=TMIN) %>%
  select(station, date, mintemp, maxtemp)

head(weather, n=20)

# First, divide the temperatures by 10 to get them in degrees Celsius
weather <- weather %>%
  mutate(mintemp = mintemp/10) %>%
  mutate(maxtemp = maxtemp/10)

# Next, convert them to Fahrenheit
weather_fahrenheit <- weather %>%
  mutate(mintemp=mintemp*(9/5)+32) %>%
  mutate(maxtemp=maxtemp*(9/5)+32)

#Exercise 5.1
#a
coffee <- read_csv("coffeeshop.csv")
glimpse(coffee)

#b
# Data is transposed (observations are in columns, variables in rows).

#c
coffee <- coffee %>% 
  pivot_longer(!Beverage_category, names_to = "Beverage_type",
               values_to = "value") %>%
  pivot_wider(names_from = Beverage_category,
              values_from = value)

#d
#coffee <- coffee %>% 
#  rename(Beverage_category=Beverage_type)
coffee <- coffee %>% 
  separate_wider_delim(Beverage_type, "...", names=c("Beverage_category", "mess"))
coffee <- coffee%>% select(-mess)
#Alternatively, you can use gsub and rename

#e
unique(coffee$`Total Fat (g)`)
# A value of 3 2 instead of 3.2
unique(coffee$`Caffeine (mg)`)
# Values like varies and Varies are not numbers. 

#f
unique(coffee$`Total Fat (g)`)
coffee <- coffee %>%
  mutate(`Total Fat (g)`=ifelse(`Total Fat (g)`=="3 2", "3.2", `Total Fat (g)`))
unique(coffee$`Caffeine (mg)`)
coffee <- coffee %>%
  mutate(`Caffeine (mg)`=ifelse(`Caffeine (mg)`=="Varies", NA, `Caffeine (mg)`)) %>%
  mutate(`Caffeine (mg)`=ifelse(`Caffeine (mg)`=="varies", NA, `Caffeine (mg)`))
#You can also find a solution to solve with ignoring the case


#g
coffee[4:18] <- sapply(coffee[4:18],as.numeric)
coffee <- coffee %>% mutate(across(4:18, as.numeric))
  
#h
cafeine <- max(coffee$`Caffeine (mg)`, na.rm=TRUE)
coffee$`Sugars (g)`[coffee$`Caffeine (mg)`==cafeine & !is.na(coffee$`Caffeine (mg)`)]

