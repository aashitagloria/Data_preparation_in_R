###########################
### Session 3 Exercises ###
###########################

# Religion-income problem
# Load the tidyverse
library(tidyverse)

# Read in the Pew dataset
pew <- read_csv("pew.csv")

# Let's take a look at what we have
pew

# This looks to be a gathering problem.  Our dataset is wide and we want it to be long.
# The pivot_longer (earlier gather) function can take care of that for us
pew.long <- pivot_longer(pew, !religion, names_to='income', values_to='freq')

# And what did we get?
pew.long

# Mexican weather problem
# Load the tidyverse
library(tidyverse)

# Read the dataset
weather <- read_csv("mexicanweather.csv")

# Let's look at what we have
glimpse(weather)

# And use pivot_wider() to make it wider
weather.wide <- pivot_wider(weather, names_from=element, values_from=value)

# Where are we now?
weather.wide

# My name is Bond. James Bond.
library(tidyverse)
# The bond.txt file is a tab separated file, so we need read_tsv
bond_df <- read_tsv('bond.txt')

bond_long <- pivot_longer(bond_df , -Bond, names_to="decade", values_to = "n_movies")
glimpse(bond_long)

# Alternativley, we can pipe the data set into pivot_longer
bond_df %>% pivot_longer(-Bond, names_to="decade", values_to = "n_movies")

bond_long <- pivot_longer(bond_df,
    -Bond, 
    names_to = "decade", 
    values_to = "n_movies", 
    values_drop_na = TRUE,
    names_transform = list(decade = as.integer)
  )

# Alternativley, we can pipe the data set into pivot_longer
bond_df %>% 
  # Pivot the data to long format
  pivot_longer(
    -Bond, 
    # Overwrite the names of the two newly created columns
    names_to = "decade", 
    values_to = "n_movies", 
    # Drop na values
    values_drop_na = TRUE,
    # Transform the decade column data type to integer
    names_transform = list(decade = as.integer)
  )

glimpse(bond_long)

# Pluto is a dog next to Uranus? 
#a
library(readxl)
planet_df <- read_excel("planets.xlsx", sheet = 2)
planet_df
#b

planet_long <- planet_df %>%
  pivot_longer(-metric, names_to = "planet")

planet_wide <- planet_long %>% 
  pivot_wider(names_from = metric, values_from = value)

planet_df <- planet_df %>%
  # Pivot all columns except metric to long format
  pivot_longer(-metric, names_to = "planet") %>% 
  # Put each metric in its own column
  pivot_wider(names_from = metric, values_from = value)
planet_df

#c
planet_df <- planet_df %>% 
  mutate(mass = as.numeric(mass),
         diameter = as.double(diameter),
         gravity = as.double(gravity),
         length_of_day = as.double(length_of_day),
         distance_from_sun = as.double(distance_from_sun),
         mean_temperature = as.double(mean_temperature),
         surface_pressure = as.double(surface_pressure),
         number_of_moons = as.integer(number_of_moons)
         )
planet_df
glimpse(planet_df)


#c alternative
planet_df <- planet_df %>% 
  mutate_at(vars(2:8), funs(as.double)) %>%
  mutate_at(vars(number_of_moons), funs(as.integer))
glimpse(planet_df)

#c alternative (most up-to-date)
planet_df <- planet_df %>% 
  mutate(across(2:8, as.double)) %>%
  mutate(across(number_of_moons, as.integer))
glimpse(planet_df)

#Ex3.1
S3_1 <- read_csv("injuries.csv")

S3_1 <- S3_1 %>%
  pivot_longer(
    cols = -c(type, injury_mechanism), # exculding the columns type and injury_mechanism
    names_to = "age_group",
    values_to = "count"
  )
S3_1
glimpse(S3_1)

#Ex3.2
S3_2 <- read_csv('athletes.csv')

S3_2.long <- S3_2 %>% pivot_longer(!athlete,
                        names_to = "Training",
                        values_to = "BMP")

perf.sep <- S3_2.long %>% separate(Training,
                                   c("Training", "value"),
                                   sep = '.HR')

perf.wide <- perf.sep %>% pivot_wider(names_from = value,
                                      values_from = BMP)

