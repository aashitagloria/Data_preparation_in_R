#Session 2: DATA IMPORT

library(tidyverse)

#Comma separated values (csv)

inspections <- read_csv("inspections.csv") #This file should be in the working directory 
glimpse(inspections) #This function will give information of the database

names <-c("ID", "DBAName", "AKAName", "License", 
          "FacilityType", "Risk", "Address", "City", 
          "State", "ZIP", "InspectionDate", 
          "InspectionType" ,"Results", "violations",
          "Latitude", "Longitude", "Location")
inspections <-read_csv("inspections.csv", col_names = names)
glimpse(inspections)

inspections <- read_csv("inspections.csv", col_names = names, skip = 1)
glimpse(inspections)

#Tabulator seperated values (tsv)

inpatient <- read_tsv('inpatient.tsv')
glimpse(inpatient)

names <- c("DRG", "ProviderID", "Name", "Address", "City", "State",
           "ZIP", "Region", "Discharges", "AverageCharges", "AverageTotalPayments",
           "AverageMedicarePayments")
inpatient <- read_tsv('inpatient.tsv', col_names = names, skip=1)
glimpse(inpatient)

types = 'cccccccciccc'
inpatient <- read_tsv('inpatient.tsv', col_names = names,
                      skip=1, col_types = types)
glimpse(inpatient)

types = 'cccccccciddd'
inpatient <- read_tsv('inpatient.tsv', col_names = names,
                      skip=1, col_types = types)
glimpse(inpatient)

types = 'ccccccccinnn'
inpatient <- read_tsv('inpatient.tsv', col_names = names,
                      skip=1, col_types = types)
glimpse(inpatient)

#fix width file

lengths <- c(32,50,24,NA)
names <- c("Name", "Title", "Department", "Salary")
widths <- fwf_widths(lengths, names)

employees <- read_fwf('chicagoemployees.txt', widths, skip=1)
glimpse(employees)

#excel files
library(readxl)

chickens <- read_excel("chickens.xlsx")
glimpse(chickens)

library(tidyverse)
library(rvest)

html <- read_html("https://en.wikipedia.org/w/index.php?title=The_Lego_Movie&oldid=998422565")
lego <- html_table(html_element(html, ".tracklist"))
lego

#Exercise 2.1
#a) Import the workstoppages.txt file from your working directory. Hint: find out the delimiter.
workstoppages <- read_delim("workstoppages.txt", delim = "^")

#b) Use glimpse to check the file structure.
glimpse(workstoppages)

#Exercise 2.2
#a) Import the breakfast.xlsx file from your working directory (skip unnecessary rows, add variable names as needed).
#Hint1: If it is not there, you can download from Courses, unzip, and copy to the right folder.
#Hint2: Checking the file in Excel BEFORE the operation can be very helpful.
breakfast <- read_xlsx("breakfast.xlsx", col_names = TRUE, skip=3)# we should skip till 3 and then skip 5, not sure how to do it
glimpse(breakfast)

#b) Transform your values to logical units (persons instead of millions or thousands, decimals instead of percentages).
#Hint3: mutate() can help.
#Renaming the columns to access them
breakfast <- read_excel("breakfast.xlsx", skip = 4, col_names = c(
  "Fiscal_Year", "Free", "Red_Price",
  "Paid", "Total", "Meals_Served", "Free_RP_of_Total_Meals"
))
glimpse(breakfast)

breakfast <- mutate(breakfast, 
                    #Free=Free*1000000, # This is a character so can't apply numerical operations on it
                    Free = as.numeric(Free), # Converting it into numeric value first
                    Free=Free*1000000,
                    Red_Price=Red_Price * 1000000,
                    Paid = Paid * 1000000,
                    Total = Total * 1000000,
                    Meals_Served = Meals_Served * 1000000,
                    Free_RP_of_Total_Meals=as.numeric(Free_RP_of_Total_Meals),
                    Free_RP_of_Total_Meals = Free_RP_of_Total_Meals/100 
                    #,Free_RP_of_Total_Meals = Free_RP_of_Total_Meals/100 # This is a character so can't apply numerical operations on it
                    )
glimpse(breakfast)


#Exercise 2.3
#a) Read the planets.xlsx file into a data frame planets.
 
planets <- read_xlsx("planets.xlsx", sheet = "planet", col_names = FALSE)
head(planets)

#b) Calculate the average mass of the planets (use the mean function and subsetting data as you learned in Session 1).
mean(as.numeric(planets[1, -1])) #NA value

#a) Import the “database test.sav” file.
install.packages("haven")
library(haven)

spss_table <- read_spss('database test.sav')
spss_table
glimpse(spss_table)

#b) Check the structure of this dataset. Compare the imported database as tibble, and as dataframe.
spss_table1 <- as.data.frame(spss_table)
spss_table1

#Exercise 2.5
#a) Read the Toronto project.xlsx file into a data frame toronto. Pay attention to import the data table, with
#standard variable names and skip empty rows at the beginning of the Excel worksheet.

library(readxl)
names <- c("ClinicName", "ClinicLocation", "Neighbouhood", 
           "Address", "ContactNumber", "OperationalHours",
           "Services")
toronto <- read_excel("toronto project.xlsx", 2,
                      skip = 4, col_names = names)

#b) Remove the almost empty column (that has only a variable name).
toronto <- toronto[,-3]
toronto

#Exercise 2.6
#a) Read the dogs.dta file using the right function in the tidyverse library.
library(haven)
dogs <- read_dta("dogs.dta")

#b) Glimpse it.

glimpse(dogs)



