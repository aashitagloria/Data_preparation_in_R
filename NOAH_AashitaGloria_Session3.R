#Session 3

# We study about Data structure - there are only 2 functions we study in this session - long and wide
# long - more rows less columns (fits better for analysis)
# wide - less rows, more columns

library(tidyverse)

#USING pew DATABASE

pew <- read_csv("pew.csv") # this file shows the income groups of people from different religions
view(pew) # collecting this type of data is legal in the USA but illegal to do in France

# We need to restructure the data since income is a numerical variable and it should be rep in column insteadof rows
#religion is well structured, we don't need to re-structure it so we exclude it from the long function
pew.long <- pivot_longer(pew, !religion, names_to ='income', values_to='frequency')

#USING weather DATABASE

# we want to use wide function because the coloumn called element has only 2 values TMAX and TMIN and should have its own seperate columns

weather <- read_csv("mexicanweather.csv")
weather.wide <-pivot_wider(weather, names_from=element, values_from=value) #We don't use quotation marks since the columns already exist 

#USING bodn DATABASE
#After opening the txt file, it looks like a tabular file
bond <- read_tsv('Bond.txt')
view(bond)

bond.long <-pivot_longer(bond, !Bond, names_to='decade', values_to='number_of_movies')

bond.long <- pivot_longer(bond, !Bond, 
                          names_to='decade', 
                          values_to='number of movies', 
                          values_drop_na=TRUE,
                          names_transform = list(decade=as.integer))

#USING planets DATABASE - Most difficult question 
library(readxl)
planet_df <- read_excel("planets.xlsx", sheet = 2)
#Pipe operator: %^%

planet_long <-planet_df %>%
  pivot_longer(!metric, names_to="planet")

planet_wide <-planet_long%>%
  pivot_wider(names_from=metric, 
              values_from=value)

#Better and more optimized version 
planet_df <-planet_df %>%
  pivot_longer(!metric, names_to="planet") %>%
  pivot_wider(names_from=metric,
              values_from=value)

glimpse(planet_df) #In pivot, the formats changes to character when it should be numbers so we have to mutate them

planet_df <-planet_df %>%
  mutate(mass=as.numeric(mass),
         diameter=as.numeric(diameter),
         gravity=as.numeric(gravity),
         length_of_day=as.numeric(length_of_day),
         distance_from_sun=as.numeric(distance_from_sun),
         temperature=as.numeric(mean_temperature),
         surface_pressure=as.numeric(surface_pressure),
         number_of_moons=as.integer(number_of_moons))

glimpse(planet_df)

#ALTERNATE SOLUTION FOR MUTATION OF PLANETS

planet_df <- planet_df %>%
  mutate_at(vars(2:8), funs(as.double)) %>%
  mutate_at(vars(number_of_moons), funs(as.integer))
glimpse(planet_df)

#EXERCISE 3
#Exercise 3.1
#a) Load the injuries.csv file
#library(tidyverse) I'm commenting this since we already declared it in the start of this file
injuries <- read_csv("injuries.csv")
view(injuries)

#b) Explain what is wrong with this data.
#There should be frequency and values as columns and we want type and injuries_mechanism to remain as it is

#c) Make the necessary transformation to have a tidy dataset.
injuries.long <- pivot_longer(injuries, !c(type, injury_mechanism), names_to ="frequency", values_to="values",values_drop_na=TRUE)
#We haven't learnt how to get rid of total so leaving it as it is

#d) Check if the transformation is done, and all known problems are solved.
view(injuries.long)


#EXERICSE 3.2
#a) Load the athletes.csv file.

athletes <- read_csv("athletes.csv")
view(athletes)

#b) Explain what is wrong with this data.

#We will use the long function to get min max of T1, T2,T3,T4, and T5 as columns

#c) Make the necessary transformation to have a better dataset (just one pivot at once).

athletes.long <- athletes %>%
  pivot_longer(!athlete, names_to ="variable", values_to="value")

#d) Check if the transformation is done, and all known problems are solved. Explain what should be done as the next step.

view(athletes.long)

#e) Try to find how to make the dataset wide. 

athletes.wide <- athletes.long %>%
  pivot_wider(
    names_from = variable, 
    values_from = value   
  )









