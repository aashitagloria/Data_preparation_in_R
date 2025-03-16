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

#Exercise 6.1.
#a) Load the “dirty petal.csv” file.
library(tidyverse)
dirty_petal <- read_csv("dirty_petal.csv")

head(dirty_petal)
summary(dirty_petal) # We see that Petal Width has its maximum value as infinity and therefore the mean is INF

#b) Search for outlines and propose a solution for them. Solve them with your proposal.

#finding other outliers from the boxplot
#SEPAL LENGTH
boxplot(dirty_petal$Sepal.Length,
        na.rm = TRUE)

dirty_petal %>% filter(Sepal.Length>=50)

dirty_petal <- dirty_petal %>%
  mutate(Sepal.Length=ifelse(Sepal.Length>=40 , NA, Sepal.Length)

#SEPAL WIDTH         
boxplot(dirty_petal$Sepal.Width,
        na.rm = TRUE)

#PETAL LENGTH
boxplot(dirty_petal$Petal.Length,
        na.rm = TRUE)

dirty_petal %>% filter(Petal.length>=50)

dirty_petal <- dirty_petal %>%
  mutate(Petal.Length=ifelse(Petal.Length>=10 , NA, Sepal.Length)

boxplot(dirty_petal$Petal.Length,
                 na.rm = TRUE)

boxplot(dirty_petal$Petal.Width,
        na.rm = TRUE) # NO OUTLIERS
         
#c) Propose a solution for the NAs using the information in the dataset only. Implement your proposal.

#We need remove NA values for Length and Width of Sepal and Petal altogether
clean_petal <- dirty_petal %>% drop_na() 

# Boxplot of numeric columns after removing NA
boxplot(clean_petal$Sepal.Length, clean_petal$Sepal.Width, 
        clean_petal$Petal.Length, clean_petal$Petal.Width,
        names = c("Sepal Length", "Sepal Width", "Petal Length", "Petal Width"),
        na.rm = TRUE)















