#Session 8 : STRING MANIPULATION
library(tidyverse)
library(stringr)
names <- c("ID", "DBAName", "AKAName", "License", "FacilityType", "Risk", "Address",
           "City", "State", "ZIP", "InspectionDate", "InspectionType", "Results",
           "Violations", "Latitude","Longitude","Location")

inspections <- read_csv("inspections.csv", 
                        col_names=names, skip=1)
regional_inspections <- unite(inspections, 
                              Region, 
                              City, State, 
                              sep=", ", remove=FALSE)

unique(regional_inspections$Region) #To check for spelling mistakes for the same value in Region

regional_inspections <- regional_inspections %>% 
  mutate(Region=str_to_upper(Region))

unique(regional_inspections$Region)

#If therer are not too many mistakes, you can correct them manually
badchicagos <- c('CCHICAGO, IL', 'CHCICAGO, IL', 
                 'CHICAGOCHICAGO, IL', 'CHCHICAGO, IL',
                 'CHICAGOI, IL')

regional_inspections <- regional_inspections %>%
  mutate(Region=ifelse(Region %in% badchicagos, 'CHICAGO, IL', Region))

unique(regional_inspections$Region)

regional_inspections <- regional_inspections %>%
  mutate(Region=ifelse(Region=='CHICAGO, NA', 'CHICAGO, IL', Region))

nachicagos <- c('NA, IL', 'NA, NA', 'INACTIVE, IL')

regional_inspections <- regional_inspections %>%
  mutate(Region=ifelse(Region %in% nachicagos, NA, Region))

unique(regional_inspections$Region)
#String operations

str_c("Beautiful","day", sep=" ") 

str_c("Beautiful",NA, sep=" ")

str_length(c("Bruce", "Wayne"))

f<-factor(c("good","good", "moderate", "bad")) 
str_length(f)

# Extraction

str_sub(c("Bruce", "Wayne"), 1, 4) 

str_sub(c("Bruce", "Wayne"), -3, -1)

#matches

pizzas <- c("cheese", "pepperoni", "sausage and green peppers") 

str_detect(pizzas, pattern = "pepper")

str_count(pizzas, pattern = "pepper")

str_count(pizzas, pattern = "e") 

inspections %>%
  group_by(DBAName) %>%
  summarize(inspections=n()) %>%
  arrange(desc(inspections))

inspections <- inspections %>%
  mutate(Mcdo=str_detect(inspections$DBAName, pattern="MCDO"))
sum(inspections$Mcdo)

wrongMcDo <- unique(str_subset(inspections$DBAName, pattern="MCDO"))
wrongMcDo

#string split
date_ranges <- c("23.01.2017 - 29.01.2017", "30.01.2017 - 06.02.2017")
split_dates <- str_split(date_ranges, pattern = fixed(" - "))
split_dates
split_dates[[1]]

ids <- c("ID#: 192", "ID#: 118", "ID#: 001") 
id_nums <- str_replace(ids, "ID#: ", "") # To replace with nothing (used to remove things that are repeated many times)
id_nums

phone_numbers <- c("510-555-0123", "541-555-0167")
str_replace_all(phone_numbers, "-", ".") 


#REGEX

string <- "car"
pattern <- "car"
grep(pattern, string)

string <- c("car", "cars", "in a car", "truck", "car's trunk")
pattern <- "car"
grep(pattern, string)

string <- c("car", "cars", "in a car", "truck", "car's trunk")
pattern <- "car"
grepl(pattern, string)

string <- c("car", "cars", "in a car", "truck", "car's trunk")
grep("^c.r",string)

grep("^c..$",string)

grep("^c.r.$",string)

#alphanumeric

grep("\\w", c(" ", "a", "1", "A", "%", "\t"))

grepl("\\w", c(" ", "a", "1", "A", "%", "\t"))

grep("\\W", c(" ", "a", "1", "A", "%", "\t"))

grepl("\\W", c(" ", "a", "1", "A", "%", "\t"))

#whitespace

grep("\\s", c(" ", "a", "1", "A", "%", "\t"))

grep("\\S", c(" ", "a", "1", "A", "%", "\t"))

#digit

grep("\\d", c(" ", "a", "1", "A", "%", "\t"))

grep("\\D", c(" ", "a", "1", "A", "%", "\t"))

#possible values of a character 

grep("^[abc]\\w\\w", c("car", "bus", "no", "cars"))

grep("^[abc]\\w\\w$", c("car", "bus", "no", "cars")) 

grep("^[a-z][a-z][a-z]$", c("Car", "Cars", "cars","car", "no", "three:", "tic", "tac"))

#One or two digits anywhere Exactly one or two digits

grep("((\\d)|([1-9]\\d))", c("1", "20", "0", "zero", "it is 100%", "09"))

grep("^((\\d)|([1-9]\\d))$", c("1", "20", "0", "nid", "to the 100%", "09"))

grep("^((\\d)|(\\d\\d))$", c("1", "20", "0", "nid", "to the 100%", "09"))


#repeating

string <- c("a", "ab", "acb", "accb", "acccb", "accccb")
grep("ac*b", string)

grep("ac+b", string)

string <- c("a", "ab", "acb", "accb", "acccb", "accccb")
grep("ac?b", string, value=TRUE)

grep("ac{2}b", string, value = TRUE)

grep("ac{2,}b", string, value = TRUE)

grep("ac{2,3}b", string, value = TRUE)

#All lowercase letter words
grep("^([a-z]+ )*[a-z]+$", c("words", "words or sentences", "123 no", "Words"," word","word 123"))
## [1] 1 2
#Words with lowercase letters and length from 3-5
grep("^[a-z]{3,5}$", c("words", "words or sentences", "123 no", "Words"," word","word 123","hey"))
## [1] 1 7
#Signed numbers
grep("^[+-]?(0|[1-9][0-9]*)$", c("++0", "+1", "01", "-99"))

#greedy and lazy repitition 
string<-"This is a <EM>first</EM> test"
pattern<-"<.+>"
r<-regexpr(pattern,string)
regmatches(string, r)

pattern<-"<.+?>"
r<-regexpr(pattern,string)
regmatches(string, r)

#sub pattern
string <- c("(1,2)", "( -2, 7)", "( -3 , 45)", "(a, 3)")
pattern<-"\\(\\s*([+-]?(0|[1-9][0-9]*))\\s*,\\s*([+-]?(0|[1-9][0-9]*))\\s*\\)"
lidx <- !grepl(pattern, string)
komp1 <- sub(pattern, "\\1", string)
komp1[lidx] <- NA
komp2 <- sub(pattern, "\\3", string)
komp2[lidx] <- NA
as.integer(komp1)

as.integer(komp2)

#gregexpr: Finds all positions and lengths of matched patterns, and returns a list.
text<-"Yesterday I had 100 Euros, today I only have 45 Euros left."
gregexpr("(\\d+)", text)


# regmatches
text<-"Yesterday I had 100 Euros, today I only have 45 Euros left."
regmatches(text, gregexpr("\\d+",text))

fruit%>%str_subset("\\s")


text<-"Yesterday I had 100 Euros, today I only have 45 Euros left."
str_extract(text,"\\d+")

str_extract_all(text,"\\d+")

#Going back to solve the MCDONALD problem

inspections %>%
  filter(grepl("McDo", DBAName, ignore.case=TRUE)) %>%
  select(DBAName) %>%
  unique() %>% 
  View()

#grepl gives either true or false

alternates <- inspections %>%
  filter(grepl("McDo", DBAName, ignore.case=TRUE)) %>%
  filter(DBAName!='SARAH MCDONALD STEELE') %>%
  select(DBAName) %>%
  unique() %>%
  pull(DBAName) #pull function will pull out this value from the data frame

alternates

inspections <- inspections %>%
  mutate(DBAName=ifelse(DBAName %in% alternates, 
                        'MCDONALDS', 
                        DBAName))

inspections %>%
  group_by(DBAName) %>%
  summarize(inspections=n()) %>%
  arrange(desc(inspections))







