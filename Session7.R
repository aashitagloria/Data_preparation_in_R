#################
### Session 7 ###
#################

library(tidyverse)
library(lubridate)

# The time started at
origin

# The date today
today() # equivalent to Sys.Date() in base
as.numeric(today()) 

# The time now
now() # equivalent to Sys.time() in base
as.numeric(now())

# We can also use lubridate to create date values out of different strings
mdy("01/14/2025")
mdy("01:14:25")
dmy("14/01/25")
ymd("2025-01-14")

# And we can include times
ymd_hms("2025-01-14 10:30:26")

# Let's set that to Eastern time
ymd_hms("2025-01-14 10:30:26", tz='EST')

# We can  extract some derived values such as the weekday
wday("2025-01-14")

# or day of the year
yday("2025-01-14")

# Play with elon
elon <- mdy_hm("June 28, 1971, 07:30 AM", tz='Africa/Johannesburg')

wday(elon)
wday(elon, label=TRUE)
wday(elon, label = TRUE, abbr = FALSE) # lubridate is a bit more complex

# Lubridate provides semester, am/pm, daylight savingtime, leap_year
semester(elon)
am(elon)
dst(elon)
leap_year(elon)

# add 
year(elon) + 3

tz(elon) 

#What was the time in Tokyo?
grep("Tokyo", OlsonNames(), value = TRUE)

with_tz(elon, "Asia/Tokyo") # Japan standard time

tz(elon) 

# Zeit, bitte bleib stehen, bleib stehen
floor_date(now(), unit = "month") # round down
floor_date(now(), unit = "year")

round_date(now(), unit = "hour") # round to nearest unit

ceiling_date(now(), unit = "minutes") # round up

#Time differences
ddays(370)
days(370)

# how to calculate with Lubridate
LunarOrbit <- ddays(29) + dhours(12) + dminutes(44)
# calculate a date + lunar orbit
ymd("2024-01-31") + LunarOrbit
ymd("2025-01-31") + LunarOrbit

dmy("28 February, 2024") + years(1)
dmy("29 February, 2024") + years(1)
dmy("29 February, 2024") + dyears(1) # One "dyear" is 365.25 days
dmy("29 February, 2024") + months(1)
dmy("31 January, 2024") + months(1)
dmy("31 January, 2024") + dmonths(1) # One "dmonth" is 1/12 "dyear"

# Lubridate intervals - a fixed start time and a fixed end time

elondiff <- interval(elon, now())
elondiff/years(1) # periods understand leap years
elondiff/dyears(1) # durations don't
round(elondiff/dyears(1))


##############################################################"

#Exercise 7.1
library(tidyverse)
library(lubridate)

# Read the dataset
weather <- read_csv("mexicanweather.csv")

weather <- weather %>%
  pivot_wider(names_from = element, values_from=value)

# Let's look at what we have
weather

# We can use lubridate functions to extract elements of the date
weather <- weather %>%
  mutate(year=year(date), month=month(date), day=day(date))

weather

unique(weather$station)
# There is only one station, it is not a variable, 
# we can remove from the database.

# Exercise 7.2

#a) Store your birth time in an object mybirth. Pay attention to the right time zone.
mybirth <- mdy_hm("June 28, 1971, 07:30 AM", tz='Africa/Johannesburg')

#b) Check if you were born in a leap year, or daylight-saving time. 
leap_year(mybirth)
dst(mybirth)

#c) What day of the week?
wday(mybirth, label = TRUE, abbr= FALSE)

#d) Calculate your age in duration and period. Explain the difference between them.
mydiff <- interval(mybirth, now())
mydiff/years(1) # periods understand leap years
mydiff/dyears(1) # durations don't

#e) Calculate when you will be 20,000 days old.
mybirth + days(20000)

#f) What will be the time in Auckland then? 
grep("Auckland", OlsonNames(), value = TRUE)
with_tz(mybirth + days(20000), tz="Pacific/Auckland")

# Exercise 7.3
library(tidyverse)
#a) 
survey <- read_tsv("Survey Data For My Best Exam 2024.txt")

#b)
# do NOT
# library(janitor)
# survey <- survey %>% remove_empty(which = c("cols"))
# otherwise, it can be a great solution

summary(survey)
# Columns 19:24 have as many NAs as data entries other columns
survey <- survey[,1:18]
summary(survey)
glimpse(survey)

#c)
survey <- survey %>% rename(time = Timestamp) %>%
  mutate(time = mdy_hms(time))

sum(is.na(survey$time))

#d)
OlsonNames()
EShour <- hour(with_tz(now(), tzone = "America/El_Salvador"))

#or
EShour <- hour(with_tz(now(), 
                       tzone = grep("Salvador", OlsonNames(), value = TRUE, 
                                    ignore.case = TRUE)))

#e)
survey$`Annual salary` <- str_replace_all(survey$`Annual salary`, " ", "")
survey <- survey %>% 
  mutate(salary = as.numeric(`Annual salary`))
sum(is.na(survey$salary))
boxplot(survey$salary)


survey <- survey[survey$salary!=max(survey$salary),]
boxplot(survey$salary)
survey <- survey[survey$salary!=max(survey$salary),]
boxplot(survey$salary)
survey <- survey[survey$salary!=max(survey$salary),]
boxplot(survey$salary)

#f)
glimpse(survey)
table(survey$`Years of experience in field`, survey$`Overall years of professional experience`)

# There is a value in the 'Overall years' 31-400 years, it should be 31-40 years.
# Many people have more experience in the field than the overall, the contrary is rare.
# Almost sure that the two variables are cross-changed. 
# After renaming them, we should remove people / experience values where more field experience 
# than overall experience.

#g)
survey <- survey %>%
  mutate(field=`Overall years of professional experience`) %>%
  mutate(overall=`Years of experience in field`) %>%
  mutate(field=ifelse(field=="31 - 400 years", "31 - 40 years", field))

table(survey$field, survey$overall)
