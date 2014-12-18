##### data manipulation in R
# examples for the course in Lincoln
# these codes are written by Maki IKEGAMI (c) 2014

# in this session, you will learn "data.frame" in R, that is
# an essential data type for most analysis.



#####Introduction:
# First just see how data looks like using iris data set
# and plot data and start analysis. You can see how easy it will be
# once you know how to do that!

# just type followings and see what will come up 
# you may need data("iris") first depending on your version
iris
head(iris)
pairs(iris)

# or better..
pairs(iris, main = "Iris Data", pch = 21, bg = c("red", "green3", "blue")[unclass(iris$Species)])

# you may want linear regression and plot... 
plot(iris$Petal.Width,iris$Petal.Length )
lm.iris <- lm(Petal.Length ~ Petal.Width, data = iris)
abline(lm.iris)
summary(lm.iris)

# or changing colour again?
plot(iris$Petal.Width, iris$Petal.Length, pch=21, bg=c("red","green3","blue")[unclass(iris$Species)], main="Iris Data")
abline(lm.iris)

# or t test? between two species on, say, sepal length?
t.test(iris$Sepal.Length[iris$Species == "virginica"],iris$Sepal.Length[iris$Species == "setosa"])

# or boxplot and anova?
boxplot(Petal.Length ~ Species, data = iris)
plength.aov <- aov(Petal.Length ~ Species, data = iris)
anova(plength.aov)

# but to do these, first you need to learn some basics...
# first you learn "object", numeric data,  rm() function
##### end of showing R





##### Data types in R 
# now start learning very basic, "object" just start typing
x
  # an error message should show up, unless if you do something before
  # just type this and see...
x = 10 
x

# instead of "=", you can use "<-", and for putting data you should use "<-"
# this is because "=" should be used for logical functions

x <- 1 #  you can use x = 1 but please avoid
x

y <- 2
x + y

z <- x + y
z

# let's see if you use capital Y?
z <- x + Y
  # no, it does not work

# x, y, z are "objects" in R. 
# now try some numbers

11
10

1 + 10
2 * 3

1.1 * 0.1

1 / 0
0 / 0

# now learn how to erase an object
# here "rm()" is called "function", as you will see, functions process
# data (object) in R. There are lots of functions in R, but just start
# simple one

rm(x)
x

rm(y)
y

# rm() stands for remove, check help?
?rm
  # with ?rm (or any name of functions), you can have a help
  # whenever you see some new function, just check it briefly
  # this is a good way to learn too
# try a, b and c, and what you can see in R
a
b
c

# here you can see c has something "function"
c <- 1
c

# now you can see c has value
rm(c)
c

# something "function" returns!

# try something else
pi

pi <- 1
pi

rm(pi)
pi

# you can see "pi" goes back to its original value after "rm()", like "c" goes back to function
# there must be something, but you do not have to worry about what it is

iris
iris <- 1
iris
rm(iris)
iris

# "iris" is a builtin data set often used for example/demo


mean
max


# back to the slide





#####Data types
# first understand basic data types, here you will learn
# numeric (number), character (text) and logical
# you will also learn functions: mode() and class() to inspect an object

### numeric
x
x <- 1
mode(x)
class(x)

y <- 2
z <- x + y
z

### character
# to put character, you must use single/double quotations
x <- "a"
mode(x)
class(x)

y <- "b"
z <- x + y

# you can use any character in quotations, but back-slash "\"

y <- "\x"

# but in some case you can use, because these set of characters
# have some functions, 
y <- "\t"

# differences between "x" and x
z <- "x"
z

z <- x
z
  #now you can see data in object "x" move to object "z"

rm(x)
z <- x

# numbers as characters

x <- 1
y <- "2"

x
y

x + y

mode(y)
class(y)

# now you can see how to convert data type, no worry this is not important
# in this moment
x + y
x + as.numeric(y) # as.numeric converts character into numbers

as.character(x)
as.character(x) + 1

## logical, this will be important later, but not today
x <- TRUE
x
mode(x)

x <- true
x <- "true"
mode(x)

y <- FALSE
mode(y)

x <- TRUE
x + y

y <- TRUE
z <- TRUE
x + y 

x <- 1
y <- 1

x == y
x > y

# you can use T/F, but please avoid this, it is confusing
x <- T
y <- F


# other values NA/NaN/Inf, we will come back to see later

x <- NA
x

x <- 0/0
x

x <- 1/0
x

today = as.Date("2014-09-15")
today + 30

## now back to the slide











#####Data structures
# here you will learn data structures in R, vector, data.frame and list
# are important parts of this section. Matrix is a part of vectors, so
# I briefly mention here, but it is useful in many occasions in future.

##### vector
# here you are going to learn "vector"
# now you can see "c()" function. 
# this is a function to combine values into a vector (or list)

x <- c(1,2,3)
y <- c(10,11,12)

# and now check "length" of them. use "length()" function
length(x)


x <- c("x", "y","z")
length(x)

x <- c("xyz")
length(x)

x <- c("x y z")
length(x)

x <- c("10 11 12")
length(x)

# algebra on vectors
x <- c(0,1,2,3,4)
y <- c(10,11,12,13,14)

x + y
# you can calculate vectors, 
2 * x
y / x

# or sets
x <- c("a","b","c","d")
y <- c("e","f","c","d")

x == y # be careful, you must use double "="!!!

sort(y)
x == sort(y)

#some example but order(y) and see what will happen
union(x,y)
intersect(x,y)
setdiff(x,y)

# assgin names on your vector
x <- c(1:5)
y <- c("a","b","c","d","e")
names(x) <- y
x

y <- c("a","a","a","d","e")
names(x) <- y
x







# back to the slide

# access individual data in a vector
# now we learn how to access individual data in vector using index.
x <- c(10:110)
x[1]
x[5]

# actually following works too
c(10:110)[1]
c(10:110)[5]

# or you can access multiple locations if you use another set of values

x[c(1,5)]
x[c(1:5)]
x[c(1,2,4,8,16)]


# you can manipulate individual data
x[1] <- 100
x


# now learn how to use some basic functions, mean(), sd(), max(), min()
mean(x)
sd(x)
max(x)
min(x)

# and finally we learn NA/NaN/Inf
y <- c(0:100)

z <- y / x

# and now try to use sum() function
sum(z)
sum(x, na.rm = TRUE)

# now something a bit more
rm(x)
x[1] <- 1
# it does not work, you have to create an object first, remember this?

x <- c(1:100)
x[200] <- 10
# as you can see, R allocates 10 at "200", and fill "NA" between 100 and 200

# be careful for NA data, it causes problems with R function
# but at the same time "absence" data itself may have
# some meaning in your analysis! 0 and NA have different meaning

## vector calculation
x <- c(1,2,3)
y <- c(10,11,12,13,14,15)

length(x)
length(y)

x + y
# yes, you can calculate 
x <- c(1,2,3)
y <- c(10,11,12,13,14,15,16)

x + y
# you must see some warning message

1:10

x <- c(1:10)
y <- c(101:110)
x + y

x <- c(1,2,3)
y <- c("10","11","12")

x + y
x + as.numeric(y)

# do not worry for the next function, "rep()" replicates the values
# jus try rep(1,10)
rep(c("A","T","G","C"),25)
y <- rep(c("A","T","G","C"),25)

y[1]
y[1] <- "T"
y

x <- c(1:10)
mode(x)
x[1] <- "1. 0"
mode(x)

mode(x)
rm(x)







#####matrix
# matrix is a key data type, yet, it is a vector after all
# try following codes.

x <- c(11:26)
length(x)
mode(x)
class(x)

# convert is matrix with 2 X 8 dimension
x <- matrix(x, ncol = 2, nrow = 8)
length(x)
mode(x)
class(x)

# and to know each dimension..
ncol(x)
nrow(x)

### now learn how to access matrix
x[1]
x[1,1]
x[1,2]

# try this
x[9]

# actually, matrix is a "vector" with 2 dimensional attribute, 
# so you can access data like "vector" too.
# back to the slide about matrix










#####data.frame
# vector has only one mode and class, so if you add character..

x[,1] <- rep(c("A","T","G","C"),2)

length(x)
mode(x)
class(x)

# now as you can see, mode becomes "character"
# this is trouble some if you have mix type of data.
# so we can learn "data.frame" and "list" to do some realistic analysis!

rm(x)
rm(dx)

x <- c(5:9)
x <- matrix(x, ncol = 2, nrow = 8)
x

x[,2] <- c(rep("coffee",4),rep("tea",4))

dx <- data.frame(x)

# now check data length and attributes
length(dx)
mode(dx)
class(dx)

# now you may surprize, as the length of  dx is only 2!
# check the length of "x"
length(x)

# add additional column
dx[,3] <- rep(c("male","female"),2)

length(dx)

# now you can understand "length()" returns number of columns

ncol(dx)
nrow(dx)


colnames(dx) <- c("id","drink","sex")

dx[1]
# to access columns and rows, simple, but we will come back this later
dx[,1]
dx[1,]
# let's compare what we can have from "x", x is matrix
x[1]




# as you can see, matrix and data.frame return different dataset
# we will come back to this point later when we learn data.frame in detail


##### factor, for categorical data
# just go back to dx[,1]. this has some strange outputs
dx[,1]
class(dx[,1])

# what is this "factor" class?
# a factor is character with levels
# but this causes some problem, just try mean
mean(dx[,1])

# maybe we need them in numbers?
mean(as.numeric(dx[,1]))

# something really strange
# actually when you convert factors into numeric, it gives you
# values from levels! # to avoid this..

y <- as.character(dx[,1])
as.numeric(y)
mean(as.numeric(y))

# example for danger
sampledata[1,1] <- "5. 1"
sampledata[,1]
write.csv(sampledata, "sampledata.csv")
sampledata <- read.csv("sampledata.csv", header = TRUE)
sampledata$X <- NULL
sampledata[,1]


#####list
# list is a common output from functions
# you may not create your own list, but you will need to 
# know this to analyse outpus

# just try some random numbers with histogram
# here generate 1000 numbers between 0 and 100
x <- runif(1000) * 100
hist(x)
# hist() create histogram, but it also gives us some output too

hist.out <- hist(x)
mode(hist.out)
class(hist.out)
str(hist.out)

plot(hist.out)
# same as plot(x)

# now try to access each outputs and "manipulate"
hist.out$mids
hist.out$mids[2]
hist.out[1]
hist.out[1,]
  # ops! does not work? yes, unlike data.frame this does not work...

hist.out$breaks <- c(20,40,60,80)
hist.out$counts <- c(20,40,60,80)

plot(hist.out$density)


# now you suppose to undestand basic data type, numeric, character, logic
# also how to put data, inspect data type using some "function"
# and concept of data.frame. 
# now you will learn data.frame is something most important parts of 
# your future analysis, just see how "data.frame" works



##### data frame 
# here you do not have to understand what I am doing, just DO
# it's better just copy and paste anyway

default.path <- getwd()
sampledata <- iris 
head(sampledata)

write.csv(sampledata, "sampledata.csv")


# and now you must open a file from your local disc
# you have to read a file "sampledata.csv" from your working (current)
# directly

getwd() # where are you?
dir() # you can see the list of files in the folder

# so now, you can try to read your file from your working directory
# in my case, like this
sampledata <- read.table("C:/Users/ikegamim/Dropbox/R_course/data_manipulation/sampledata.csv")
# but if you can not find a path, just try following to save your time...

sampledata <- read.table("sampledata.csv")

head(sampledata)

# now you must screw up something!

sampledata <- read.table("sampledata.csv",sep = ",")

# it looks OK but not quite,
sampledata <- read.table("sampledata.csv", header = TRUE, sep = ",")

# actually next one should be straight forward...
sampledata <- read.csv("sampledata.csv", header = TRUE)

# but I hate something strange on top of that 
sampledata$X <- NULL

## now go back to the slide









# inspect data
# here we use head() and sum() and mean() functions
# use "head()", "tail()" and  "str()" functions to see data
# here you also learn "str()" function

length(sampledata)
mode(sampledata)
class(sampledata)


head(sampledata)
  # this function allows you to peak first 5 lines

head(sampledata, 10)
  # or first 10 lines..
tail(sampledata, 10)
  # or list 10 lines..

# this could work
str(sampledata)

# there are some other functions
dim(sampledata)
nrow(sampledata)
ncol(sampledata)


colnames(sampledata)
rownames(sampledata)

# or if you want to have summary
summary(sampledata)


# just additional but you can use pairs()
pairs(sampledata)




# now after seeing plots, you want to see data in each column?
# data frame is a bit like matrix, and anyway consists of vectors
# just try following and see what you will have

sampledata[1] 
sampledata[,1]
sampledata["Sepal.Length"]
sampledata[,"Sepal.Length"]
sampledata$Sepal.Length

# now you can see same data, but in different data types
# how to extract "column" data is up to what you need to do

mean(sampledata[,1])
# same examples
max(sampledata[,1])
min(sampledata[,1])

# then you try these
mean(sampledata$Sepal.Length)
mean(sampledata[,"Sepal.Length"])
mean(sampledata["Sepal.Length"])
mean(sampledata[1])
  # last two did not work, right? it is because you are putting list/data.frame
  # not a vector

mode(sampledata[1])
class(sampledata[1])

mode(sampledata[,1])
class(sampledata[,1])

# now see data again
head(sampledata)

mean(sampledata[,2])
mean(sampledata[,3])
mean(sampledata[,4])
mean(sampledata[,5])

# what is sampledata[,5]?
sampledata[,5]

mode(sampledata[,5])
class(sampledata[,5])
  # yes, it is a factor!

# some tips for accessing data
head(sampledata[-1])
head(sampledata[1])










## now access to row

sampledata[1,]
sampledata[3,]

mode(sampledata[1,])
class(sampledata[1,])

# as you can see, outputs of row data are always data.frame/list 
# this is because row contains various different data types

sampledata[c(1,2,3),]
sampledata[c(51,52,53),]
sampledata[c(51:100),]


# and now row and col
sampledata[c(1,52,103),c(1,3,5)]
# or..
sampledata[c(1,52,103),c(5,1,3)]
# do you realize the order of columns has changed?

sampledata[c(51,2,103,4),]
# as you can see, you can change the orders of rows too!


# this indexing is very useful with sample() functions
# sample(x, size, replace = FALSE, prob = NULL)
sample(150, 10, replace = FALSE, prob = NULL )
index_r = sample(150, 10, replace = FALSE, prob = NULL )
sampledata[index_r,]



# then, if you know location of "setosa" in iris, you can extract
# setosa data. setosa data is from 1 to 50 row...

sampledata[c(1:50),]
  # and now you can try versicolor and virginica

# and now you select (subset) your data! but this is a bit awkward
# there is a function call subset

subsampledata = subset(sampledata, sampledata$Petal.Length >= 4)
subsampledata

# actually there are easy ways..

subsampledata = sampledata[sampledata$Petal.Length >= 4,]
subsampledata = sampledata[sampledata$Species == "versicolor",]

# just see details, see inside
sampledata$Petal.Length >= 4
sampledata$Species == "versicolor"

# logical expressions are listed in the slide

# as you can see, subset data is based on "TRUE" or "FALSE"
# so you can manipulate it like this


list.false <- c(rep(FALSE,75),rep(TRUE,75))
sampledata[list.false,]



# followings are all same 
sampledata[c(1:50),]
subset(sampledata, sampledata$Species == "setosa")
sampledata[sampledata$Species == "setosa",]


# but Subest is flexible... using "&" or "|" 
subsampledata = subset(sampledata, sampledata$Petal.Length >= 2 & sampledata$Petal.Length < 4)
subsampledata

subsampledata = subset(sampledata, sampledata$Species == "versicolor" | sampledata$Species == "setosa")
subsampledata

## if your data has "factors", "split() could be useful
## split will return list data (not in slide)


split_example = split(sampledata$Petal.Length,sampledata$Species)
split_example
class(split_example)

# how to access data in "list" object (recap)

split_example$setosa
split_example[1]
split_example[[1]
split_example["setosa"]

# if you want to access individual data
split_example$setosa[1]

# you can sort your data using "order()"
# to make it easy, just take sub sample

sub_sample <- sampledata[,4]
sub_sample

# order() function gives you the order of numbers
order(sub_sample)

sub_sample[order(sub_sample)]

order(-sub_sample)
sub_sample[order(-sub_sample)]










##### combine your data
# merge(), cbind(), rbind()
# here you can see some functions for combining your data

# first split data.fram iris based on species

setosa.data <- subset(sampledata, sampledata$Species == "setosa")
versicolor.data <- subset(sampledata, sampledata$Species == "versicolor")
virginica.data <- subset(sampledata, sampledata$Species == "virginica")

# and then combine again, I know it's a lame.
# to combine in row, your rbind()

vir.set.data <- rbind(virginica.data,setosa.data)
vir.set.data 

# as you can see, two data.frame are now combined
# now please combine vir.set.data with versicolor.data
# but make it a bit tricky, just change the locations of columns
# using "indexing"

versicolor.data.mod <- versicolor.data[c(5,4,3,2,1)]
new.set.data <- rbind(virginica.data,setosa.data,versicolor.data.mod)
new.set.data

# as you can see, even if the locations change, so long as data have 
# the same columns (same name) it works, but...

versicolor.data.mod <- versicolor.data[c(1,2,3)]
new.set.data <- rbind(virginica.data,setosa.data,versicolor.data.mod)

# or having different column names...
versicolor.data.mod <- versicolor.data[c(5,4,3,2,1)]

colnames(versicolor.data.mod) = c("1","2","3","4","5")
  #colnames() gives you column names, or let you change the names

new.set.data <- rbind(virginica.data,setosa.data,versicolor.data.mod)



# now you can see errors, so make sure two data have same number of columns
# with same names


# and now separate based on columns

Sepal.Length.data <- sampledata[1]
Petal.Length.data <- sampledata[3]
Species.data <- sampledata[5]

# and then combine, column data can be combined by cbind()

new.order.data <- cbind(Petal.Length.data,Species.data,Sepal.Length.data)
new.order.data



# and finally, merge()
# merge() function is useful to combine different data with same
# ID code, say, plot ID or species ID or whatever
# first create ID column for sample data

sampledata$ID <- c(1:150)

# and now again split data, but with ID

Sepal.Length.data <- sampledata[c(1,6)]
Petal.Length.data <- sampledata[c(3,6)]
Species.data <- sampledata[c(5,6)]


# just make it difficult. randomize the data. do you remember
# sampling function? 

sample(150, 10, replace = FALSE, prob = NULL )
index_r <-  sample(150, 150, replace = FALSE, prob = NULL )

Sepal.Length.data.rnd <- Sepal.Length.data[index_r,]

# if you use cbind, then it looks like this
cbind(Species.data, Sepal.Length.data.rnd)
test.data <- cbind(Species.data, Sepal.Length.data.rnd)

# check if this is right or not
boxplot(Sepal.Length ~ Species, data = test.data)

# original iris data shows...
boxplot(Sepal.Length ~ Species, data = iris)


# of course you do not want this, right?
merge(Species.data, Sepal.Length.data.rnd)
test.data <- merge(Species.data, Sepal.Length.data.rnd)

boxplot(Sepal.Length ~ Species, data = test.data)


#### some tips
pairs(iris, main = "Iris Data", pch = 21, bg = c("red", "green3", "blue")[unclass(iris$Species)])

c("red", "green3", "blue")[unclass(iris$Species)]

unclass(iris$Species)


