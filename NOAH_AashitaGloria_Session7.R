#Session 7: DATE AND TIME

library(tidyverse)
library(lubridate) #To use date and time, we use a new library

origin #Timeline from which date starts 

today() #Date today

now() #Time now

as.numeric(today())
as.numeric(now())

mdy("January 15 2025")
dmy("15 Jan, 2025")
dmy("15^1^25")

ymd_hms("2025_01_15 09:54:56")

ymd_hms("2025_01_15 09:54:56", tz='EST') #Eastern coast of USA time like New york

OlsonNames() #Gives you a list of timezone names

elon <- mdy_hm("June 28, 1971, 07:30 AM, ",
               tz='Africa/Johannesburg')

wday(elon) #which weekday
wday(elon,label=TRUE)

wday(elon,label=TRUE, abbr=FALSE)

?wday # to get help on this function

semester(elon)
am(elon)
dst(elon)
leap_year(elon)

year(elon)
year(elon)+3 #elon's 3rd birthday

#what was the time in Tokyo?
grep("Tokyo",OlsonNames(), value=TRUE)

with_tz(elon, "Asia/Tokyo")

tz(elon)

#Rounding
#rounding down
floor_date(now(), unit="month")
floor_date(now(), unit="minute")

#rounding up
ceiling_date(now(),unit="hour")

round_date(now(), unit='hour')

#TIME DIFFERENCE: 2 ways to measure it 
#Duration: without looking at the calender, we add time in seconds and it will work but with unexpected results
#period: one month is one month and isn't converted to seconds 

ddays(370)
days(370)

LunarOrbit <- ddays(29) + dhours(12) + dminutes(44)

ymd("2024-01=31") + LunarOrbit
ymd("2025-01-31") + LunarOrbit

dmy("28 February, 2024") + years(1) #same date but the next year
dmy("29 February, 2024") + years(1) #Next year isn't a leap year so its NA
dmy("29 February, 2024") + dyears(1) #in duration (365.25 is transformed into seconds)
dmy("31 January, 2024") + months(1) #we get NA since 31 feb doesn't exist
dmy("31 January, 2024") + dmonths(1)

#how old is Elon?

elondiff <- interval(elon, now())
elondiff

elondiff/years(1) #this is period
elondiff/dyears(1) # this is duration
round(elondiff/dyears(1))

#Exercise 7.1
#a) Read the mexicanweather.csv dataset and make it tidy.
library(lubridate)
mexican_weather <- read_csv("mexicanweather.csv")
origin
mexican_weather$date <- ymd(mexican_weather$date)

#b) Separate the year, the month, and the day. into new columns.

mexican_weather <- mexican_weather %>%
  mutate(year = year(date), 
         month = month(date), 
         day = day(date))

#c) Look at the station column. What can you propose based on unique values?

unique_values <- unique(mexican_weather$station)
unique_values #we see that there is only one type of station 

#Exercise 7.2
#a) Store your birth time in an object mybirth. Pay attention to the right time zone.

grep("Kolkata",OlsonNames(), value=TRUE) # to check what my timezone of birth is called
mybirth <- ymd_hms("2000-07-16 17:50:00", tz = "Asia/Kolkata")

#b) Check if you were born in a leap year, or daylight-saving time.

?dst() #daylight saving time function help
leap_year_born <- leap_year(mybirth)
dst(mybirth) # No, I wasn't born on a leap year

#c) What day of the week?

wday(mybirth, label = TRUE)
wday(mybirth, label = TRUE, abbr = FALSE) # without abbreviation

#d) Calculate your age in duration and period. Explain the difference between them.

age_duration <- interval(mybirth, now())/dyears(1)  # Duration in years
age_duration # we use dyears() to calculate duration and it calculates the years that have passed regardless of whether there is a leap year or not or other factors like daylight saving time

age_period <- interval(mybirth, now())/years(1)  # Period in years
age_period #we use years() function find the duration and it is stricly based on calender years 

#e) Calculate when you will be 20,000 days old.

mybirth + ddays(20000) #I hope to live this long but for fun let's see

#f) What will be the time in Auckland then? 

grep("Auckland",OlsonNames(), value=TRUE)
with_tz(mybirth + ddays(20000), "Pacific/Auckland")

#Exercise 7.3. (revision)

#a) Load the ‘Survey Data For My Best Exam 2024.txt’ file in R, using functions in the tidyverse library. Do
#NOT rename the file and do NOT edit it BEFORE loading.

library(readxl)
survey <- read_tsv("Survey Data For My Best Exam 2024.txt")

#b) Detect and remove empty columns WITHOUT the janitor package.

survey <- survey %>%
  select(where(~!all(is.na(.)))) #I realized that filter() is for rows so can't use filter function

# we need to remove the special characters
colnames(survey) <- sub("\\t", "", colnames(survey))  
colnames(survey) <- sub("\\n", "", colnames(survey)) 

#c) Rename ‘Timestamp’ to ‘time’ and transform it to the right data format. Check with a code if the
#transformation was successful and you don’t have any NAs.

survey <- survey%>%
  rename(time=Timestamp)%>%
  mutate(time=mdy_hms(time))

#d) What is the hour just now in El Salvador? Store it in a variable EShour.

grep("El_Salvador",OlsonNames(),value=TRUE)
?with_tz()

hour(with_tz(now(),"America/El_Salvador"))

#e) Look for outliers in the ‘Annual Salary’. 
#Remove the people with the 3 most extreme outliers.
#Hint: to remove spaces from the annual salary, you can use the following code.
#survey$`Annual salary` <- str_replace_all(survey$`Annual salary`, " ", "")

survey$`Annual salary` <- str_replace_all(survey$`Annual salary`, " ", "")
summary(survey)

survey$`Annual salary` <- str_replace_all(survey$`Annual salary`, " ", "") %>%
  as.numeric() #we want the numeric value


#f) Look for outliers in the `Years of experience in field` 
#and `Overall years of professional experience`columns. 
#Explain in a comment what is wrong with them.

survey$`Years of experience in field`
#to find the outlier i want to put the if condition that  if Years of experience in field  is greater than overall Years of professional experience , it is an outlier
#i made a new column of outliers
survey <- survey %>%
  mutate(outlier = if_else(`Years of experience in field` > `Overall years of professional experience`, TRUE, FALSE))



#g) Clean the `Years of experience in field` and 
#`Overall years of professional experience` columns and
#conclude on the relationship between the two variables (no statistical tools are needed). 

#i want to get rid of all the columns that have outlier as true
outliers <- survey%>%filter(outlier==TRUE)