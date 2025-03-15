###########################
### Session 1 Exercises ###
###########################

#1.1
#a
P <- c(seq(31, 60, 1))
P

Q <- matrix(seq(31, 60, 1), ncol=5)
Q

#b
Qt <- matrix(seq(31, 60, 1), ncol=5, byrow = TRUE)
Qt

#1.2
#a
x1 <- rnorm(100)
x2 <- rnorm(100)
x3 <- rnorm(100)

#b
t<- data.frame(a=x1, b=x1+x2, c=x1+x2+x3)
t

#c
plot(t)
#sd(t)
#plot created scatter plots pairwise
#sd did not work, columns in a data frame may contain 
#different data types, and standard deviation can be
#calculated for numerical data only.

#d
sd(t$a)
sd(t$b)
sd(t$c)

#for everything together:
tmatrix <- as.matrix(t)
sd(tmatrix)
# Attention, it works only when you have the same data type in each column.

#1.3
# Create a vector using a sequence going from 21 to 120. Give it the name “a”.
a<-seq(21,120) # this does the same aa<-21:120

# Define b as the length of a.
b<-length(a)
b

#Define d the 5th element of the vector a.

d<-a[5]

# Define f the vector containing the elements from the 2nd until the 6th.

f<-a[2:6]

# Define g the vector containing the 1st , 3rd and 7th elements of a.

g<-a[c(1,3,7)]

# Create a vector, call it h, containing the sequence of values of “a” from 1 until 100 every 4 observations.

h<-a[seq(1,100,by=4)]

# Define i the vector containing the elements bigger than 24 and smaller than 29.

i<-a[a>24&a<29]

# Create a matrix (give it the name l) with 25 rows and 4 columns containing the element of the vector a.

l<-matrix(a,25,4) # this makes the transpose of l:  t(l)

# Define m the vector containing the elements of the second column of l.

m<-l[,2]

# Define n the vector containing the elements of the third row of l.

n<-l[3,]

# Define o the vector containing the elements included from row 6 until row 12 and from column 2 until column 3 of l.

o<-l[6:12,2:3]

#1.4
#a
months <- c("Feb", "Jun", "Jul", "Apr", "Aug") 
months 

#b 
sort(months) 
## [1] "Apr" "Aug" "Feb" "Jul" "Jun" 
#They are in alphabetical order 

#c 
month_levels <- c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec") 

#d 
mymonths <- factor(months, levels = month_levels) 
mymonths 
## [1] Feb Jun Jul Apr Aug 
## Levels: Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec

#e 
sort(mymonths) 
## [1] Feb Apr Jun Jul Aug 
## Levels: Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec 
#They are in the order of months, neither in the original order, nor in alphabetical order.