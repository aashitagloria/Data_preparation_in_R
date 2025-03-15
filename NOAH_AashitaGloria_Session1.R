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

#Exercise 1.1
#a
P <- 31:60
Q <- matrix(P,nrow=6,ncol=5)
Q

#b
Qt <- matrix(P,nrow=6,ncol=5,byrow=TRUE)
Qt

#Exercise 1.2
#a
#b
#c
#d

#Exercise 1.3

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

