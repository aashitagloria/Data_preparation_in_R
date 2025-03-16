###########################
### Session 2 Exercises ###
###########################

#2.1
# Load the tidyverse
library(tidyverse)

# Use the read_delim function to look at the file with a very full syntax:
stoppages <- read_delim(file='workstoppages.txt', delim='^')

glimpse(stoppages)

#2.2
# Try just reading the file without other arguments
library(readxl)
breakfast <- read_excel('breakfast.xlsx')
glimpse(breakfast)

# Try skipping three lines
breakfast <- read_excel('breakfast.xlsx', skip=3)
glimpse(breakfast)

# It looks like we need to skip five lines, which will remove the column names
# So let’s create a vector with column names
names <- c("Year", "FreeStudents", "ReducedStudents", "PaidStudents", "TotalStudents", 
           "MealsServed", "PercentFree")

# And then try reading the file again
breakfast <- read_excel('breakfast.xlsx', skip=5, col_names = names)
glimpse(breakfast)

# We can do a little quick manipulation of this tibble. 
# First, convert the numbers of students and meals to real values
breakfast <- mutate(breakfast, FreeStudents=FreeStudents*1000000,
         ReducedStudents=ReducedStudents * 1000000,
         PaidStudents = PaidStudents * 1000000,
         TotalStudents = TotalStudents * 1000000,
         MealsServed = MealsServed * 1000000,
         PercentFree = PercentFree/100)

#After learning about the pipe
#breakfast <- breakfast %>% mutate(FreeStudents=FreeStudents*1000000,
#         ReducedStudents=ReducedStudents * 1000000,
#         PaidStudents = PaidStudents * 1000000,
#         TotalStudents = TotalStudents * 1000000,
#         MealsServed = MealsServed * 1000000,
#         PercentFree = PercentFree/100)

glimpse(breakfast)

#2.3
#a
library(readxl)
planets <- read_excel('planets.xlsx', sheet=2)

#b
# The data is wrongly structured, thereby the necessary data 
# is in the first row, except the first column
mean(as.numeric(planets[1, -1]))

#2.4
#install.packages("haven")
library(haven)

#now you can read the data file
spss_table <- read_spss('database test.sav')
#check it
spss_table
#glimpse it
glimpse(spss_table)
#and see the difference between tibble and data frame
spss_table1 <- as.data.frame(spss_table)
spss_table1

#2.5
library(readxl)
names <- c("ClinicName", "ClinicLocation", "Neighbouhood", 
           "Address", "ContactNumber", "OperationalHours",
           "Services")
toronto <- read_excel("toronto project.xlsx", 2,
                      skip = 4, col_names = names)

#b
toronto <- toronto[,-3]

#2.6
#a
library(haven)
dogs <- read_dta("dogs.dta")
#b
glimpse(dogs)

