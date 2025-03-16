#Session 4: Data structure - column/row operations

#MAIN FUNCTIONS:

#select() - like SELECT in SQL

#filter() - like WHERE in SQL

#bind_rows(df1, df2, df3), rbind() - only for the same number of columns

#bind_columns(df1, df2, df3), cbind - only for the same number of rows

#group_by() - like GROUP BY in SQL

#summarise()

#arrange(dataframe, variable)- like SORT function in SQL

#separate() - to separate one variable into many

#General syntax: separate(data, col, into, sep, remove, convert)

#unite() - to unite many variables into one

library(tidyverse)

#Assigning names to the columns to make it pretty
names <- c("DRG", "ProviderID", "Name", "Address", "City", "State", "ZIP",
           "Region", "Discharges", "AverageCharges", "AverageTotalPayments",
           "AverageMedicarePayments")
types = 'ccccccccinnn'
inpatient <- read_tsv('inpatient.tsv',
                      col_names = names, skip=1, col_types = types)

view(inpatient) #A clinical database with diagnosis of inpatients

unique(inpatient$DRG) #DRG is diagnosis
#Note that 039 is not a number since numbers don't start with 0, hence it is a charactert
#We would like to separate the code 039 and description of the diagnosis into 2 separate columns

#Use a separate copy for safety instead of overwriting the original file

#inpatient_separate <- separate(inpatient, DRG, c("DRGcode", "DRGDescription"),"-")

# This is giving a warning message since there might be 2 "-" sometimes

#Let's see whats wrong with the first object with warning
inpatient$DRG[45894]

#Modifying with 2 spaces before and after the hyphen
inpatient_separate <- separate(inpatient, DRG, c("DRGcode", "DRGDescription")," - ")

#We see that the code starts as the first 3 characters of DRG plus a white space so we try to separate by position so we write 4 

inpatient_separate <- separate(inpatient,DRG,c('DRGcode','DRGdescription'),4)

inpatient_separate <- separate(inpatient_separate, DRGDescription, c("waste","DRGDescription"),
                               3)

inpatient_separate <- select(inpatient_separate, -waste)

inpatient_separate <- separate_wider_delim(inpatient,
                                           cols=DRG,
                                           names=c('DRGcode','DRGdescription'),
                                           delim='-', too_many="merge")

inpatient_separate <- separate_wider_position(inpatient,
                                             cols=DRG,
                                             widths=c(DRGcode = 3, 3, DRGdescription=200),
                                             too_few="debug")

inpatient_separate <- inpatient_separate %>% select(-c('DRG', 'DRG_ok', 'DRG_width',
                                                       'DRG_remainder'))


#unite() function

names <- c("ID", "DBAName", "AKAName", "License", "FacilityType", "Risk", "Address",
           "City", "State", "ZIP", "InspectionDate", "InspectionType", "Results",
           "Violations", "Latitude","Longitude","Location")
inspections <- read_csv('inspections.csv',
                        col_names=names, skip=1)

glimpse(inspections)

reg_inspections <- unite(inspections, Region, City, State, sep=", ")
view(reg_inspections)


#Sometimes for our analysis its better to have both united and separated columns
reg_inspections <- unite(inspections, Region, City, State, sep=", ", remove=FALSE)

unique(reg_inspections$Region)

#Exercise 4.1
#a) Import the data-messy.xlsx file as rainfall. Pay attention to the right header.

library(tidyverse)
library(readxl) #Load the readlxl library
names <- c("Period", "LakeVictoria", "Simiyu")
rainfall <- read_excel("messy-data.xlsx", sheet="messy",
                      col_names = names, 
                      skip=3)
view(rainfall)

#b) Separate the month and the period into two columns.
rainfall_separate <- separate(rainfall, Period, c("Month", "Period"), ",")
view(rainfall_separate)

#c) Remove mm from the data where it is necessary and change the data type (to prepare for later    analysis).

rainfall_no_mm_lv  <- separate(rainfall_separate, LakeVictoria, c("LakeVictoria"), "mm")
rainfall_no_mm_final<- separate(rainfall_no_mm_lv , Simiyu, c("Simiyu"), "mm")

#d) Restructure data, the geographical location should be a variable (call it “Place”). 
# The new numeric variable should be called “rainfall”.

#We use the lobger function for restructuring the column
rainfall_no_mm_final <- rainfall_no_mm_final %>%
  pivot_longer(cols = c("LakeVictoria", "Simiyu"), 
               names_to = "Place", 
               values_to = "Rainfall")

# e) Take a look at the database now. 

view(rainfall_no_mm_final)
#Propose an additional change (and explain shortly why) and execute it.


# MY PROPOSITION IS - The rainfalll column should be a number now that we have removed mm

rainfall_no_mm_final <- rainfall_no_mm_final %>%
  mutate(Rainfall = as.numeric(Rainfall))
glimpse(rainfall_no_mm_final)

#EXERCISE 4.2
#a) Read the coffeeshop.csv file to a data frame as it is using the tidyverse library. 
library(tidyverse)

coffeeshop <- read_csv("coffeeshop.csv")
#Do not change variable types and names.

#b) The data frame is not tidy. Explain what is wrong and why.

#The dataset is not tidy, it contains redundant/repetitive column values 

#c) Using pivot functions, restructure the data frame.

coffeeshop <- coffeeshop %>%
  pivot_longer(
    cols = !Beverage_category, #We want to keep it as it is
    names_to = "Variable",
    values_to = "Value"
  )

#d) Clean the first column, it should be named ‘Beverage_category’ and should have only text, 
#but no …or numbers.
#e) Check the unique values of Total fat and Caffeine. What problems do you see with them?


