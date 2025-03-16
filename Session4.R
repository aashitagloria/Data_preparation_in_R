###########################
### Session 4 Exercises ###
###########################

# Separate
#a 
# Load the tidyverse and read in the Medicare payments dataset
library(tidyverse)
names <- c("DRG", "ProviderID", "Name", "Address", "City", "State", "ZIP", 
           "Region", "Discharges", "AverageCharges", "AverageTotalPayments", 
           "AverageMedicarePayments")
types = 'ccccccccinnn'
inpatient <- read_tsv('inpatient.tsv', 
                      col_names = names, skip=1, col_types = types)

#b
# Take a look at the diagnosis-related group (DRG) unique values
unique(inpatient$DRG)

#c
# Let's try separating this on the hyphen
inpatient_separate <- separate(inpatient,DRG,c('DRGcode','DRGdescription'),'-')


#d
# Take a look at the error message and try to find out what is going on.
# Let's look at row 45894
inpatient$DRG[45894]

#Maybe 
inpatient_separate <- separate(inpatient,DRG,c('DRGcode','DRGdescription'),' - ')

#e
# Let's separate with character position instead
inpatient_separate <- separate(inpatient,DRG,c('DRGcode','DRGdescription'),4)

#f
# Take a look at the data now
glimpse(inpatient_separate)

inpatient_separate <- separate(inpatient,DRG,c('DRGcode','DRGdescription'),3)
inpatient_separate <- separate(inpatient_separate,DRGdescription,c('waste','DRGdescription'),3)

inpatient_separate <- select(inpatient_separate, -waste)


# The same with the new function:
#inpatient_separate <- separate_wider_delim(inpatient,
#                                           cols=DRG,
#                                           names=c('DRGcode','DRGdescription'),
#                                           delim='-')
#It does not work, we have tell what to do with problematic values

inpatient_separate <- separate_wider_delim(inpatient,
                                           cols=DRG,
                                           names=c('DRGcode','DRGdescription'),
                                           delim='-',
                                           too_many = "merge")
#It makes the job perfectly, " - " has been trimmed.

#Position works quite badly:
inpatient_separate <- separate_wider_position(inpatient,
                                       cols=DRG,
                                       widths=c(DRGcode = 3, 3, DRGdescription=200),
                                       too_few="debug")
#It gives the good results, but we have to remove the added columns:
inpatient_separate <- inpatient_separate %>% select(-c('DRG', 'DRG_ok', 'DRG_width', 'DRG_remainder'))

#Unite
# Load the tidyverse and the food inspections dataset
library(tidyverse)

names <- c("ID", "DBAName", "AKAName", "License", "FacilityType", "Risk", "Address", 
           "City", "State", "ZIP", "InspectionDate", "InspectionType", "Results",
           "Violations", "Latitude","Longitude","Location")

inspections <- read_csv('inspections.csv', 
                        col_names=names, skip=1)

glimpse(inspections)

# Create a new column called Regions that combines City and State
regional_inspections <- unite(inspections,Region,City,State,sep=", ")

# Let's look at the data
glimpse(regional_inspections)

# Whoops. I didn't want to DELETE the City and State columns.  Let's try again.
regional_inspections <- unite(inspections,Region,City,State,sep=", ", remove=FALSE)
glimpse(regional_inspections)

# And take a look at the unique regions
unique(regional_inspections$Region)

#Exercise 4.1
library(tidyverse)
library(readxl)
library(stringr)

rainfall <- read_excel("messy-data.xlsx", skip = 1)

rainfall <- rainfall %>% separate('Month, period', c("Month", "Period"), ',')

rainfall <- rainfall %>% separate('Lake Victoria', c("Lake_Victoria", "mess"), 'm')
rainfall <- rainfall %>% separate(Simiyu, c("Simiyu", "mess"), 'm')
rainfall <- rainfall %>% select(-mess)
# Any solution using string manipulations and looking for patterns are OK.
rainfall$Lake_Victoria <- as.numeric(rainfall$Lake_Victoria)
rainfall$Simiyu <- as.numeric(rainfall$Simiyu)
# mutate can also work
rainfall <- rainfall %>% 
  pivot_longer(cols=c(Lake_Victoria, Simiyu), names_to="Place", values_to="rainfall")


#Exercise 4.2
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
