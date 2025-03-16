#Session 6: OUTLIERS 

library(tidyverse)
whitehouse <- read_csv("whitehouse.csv", 
                       col_types="ccncci")
boxplot(whitehouse$Salary)

whitehouse %>% filter(Salary>1000000)

#It is better to put NA values in the data column of the record instead of removing the complete record 
whitehouse <- whitehouse %>%
  mutate(Salary=ifelse(Salary>1000000, NA, Salary)) #We remove these values since the people at these positions can't possibily have such high salaries

boxplot(whitehouse$Salary)

whitehouse %>% filter(Salary>200000) #We see that the position is of a senior policy advisor soit seems like it isn't an outlier

#Back to school
tests <- read_csv("testscores.csv")
summary(tests)

boxplot(tests$age)
tests %>% filter(age>15)

tests <- tests %>% #At grade2, the children is generally 7 years old, therefore at 7th grade, they're 12
  mutate(age=ifelse(studentID==10115, 7, age)) %>%
  mutate(age=ifelse(studentID==10116, 12, age))

#Alternate way to write this
tests <- tests %>%
  mutate(age=ifelse(studentID %in% c(10115,10116), grade+5,age))

boxplot(tests$age)

boxplot(tests$age~tests$grade)


#RESIDENTS

residents <- read_csv("residents.csv", 
                      col_types='iillll') #INTEGER and LOGICAL - T/F

summary(residents)

residents %>% filter(ownsHome==rentsHome)

table(residents$ownsHome, residents$rentsHome)

#Exercise 6.1
# a) Load the “dirty petal.csv” file.
iris <- read_csv("dirty petal.csv")

# b) Search for outliers and propose a solution for them. 
boxplot(iris$Sepal.Length)
boxplot(iris$Sepal.Width)
boxplot(iris$Petal.Length)
boxplot(iris$Petal.Width)

summary(iris)

# 2 or 3 outliers in Sepal.Length
filter(iris, Sepal.Length >10)

#For both of them Sepal.Length is multiplied by 10
# But seemingly the same problem for Sepal.Length and Petal Length
iris <- iris %>%
  mutate(Sepal.Length=ifelse(Sepal.Length>10, Sepal.Length/10, Sepal.Length))

filter(iris, Sepal.Length < 1)

#Maybe the Sepal was completely missing, only the petal measured.
#Replace by the mean of the species, or drop.
iris <- iris[iris$Sepal.Length>0|is.na(iris$Sepal.Length),]

# 4 outliers in Sepal.Width
boxplot(iris$Sepal.Width)

iris <- iris %>%
  mutate(Sepal.Width=ifelse(Sepal.Width>10, Sepal.Width/10, Sepal.Width))

filter(iris, Sepal.Width < 1)

#The negative should be positive
iris <- iris %>%
  mutate(Sepal.Width=ifelse(Sepal.Width<0, Sepal.Width*(-1), Sepal.Width))
#For the zero, everything else seems to be good
#Replace by the mean
iris <- iris %>%
  mutate(Sepal.Width=ifelse(Sepal.Width==0, mean(Sepal.Width, na.rm=TRUE), Sepal.Width))

#Remaining outliers can be simply big ones.

# 3 outliers in Petal.Length
boxplot(iris$Petal.Length)

filter(iris, Petal.Length > 10)

iris <- iris %>%
  mutate(Petal.Length=ifelse(Petal.Length>10, Petal.Length/10, Petal.Length))

#It is OK, but the zero!

filter(iris, Petal.Length < 1)

#Even three problems... 
# 0 is incorrect, other values are OK, replace by the mean
# 0.82: impossible to know what happened, as Sepal.Length is missing, remove it
# 0.925: impossible to know what happened, as Sepal.Width is missing, remove it

iris <- iris %>%
  mutate(Petal.Length=ifelse(Petal.Length==0, mean(Petal.Length, na.rm=TRUE), Petal.Length))

iris <- iris[iris$Petal.Length>1|is.na(iris$Petal.Length),]

summary(iris)
# No outliers in Petal.Width, but an Inf! Still an outlier.
boxplot(iris$Petal.Width)

filter(iris, Petal.Width > 10)

iris <- iris %>%
  mutate(Petal.Width=ifelse(Petal.Width==Inf, NA, Petal.Width))

summary(iris)

# c) Propose a solution for the NAs 
# using the information in the dataset only. 
# Implement your proposal.

summary(iris)

# Are they in the same rows or not?
filter(iris, is.na(Sepal.Length))
filter(iris, is.na(Sepal.Width))
filter(iris, is.na(Petal.Length))
filter(iris, is.na(Petal.Width))
# As no NA in the Species column, we can use this information.
# A possible strategy:
# - delete rows where there ar two missing values
# - replace the only missing value by the mean of the species

iris$missing <- is.na(iris$Sepal.Length)+
      is.na(iris$Sepal.Width)+
      is.na(iris$Petal.Length)+
      is.na(iris$Petal.Width)

iris <- iris %>% filter(missing<2)

#To check if it is OK.
summary(iris$missing)

# Load the tidyverse library
library(tidyverse)


# Replace missing values with the mean of the column for the given species
cleaned_iris <- iris %>%
  group_by(Species) %>% # Group by Species
  mutate(across(everything(), ~ ifelse(is.na(.), mean(., na.rm = TRUE), .))) %>%
  select(!missing)

# you can also calculate the mean of each group and species
# and use it in 12 mutates
# mean(iris$Sepal.Length[iris$Species=="setosa"], na.rm = TRUE)


#Exercise 6.2
#a) Load the “olympics.txt” file. Figure out the file type.

olympics <- read_tsv("olympics.txt")

#b) The data is not tidy. Make it tidy by pivot transformations.

olympics <- olympics %>% 
  pivot_longer(!Year, names_to = "year" , values_to="value") %>%
  pivot_wider(names_from = Year, values_from = value)

#c) Check for duplicates. Eliminate them.
olympics <- olympics %>%
  separate(col=year, into=c('year', 'mess'), sep=4) %>%
  select(!mess) %>%
  mutate(across(c(1, 3:7), as.integer))
  
olympics <- unique(olympics)

glimpse(olympics)

olympics <- olympics %>%
  filter(!`Gold Medals by African Athletes`==3001) %>%
  filter(!(year==2020))

#d) Check for outliers, propose a solution.

#Partially solved in filtering for duplicates
olympics <- olympics %>%
  mutate(`Length (Days)`=ifelse(`Length (Days)`==170, 17, `Length (Days)`))

#e) Check the coherence between variable names and content, solve the problem.
#Total gold medals and won by African athletes are mixed up.
olympics <- olympics %>%
  rename(Total_Gold_Medals = `Gold Medals by African Athletes`,
         Gold_Medals_by_African_Athletes = `Total Gold Medals`)

#Exercise 6.3
library(tidyverse)
data <- read_csv("immunization.csv")

data2 <- data %>% head(-5) 
data2[data2 == ".."] <- NA
data3 <- data2 %>% mutate(year = as.numeric(`Time`),
         c = `Country Code`,
         pop = as.numeric(`Population, total [SP.POP.TOTL]`)/ 1000000,
         mort = as.numeric(`Mortality rate, under-5 (per 1,000 live births) [SH.DYN.MORT]`),
         surv = (1000 - mort) / 100,
         imm = as.numeric(`Immunization, measles (% of children ages 12-23 months) [SH.IMM.MEAS]`),
         gdppc = as.numeric(`GDP per capita, PPP (constant 2011 international $) [NY.GDP.PCAP.PP.KD]`),
         lngdppc = log(gdppc)) %>% rename(countryname = "Country Name", countrycode = "Country Code")

data4 <- data3 %>%  select(c("year","countryname","countrycode","pop","mort","surv","imm","gdppc","lngdppc",)) %>% 
  filter(year >= 1998) 
data5 <- data4 %>% drop_na(c("imm", "mort", "pop"))

summary(data5)
number <- length(unique(data5$countryname))
miss_in <- sum(is.na(data5$gdppc))

number
miss_in

data6 <- data5 %>% select(c("year", "countrycode", "imm", "surv")) %>% arrange(year,countrycode) %>% 
  pivot_wider(names_from = c(countrycode),values_from=c(imm,surv))
