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
