#Question 1: What is wrong with the following code? How would you fix it?
df <- data.frame(A = c(1, 2, NA, 4), B = c(5, 6, 7, 8))
df <- filter(df, !is.na(A | B))

# SOLUTION:
df <- filter(df, !is.na(A) & !is.na(B))

# Reasoning: Instead of checking each column for missing values, it performs a logical OR operation on the entire columns, instead we should check for na values seperately in A and B

#Question 2: What is wrong with this regular expression for extracting email addresses? Fix the mistake.
emails <- str_extract_all(text, "[a-zA-Z0-9_.]+@[a-zA-Z_]+\\.[a-zA-Z]+")

#SOLUTUON:
emails <- str_extract_all(text, "[a-zA-Z0-9_.]+@[a-zA-Z0-9]+\\.[a-zA-Z]+")

#Reasoning: The issue is with the domain part of the regex. The pattern [a-zA-Z_]+ allows underscores and excludes digits, which isn't typical for domain names. 
#A corrected version replaces [a-zA-Z_]+ with [a-zA-Z0-9]+ to allow letters and digits:

#Question 3: Fill in the missing function to replace all missing values in column Price with the mean of that column:
#df$Price[is.na(df$Price)] <- __________(df$Price, na.rm = TRUE)

#SOLUTION: 
df$Price[is.na(df$Price)] <- mean(df$Price, na.rm = TRUE)

#Question 4: Match the regular expression pattern to its purpose.

#(a) Extract email addresses \\w+@\\w+\\.\\w+ 
#(b) Extract numbers \\d+ 
#(c) Find three-letter uppercase codes [A-Z]{3} 

#Question 5: Match each R function to the type of data it is used to load.
#Function Data Type
#1. JSON File: fromJSON()
#2. CSV File: read.csv() 
#3. Excel File: read_excel() 
#4. R Serialized Objec: readRDS() 

#Question 6: Match each function to its correct purpose.

#1. Convert wide format to long format: pivot_longer()
#2. Convert long format to wide format: pivot_wider() 
#3. Split a column into multiple columns: separate() 
#4. Merge multiple columns into one: unite() 

#Question 7: Match the method with the correct way it identifies outliers.

boxplot.stats(df$column)$out #Identifies outliers using the interquartile range (IQR) method

abs(scale(df$column)) #Identifies outliers based on standard deviation (z-score method)

df %>% filter(df$column > mean(df$column, na.rm = TRUE) + 3 * sd(df$column, na.rm = TRUE)) #Filters extreme values beyond 3 standard deviations from the mean

quantile(df$column, probs = c(0.05, 0.95), na.rm = TRUE) #Finds the 5th and 95th percentile to detect potential outliers


#Question 8: You receive a dataset df with duplicate rows. How would you remove duplicates while keeping only the first occurrence?

#SOLUTUION
library(dplyr)
df <- distinct(df)

#Question 9: A dataset contains timestamp data in different time zones. Explain how you would standardize all timestamps to UTC in R.

#SOLUTION:
# Parse the timestamps and set the original time zone
df$timestamp <- ymd_hms(df$timestamp, tz = "EST")

# Convert the timestamps to UTC
df$timestamp_utc <- with_tz(df$timestamp, tz = "UTC")

#Explanation: 
#ymd_hms() (or another appropriate constructor like mdy_hms(), dmy_hms())
#converts your timestamp strings into POSIXct objects while allowing you to set the original time zone via the tz argument.
#with_tz() converts these POSIXct objects to the target time zone ("UTC") without altering the actual moment in time.

#Question 10: What will be the result of the following filtering operation?

df <- data.frame(A = c(10, 15, 20, 25), B = c(5, 7, 10, 12))
df_filtered <- filter(df, A > 15 & B < 10)
print(df_filtered)

#SOLUTION: The filtering condition requires rows where A is greater than 15 and B is less than 10. Checking each row:

#Row 1: A = 10 (not >15), B = 5 (<10) → fails
#Row 2: A = 15 (not >15), B = 7 (<10) → fails
#Row 3: A = 20 (>15), B = 10 (not <10) → fails
#Row 4: A = 25 (>15), B = 12 (not <10) → fails
#Since no row meets both criteria, the result is an empty data frame with the same columns A and B

#Question 11: Predict the output of this R command:

str_extract_all("My number is 123-456-7890", "\\d{3,}")

#SOLUTION: The command returns a list containing one character vector with the matches:
# OUTPUT: "123" "456" "7890"
#Explanation:
#- The pattern `\\d{3,}` matches any sequence of three or more digits.  
#- In the string "My number is 123-456-7890", it matches "123", "456", and "7890".  
#- `str_extract_all()` returns these matches in a list, even if there's only one input string.

#Question 12: What does this command return?

mean(c(10, 20, 30, NA), trim = 0.2, na.rm = TRUE)

#SOLUTION: The command returns 20.

#Explanation:
#- With `na.rm = TRUE`, the `NA` value is removed, leaving the vector `c(10, 20, 30)`.  
#- The `trim = 0.2` parameter instructs R to remove 20% of observations from each end of the sorted vector. For a vector of length 3, floor(3 × 0.2) = 0 observations are trimmed from each end.  
#- Therefore, the mean is calculated on all three numbers:  \((10 + 20 + 30) / 3 = 20\).

#Question 13: Write a regex pattern to find dates in either YYYY-MM-DD or DD/MM/YYYY format.


#SOLUTION:
"\\b(?:\\d{4}-\\d{2}-\\d{2}|\\d{2}/\\d{2}/\\d{4})\\b"

#Explanation:
#\\b ensures the match is at a word boundary.
#(?: ... ) defines a non-capturing group with two alternatives separated by |:
#\\d{4}-\\d{2}-\\d{2} matches dates in the format YYYY-MM-DD
#\\d{2}/\\d{2}/\\d{4} matches dates in the format DD/MM/YYYY
#The final \\b ensures the pattern ends at a word boundary.

#Question 14: Write a regex pattern to extract website URLs that start with http:// or https://

#SOLUTION:
"https?://\\S+"

#Explanation:
#https? matches "http" followed optionally by "s" (covering both "http" and "https").
#:// matches the literal sequence "://".
#\\S+ matches one or more non-whitespace characters, effectively capturing the rest of the URL.

#Question 15: Write a regex pattern to extract all words starting with a capital letter from a text string.

"\\b[A-Z][a-zA-Z]*\\b"

#Explanation:
#\\b asserts a word boundary.
#[A-Z] matches a single uppercase letter at the beginning of a word.
#[a-zA-Z]* matches zero or more letters (both uppercase and lowercase) that follow.
#The final \\b ensures the match ends at a word boundary, capturing whole words.

#Question 16: A dataset contains missing values in multiple columns. Describe two approaches to handle them and explain when each approach is appropriate.

#How to deal with missing values.
#1. Detect them.
#2. If possible, figure out (use other sources, simple logic) to reconstruct.
#3. Interpolate, use inferences in the data to reconstruct (mean, meadian, mode)
#4. Ignore: continue with the missing data (if it is not important, if there is no reasonable way to reconstruct).

#Example of #3 
df$Price[is.na(df$Price)] <- mean(df$Price, na.rm = TRUE)

#Question 17: You have a dataset with Sales values that contain extreme outliers. Describe a robust way to handle them without removing data.

#A robust approach that handles extreme outliers without removing data is to cap the outlier values. 
#This means replacing values that exceed a reasonable threshold with that threshold value. 
#For example, if you determine from your data (or prior knowledge) that Sales values above a certain limit 
#(say the 95th percentile or a business-defined maximum) are implausible, you can "cap" them at that maximum.

#A typical workflow would be:

#Determine the Threshold:
#Use descriptive statistics or domain knowledge to set a maximum (or minimum) acceptable Sales value. For instance, you might calculate the 95th percentile.

#Cap the Outliers:
#Replace any Sales value above the threshold with the threshold value itself. This method preserves all observations but reduces the undue influence of extreme outliers.

# Calculate the 95th percentile threshold for Sales
threshold <- quantile(df$Sales, 0.95, na.rm = TRUE)

# Cap Sales values above the threshold
df$Sales <- ifelse(df$Sales > threshold, threshold, df$Sales)

#Question 18: Our dataset is about house prices in a small city near the sea. The data is coming from a
#real estate agency, and includes the land (in hectares), the size of the house (square meter), the age of
#the house (year), the number of rooms, bathrooms, garages and whether the house has a sea view.

#How many outliers are among the houses with sea view?

#SOLUTION: There are 4 outlier points in the “Yes” (sea view) group.

