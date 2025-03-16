#Session 2 

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

#tsv

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

#EXERCISE 2
#2.1 a

workstoppages <- read_delim("workstoppages.txt", delim = "^")
#b
glimpse(workstoppages)

#2.2 a
breakfast <- read_xlsx("breakfast.xlsx", col_names = TRUE, skip=3)# we should skip till 3 and then skip 5, not sure how to do it
glimpse(breakfast)

#b
#Renaming the columns to access them
breakfast <- read_excel("breakfast.xlsx", skip = 4, col_names = c(
  "Fiscal_Year", "Free", "Red_Price",
  "Paid", "Total", "Meals_Served", "Free_RP_of_Total_Meals"
))
glimpse(breakfast)

#transformation using mutate - this is giving an error, not sure why
breakfast <- breakfast %>%
  mutate(
    Free=Free*1000000,
    Red_Price=Red_Price*1000000,
    Paid=Paid*1000000,
    Total=Total*1000000,
    Meals_Served=Meals_Served*1000000,
    Free_RP_of_Total_Meals=Free_RP_of_Total_Meals/100
  )
glimpse(breakfast)

#Exercise 2.3
planets <- read_xlsx("planets.xlsx", sheet = "planet", col_names = FALSE)
head(planets)





