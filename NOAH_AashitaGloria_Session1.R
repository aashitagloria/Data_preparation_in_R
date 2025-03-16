#SESSION 1: Variable, Vector, factor, Matrix, Data Frame, List

2+3
2*3
a = 5
b <- 5
a == 5
a == 6
a != 6

vec <- c(1, 2, 5, 13)
# This is my first comment
vec2 <- c(34, 56) #this is also a comment

vec3 <- c(1, 4,
          5)
vec4 <- 1:10 #sequence of numbers

vec5 <- seq(from=1,
            to=20,
            by=2)

gender <- c("male", "female", "male", "male", "male", "female")
gender <- factor(gender)
gender

edu <- c("h", "h", "h", "u", "u", "p", "p", "u", "h", "p")
eduord <- ordered(edu, levels=c("h", "u", "p"))
eduord

#Matrix

matrix(4,3,2) #matrix(value, number_of_rows, number_of_columns) order:row to column

matrix(data=5, nrow=2, ncol=3)

matrix(1:12, nrow=3)

matrix(1:12, nrow=3, byrow=TRUE)

matrix(1:14, nrow=3, byrow=TRUE)

mat1 <-matrix(1:14, nrow=3, byrow=TRUE)

#Second row, third column
mat1[2,3]
mat1[2:3,3:5]

mat1[c(1,3), c(1,5)]
mat1[, 3:5]
mat1[, -c(3,5)] #everything except the 3rd and 5th column

mat2 <-matrix(5, 3, 5)
mat1/mat2

#DATAFRAME
mydatafr<-data.frame(cbind(c(2,1,5),c(22,-4,11)))
colnames(mydatafr)<-c("First","Second")
mydatafr$First

#lists
a = 3
b = c(2,5)
c = matrix(4, 4, 500)
d = c("Reims", "Rouen")

mylist <-list(a,b,c,d)
mylist2 <- list(mylist, b, d)
mylist2[[2]]
mylist2[[1]]
mylist2[[1]][2]


# ---------------- EXERCISES --------------------------
#Exercise 1.1
#a) Put the numbers 31 to 60 in a vector named P and in a matrix with 6 rows and 5 columns named Q.

P <- 31:60
Q <- matrix(P,nrow=6,ncol=5)
Q

#b) Create a matrix Qt where you fill first the first row, then the second, and so on. 
Qt <- matrix(P,nrow=6,ncol=5,byrow=TRUE) #By default the order is by column, therefore, we put byrow = TRUE explicitly
Qt

#Exercise 1.2
#a) Construct three random normal vectors of 100 length. Use the rnorm() function. Name these vectors x1, x2 and x3.
x1 <- rnorm(100)
x2 <- rnorm(100)
x3 <- rnorm(100)

#b) Make a data frame called t with three columns (called a, b and c) containing respectively x1, x1+x2 and x1+x2+x3.
t <- data.frame(cbind(x1,x1+x2,x1+x2+x3))
colnames(t)<-c("a","b","c")

#c) Call the following functions for this data frame: plot(t) and sd(t). 
#Can you understand the results? (Short comment starting with # is welcome.
plot(t) #Pair-wise scattert plot was created
sd(t) #sd did not work, columns in a data frame may contain different data types, and standard deviation can becalculated for numerical data only.

# d) Modify sd(t) to get the expected results about the three variables in data frame t.
sd(t$a)
sd(t$b)
sd(t$c)

#Exercise 1.3
# Create a vector using a sequence going from 21 to 120. Give it the name “a”.
a <-seq(21:120)
a

#Define b as the length of a.
b<- length(a)
b

#Define d the 5th element of the vector a.
d <- a[5]
d

#Define f the vector containing the elements from the 2nd until the 6th.
f <- a[2:6]
f

#Define g the vector containing the 1st , 3rd and 7th elements of a.
g <- a[c(1,3,7)]
g

#Create a vector, call it h, containing the sequence of values of “a” from 1 until 100 every 4 observations.
h <-a[seq(1,100,by=4)]
h

#Define i the vector containing the elements bigger than 24 and smaller than 29.
i <-a[a>24&a<29]
i

#Create a matrix (give it the name l) with 25 rows and 4 columns containing the element of the vector a.
l <-matrix(a,nrow=25,ncol=4)
l

#Define m the vector containing the elements of the second column of l.
m <- l[,2]
m

#Define n the vector containing the elements of the third row of l.
n <- l[3,]
n

#Define o the vector containing the elements included from row 6 until row 12 and from column 2 until column 3 of l.
o <- l[6:12,2:3]
o

#Exercise 1.4
#a
months <-c("Feb", "Apr", "Jun", "Jul", "Aug")
months

#b
sort(months) # months are sorted alphabetically instead of monthwise

#c
month_levels <- c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")
month_levels

#d
mymonths <- factor(months,levels=month_levels)
print(mymonths)

#e
sorted_mymonths <- sort(mymonths)
print(sorted_mymonths) #factors are useful becasue it helps us sort monthwise instead of alphabetical order which doesn't make sense

