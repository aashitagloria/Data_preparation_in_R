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




