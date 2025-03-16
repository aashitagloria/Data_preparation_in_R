###########################
### Session 8 Exercises ###
###########################

### Class material

# Inspections
# Load the tidyverse and the food inspections dataset
library(tidyverse)

names <- c("ID", "DBAName", "AKAName", "License", "FacilityType", "Risk", "Address", 
           "City", "State", "ZIP", "InspectionDate", "InspectionType", "Results",
           "Violations", "Latitude","Longitude","Location")

inspections <- read_csv('inspections.csv',col_names=names, skip=1)

# Create a new column called Regions that combines City and State
regional_inspections <- unite(inspections,Region,City,State,sep=", ", remove=FALSE)

# And take a look at the unique regions
unique(regional_inspections$Region)

# We need to load stringr separately
library(stringr)

# Let's handle the uppercase/lowercase issues by converting everything to uppercase
regional_inspections <- regional_inspections %>%
  mutate(Region=str_to_upper(Region))

# What were the results of that?
unique(regional_inspections$Region)

# Let's take care of a few misspellings of Chicago
badchicagos <- c('CCHICAGO, IL', 'CHCICAGO, IL', 'CHICAGOCHICAGO, IL', 'CHCHICAGO, IL', 'CHICAGOI, IL')

regional_inspections <- regional_inspections %>%
  mutate(Region=ifelse(Region %in% badchicagos, 'CHICAGO, IL', Region)) 

# And see what's left
unique(regional_inspections$Region)

# There are some "CHICAGO, NA" values that we can clearly correct to "CHICAGO, IL"
regional_inspections <- regional_inspections %>%
  mutate(Region=ifelse(Region=='CHICAGO, NA', 'CHICAGO, IL', Region)) 

# But we don't know what to do with "NA, IL", "NA, NA", or "INACTIVE, IL"
# so let's set those to missing values
nachicagos <- c('NA, IL', 'NA, NA', 'INACTIVE, IL')

regional_inspections <- regional_inspections %>%
  mutate(Region=ifelse(Region %in% nachicagos, NA, Region)) 

# How did we do?
unique(regional_inspections$Region)

# McDo Forever
# Check most inspected restaurants
inspections %>%
  group_by(DBAName) %>%
  summarize(inspections=n()) %>%
  arrange(desc(inspections))

inspections <- inspections %>%
  mutate(Mcdo=str_detect(inspections$DBAName, pattern="MCDO"))

sum(inspections$Mcdo)
#alternatively
sum(str_detect(inspections$DBAName, pattern="MCDO"))

#The list of wrongly spelled McDo
wrongMcDo <- unique(str_subset(inspections$DBAName, pattern="MCDO"))
wrongMcDo

# Find alternate spellings of McDonalds
inspections %>%
  filter(grepl("McDo", DBAName, ignore.case=TRUE)) %>%
  select(DBAName) %>%
  unique() %>% 
  View()

inspections %>%
  filter(grepl("McDo", DBAName, ignore.case=TRUE)) %>%
  filter(DBAName!='SARAH MCDONALD STEELE') %>%
  select(DBAName) %>%
  unique() %>% 
  View()

# Create a vector of those alternate spellings
alternates <- inspections %>%
  filter(grepl("McDo", DBAName, ignore.case=TRUE)) %>%
  filter(DBAName!='SARAH MCDONALD STEELE') %>%
  select(DBAName) %>%
  unique() %>%
  pull(DBAName)

alternates

# Replace them all with MCDONALDS
inspections <- inspections %>%
  mutate(DBAName=ifelse(DBAName %in% alternates, 'MCDONALDS', DBAName))

# Check most inspected restaurants again
inspections %>%
  group_by(DBAName) %>%
  summarize(inspections=n()) %>%
  arrange(desc(inspections))

#####################################################################

# Exercise 8.1
# Load the tidyverse and read in the Medicare payments dataset
library(tidyverse)
names <- c("DRG", "ProviderID", "Name", "Address", "City", "State", "ZIP", "Region", "Discharges", "AverageCharges", "AverageTotalPayments", "AverageMedicarePayments")
types = 'ccccccccinnn'
inpatient <- read_tsv('inpatient.tsv', col_names = names, skip=1, col_types = types)

# Separate at the fourth position
inpatient_separate <- separate(inpatient,DRG,c('DRGcode','DRGdescription'),4)

# And take a look at the data now
glimpse(inpatient_separate)

# Trim the DRGcode field
inpatient_separate <- inpatient_separate %>%
  mutate(DRGcode=str_trim(DRGcode))

glimpse(inpatient_separate)

# The DRGdescription field has a hyphen in front so we need to do something different
inpatient_separate <- inpatient_separate %>%
  mutate(DRGdescription=str_sub(DRGdescription, 3))

glimpse(inpatient_separate)

########################################################################

#Exercise 8.2
FE_1307 = read_tsv("ForeignAid.tsv")

FE_1307$Country[FE_1307$Country %in% c("Korea–North", "Korea,N", "Korea-North", "Korea North", "N Korea", "Korea, N", "Korea, No", "Korea, North", "Korea::North", "Korea ;North", "Korea. No.", "Korea, Nor", "Korea north", "Korea xNorth")] = "North Korea"
FE_1307$Country[FE_1307$Country %in% c("Korea South", "SouthKorea", "south Korea", "So Korea", "Korea, South", "Korea: South", "Korea `South", "south korea", "Korea, So;", "Korea-South", "Korea::South")] = "South Korea"
unique(FE_1307$Country)

FE_1307$FundingAgency[FE_1307$FundingAgency %in% c("Dept of Agriculture", "Department of Argic", "Department of Agriculture", "Department - Agriculture", "Department of Agricult", "Department of agriculture")] = "Agriculture"
FE_1307$FundingAgency[FE_1307$FundingAgency %in% c("Department – State", "Department of State", "department of State", "department of State", "State Department", "Department of State", "Department Of State", "Department - State")] = "State"
FE_1307$FundingAgency[FE_1307$FundingAgency %in% c("U.S. Agency for International Development", "US Agency for International Development", "U.S. Agency f/ International Development", "U.S. Agency: International Development", "U.S. Agency for INt'l Development", "USA Agency for International Development", "International Development")] = "International Development"
FE_1307$FundingAgency[FE_1307$FundingAgency %in% c("Trade and Development Agency", "Department of Commerce", "Federal Trade Commission")] = "Commerce"
FE_1307$FundingAgency[FE_1307$FundingAgency %in% c("Department of Energy")] = "Energy"
FE_1307$FundingAgency[FE_1307$FundingAgency %in% c("Department- Health and Human Services", "Department of Health and Human Services", "Department of Health and Human Svc")] = "Health&Human"
FE_1307$FundingAgency[FE_1307$FundingAgency %in% c("Department of Justice")] = "Justice"
FE_1307$FundingAgency[FE_1307$FundingAgency %in% c("Environmental Protection Agency")] = "Environment"
FE_1307$FundingAgency[FE_1307$FundingAgency %in% c("Department of Defense", "Department of Homeland Sec")] = "Defense"
unique(FE_1307$FundingAgency)

agency = length(unique(FE_1307$FundingAgency))
agency

FE_1307$FundingAmount <-lapply(FE_1307$FundingAmount,gsub,pattern="$",fixed=TRUE,replacement="")
FE_1307$FundingAmount <-lapply(FE_1307$FundingAmount,gsub,pattern=",",fixed=TRUE,replacement="")
FE_1307$FundingAmount <-lapply(FE_1307$FundingAmount,gsub,pattern="a",fixed=TRUE,replacement="")
FE_1307$FundingAmount <-lapply(FE_1307$FundingAmount,gsub,pattern=" ",fixed=TRUE,replacement="")
FE_1307$FundingAmount <-lapply(FE_1307$FundingAmount,gsub,pattern="-",fixed=TRUE,replacement="")

FE_1307 <- FE_1307 %>%
  mutate(FundingAmount=as.numeric(FundingAmount))

#summary(FE_1307)
#boxplot(FE_1307$FundingAmount)
#hist(FE_1307$FundingAmount)

table(FE_1307$FundingAgency)

#######################################################################

# Exercise 8.3
####################
#                  #
#    Exercise a    #
#                  #
####################

text1 <- "The dragon year is 2025"

####################
#                  #
#    Exercise b    #
#                  #
####################

my_pattern <- "[0-9]"
grepl(my_pattern,text1)
## [1] TRUE

####################
#                  #
#    Exercise c    #
#                  #
####################

string_position <- gregexpr(my_pattern,text1)
string_position[[1]][1:length(string_position[[1]])]
## [1] 20 21 22 23

####################
#                  #
#    Exercise d    #
#                  #
####################

my_pattern <- "\\d[A-Z]"
grepl(my_pattern,text1)
## [1] FALSE

####################
#                  #
#    Exercise e    #
#                  #
####################

my_pattern <- "\\s"
first_space <- regexpr(my_pattern,text1)
first_space[[1]][1]
## [1] 4

####################
#                  #
#    Exercise f    #
#                  #
####################

my_pattern <- "[a-z].\\d"
grepl(my_pattern,text1)
## [1] TRUE

####################
#                  #
#    Exercise g   #
#                  #
####################

string_pos2 <- gregexpr(my_pattern,text1)[[1]][1]
string_pos2
## [1] 18

####################
#                  #
#    Exercise h    #
#                  #
####################

my_pattern <- "\\s[a-z][a-z]\\s"
string_pos3 <- gregexpr(my_pattern,text1)[[1]][1]
string_pos3
## [1] 16

####################
#                  #
#    Exercise i    #
#                  #
####################

text2 <- sub(my_pattern," is not ",text1)
text2
## [1] "The dragon year is not 2025"

####################
#                  #
#    Exercise j    #
#                  #
####################

my_pattern <- "\\d{4}$"
string_pos4 <- gregexpr(my_pattern,text2)[[1]][1]
string_pos4
## [1] 24

####################
#                  #
#    Exercise k   #
#                  #
####################

substr(text2,start = string_pos4,string_pos4+1)
## [1] "20"


