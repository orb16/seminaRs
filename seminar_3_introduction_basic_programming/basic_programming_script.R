# 1) vectorization ####
# We are talking about vectorization, and how scalars do not exist in R.
# Everything is a vector, even if you might not think it is!
is.vector(5)
is.vector(5.002)
# scalars in R are vectors of length 1. Keep this in mind throughout the seminar!

# a vectorized function
examplevect <- c(1:10)
sqrt(examplevect)

# a vectorized operator
examplevect^2

# not only this , but also 
(x <- 1:6)
(y<- 1:6)
x^y

# what if length(x) != length(y)? Recycling happens!!! CAREFUL!
(x <- 1:6)
(y<- 1:3)
x^y
# can you see what happened??

# Recycling is "silent" in R... if all goes well*, R doesn't even tell you that it is doing it.
# * in the case of recycling, well means that the longer vector length is a multiple of shorter vector length
# if this isn't the case...
(x <- 1:6)
(y<- 1:4)
x^y
# a warning is issued. The operation is still performed though! (recall the difference
# between a warning and an error)

# this isn't inherently good or bad (although it drives some people crazy). It is just the
# way R behaves, and we need to be aware of that (hence the warnings.)

# if R wasn't vectorized... what would we do??
# if R wasn't vectorized... we would use a for loop.

# 2) "for" loops ####

# For loops are iterations of the same action or operation
# over each elements of a vector.
# how do they work?
# for counter over vector {command}
for (i in 1:10){
  print(paste("I have", i, "eggs"))
}

# and an example with a character vector
animals <- c("dog","cat","unicorn")
for (i in animals){
  print(i)
}

# 2a) basic for loop examples ####

# for our square example
for (i in 1:length(examplevect)) print(examplevect[i]^2)
# compare with the vectorized version
examplevect^2

# you have to agree that examplevect^2 is a lot more concise... it is also faster,
# although you might not notice with an "average" (or very short) length of data.

# 2b) storing values and memory ####
# for loops to STORE values. in this case, memory pre-allocation is very important!
# take home message: DO NOT GROW VECTORS.

# importance of pre-allocating all the memory we need. We will see how much difference 
# this can make in terms of speed by using the handy function system.time().
# We measure how long it takes
# to create a vector made of a sequence of numbers (from 1 to 100000)

# 1. we cannot start from nothing, we said. Try the following:
for(i in 1:100000) vec[i] <- i

# we have said that we must create a "container" for our values beforehands.
# in this case we will use a vector.

# if we start with an empty vector
vec <- vector()
# by all means, let's have a look at what we have created!
head(vec)
# it is an "empty" logical vector, i.e. a vector of length zero.
# and now for the performance testing! Let's fill it up.
system.time(for(i in 1:100000) vec[i] <- i)
# it took around 10 seconds on my laptop... not very good! Can you guess what our command did?

# On the other hand, if we start with a vector filled with anything, but of the right size:
vec <- numeric(length=100000)
head(vec)
# in this case, it is filled of zeroes. The important thing is not what is inside
# the vector, but its size!
# Let's see how long it takes this time.
system.time(for(i in 1:100000) vec[i] <- i)
# it took less than one second! and let's check that the command was executed
# and actually changed the content of our vec
head(vec); tail(vec)

# it doesn't matter if you create a numeric or a logical vector, as long as it is not
# an empty one. the following is as quick as above.
vec <- rep(NA,200000)
head(vec)
system.time(for(i in 1:100000) vec[i] <- i)
head(vec); tail(vec)
vec <- vec[!is.na(vec)]

# of course, the R way of doing this all is:
# VECTORIZATION!
system.time(vec <- 1:100000)

# we will use for loops for quick plotting of multiple lines of a dataframe

## NB. for the following exercise, we will be using an example file called "traces".
# This is a binary compressed file. It is simply called "traces" in the Dropbox folder. 
# It does not have any extension (i.e. no "traces.zip", "traces.xls" or similar).
# Please do not try to "open with" anything (text editor, excel), because it won't work.
# Simply DOWNLOAD IT TO YOUR (current R session/ R project) WORKING DIRECTORY, and we will
# load it within our R workspace with the command readRDS().


# 2c) for loops for plotting ####
traces <- readRDS("traces")
View(traces)
# i need to create an x axis
xaxis <- 1:33001
# I decide to plot 3 traces
linestoplot <- c("SE1", "SE7", "SE61")
# with certain colors
cols <- c("red","blue","forestgreen","gray")

plot(xaxis, traces["SE1",], type = "l", xlab = "sampling interval", ylab = "uV", col='white')
for(i in linestoplot) {
  lines(xaxis, traces[i,], col = cols[which(linestoplot == i)])
  print(i)
  print(which(linestoplot == i))
}
legend("topright", legend = linestoplot, col = cols, lwd = 1, bty = "n")

# 3) apply family ####

# the R "correspondent" of for loops is the apply family of functions.
# using apply improves readability and clarity, and the code will therefore be
# easier to maintain. This is also part of optimization!

# 3a) apply ####
# Example 1. I want to find the maximum intensity for each of my 7 traces.
# "where" are my traces? In the dataframe traces, and
# they are "in the rows". row 1 = trace of SE1, row 4 = trace of SE8, etc
# each column is a value of intensity. Therefore to find the maximum intensity per trace
# I want to APPLY the function MAX to MARGIN=1 (across rows).
# apply() syntax: apply(X, MARGIN, FUN, ...) [have a look at help too.]
# for our example 1 I write:
apply(traces, MARGIN=1, max)
# that's it!

# Example 2. let's create a fake data-set of extremely skewed values... let's pretend we 
# collected measures of pollutants from a body of water, which happened to be quite clean.

metals <- as.data.frame(replicate(5, rgamma(200, shape=2)))
colnames(metals) <- c("Al","Cu","Fe","Zn","Pb")

# let's have a look at how each column looks... with a for loop!
for (i in colnames(metals)){
  Sys.sleep(0.1);hist(metals[,i], main=i)
}
# skim through the plots we have produced with the blue arrows.

# let's see if the variables, as they are, would pass a normality test...
# let's use apply again!
apply(metals, MARGIN=2, shapiro.test)
# and if I wanted to store the result of my call to apply...
shtest <- apply(metals, MARGIN=2, shapiro.test)
# check the structure of the object
str(shtest)
# it is a list! I can access its elements in various ways, for instance...
shtest$Al

# if I wanted to correct the skew, to try and "normalize" the data, I could do
# so with sapply
# 3b) sapply ####
# sapply and lapply apply functions to ELEMENTS of X.
logmetals <- sapply(metals, log10)
colnames(logmetals) <- c("Al","Cu","Fe","Zn","Pb")

# let's have a look at how each column looks NOW = in logmetals rather than metals!
for (i in colnames(logmetals)){
  Sys.sleep(0.1);hist(logmetals[,i], main=i)
}

# will the non normality have been corrected??
apply(logmetals, MARGIN=2, shapiro.test)

# the beauty of the apply family is that where we put max() or sqrt(), you can put ANY
# function, including your own!

### exercise 1 ####
# calculate the square root of sepal length from iris dataset, 
# using the different techniques we just learned.
# load iris
data(iris)
View(iris)

# phase zero:
# please subset iris first, to get rid of the last column, i.e. column 5, or Species
# which, being non-numeric, might throw an error at you if you try to apply functions
# to the whole dataframe....

# use any of the techniques Simon introduced last week! 
# as long as you get rid of the last column!
# once you have done this, proceed to 1!

# 1. calculate square root exploiting R's vectorization
# --- write your answer-code below ---

# 2. calculate square root using one of the apply functions
# note the difference between apply and sapply (sapply is ~ to lapply)
# apply applies a function to MARGINS of X
# sapply and lapply apply functions to elements of X.
# which one would you use in this case??
# if in doubt ask!
# --- write your answer-code below ---

# 3. calculate square root using a for loop
# --- write your answer-code below ---

# solutions are in the ex1_sessionR_answer.R script!

##########################################################################
##########################################################################

# Example 2: classifying the sepal length into size categories
# I want to create a factor variable in iris that separates 'small' sepal
# lengths and 'large' sepla lengths.

# 1st of all: I decide that the mean will be the threshold
Mean.Sepal.Length <- mean(iris$Sepal.Length)
Mean.Sepal.Length
# I create a storage ("container") vector:
Sepal.Size <- c(1:length(iris$Sepal.Length))
Sepal.Size
# Tip: if you have a ard time following what's going on, take the elements
# of code one by one and run them in the console. 

for ( i in 1:length(iris$Sepal.Length)) # What does 1:length(iris$Sepal.Length) correspond to?
{
  if (iris$Sepal.Length[i] <= Mean.Sepal.Length)
  {
    Sepal.Size[i] <- "small"
  } else 
  {
    Sepal.Size[i] <- "large"
  }
}
Sepal.Size
# now if I want to merge this to the iris dataset:
iris$Sepal.Size <- Sepal.Size
View(iris)


#~~~~~~~~~~~
# Debugging
#~~~~~~~~~~~

# Same loop, but with an error:
Sepal.Size <- c(1:length(iris$Sepal.Length))
Sepal.Size

for ( i in 1:length(iris$Sepal.Length)) # What does 1:length(iris$Sepal.Length) correspond to?
{
  if (iris$Sepal.Length[i] <= Mean.Sepal.Length)
  {
    Sepal.Size <- "small" #### I forgot the '[i]'
  } else 
  {
    Sepal.Size[i] <- "large"
  }
}
Sepal.Size

# oops. R always wait  for the brackets to be opened and closed, so if I want
# to run step by step, I have to do it manually and skip the parts with brackets.
# re-set everything to initial values:
Sepal.Size <- c(1:length(iris$Sepal.Length))
Sepal.Size
# Let's see what happens in the first step, when i = 1
i=1
iris$Sepal.Length[i] <= Mean.Sepal.Length
# TRUE, so I run what is in the 'if' bracket:
Sepal.Size <- "small"
Sepal.Size
# so I re-wrote on top of the whole Sepal.Size vector, erasing all of what happened before
# re-set everything to initial values again:
Sepal.Size <- c(1:length(iris$Sepal.Length))
Sepal.Size
# fix it:
Sepal.Size[i] <- "small"
Sepal.Size
# Check next step if you want:
i=2
iris$Sepal.Length[i] <= Mean.Sepal.Length # TRUE again
Sepal.Size[i] <- "small"
Sepal.Size
# everything seems normal, so rerun the whole loop 
for ( i in 1:length(iris$Sepal.Length)) # What does 1:length(iris$Sepal.Length) correspond to?
{
  if (iris$Sepal.Length[i] <= Mean.Sepal.Length)
  {
    Sepal.Size[i] <- "small"
  } else 
  {
    Sepal.Size[i] <- "large"
  }
}
Sepal.Size



# EXERCISE
#~~~~~~~~~
# Create another classification using petal length : if the length 
# is <=2, the class is “Small”, if the length is >2 and <=6, the class 
# is “Large” and if the length >6 the class is “Extra Large”.




#############################################################################
# FUNCTIONS
#############################################################################

# Let's see wha an unfolded function looks like:

read.table
# plenty of ifs and elses and fors! Just what we were doing...
# What does the help menu say?
?read.table

# Using the function outputs, example with lm()
model<-lm(Sepal.Length~Petal.Length, data=iris)
model
summary(model)
model$residuals
model$fitted
# etc

##Examples sec tion from the lm() function

require(graphics)

## Annette Dobson (1990) "An Introduction to Generalized Linear Models".
## Page 9: Plant Weight Data.
ctl <- c(4.17,5.58,5.18,6.11,4.50,4.61,5.17,4.53,5.33,5.14)
trt <- c(4.81,4.17,4.41,3.59,5.87,3.83,6.03,4.89,4.32,4.69)
group <- gl(2, 10, 20, labels = c("Ctl","Trt"))
weight <- c(ctl, trt)
lm.D9 <- lm(weight ~ group)
lm.D90 <- lm(weight ~ group - 1) # omitting intercept

anova(lm.D9)
summary(lm.D90)

opar <- par(mfrow = c(2,2), oma = c(0, 0, 1.1, 0))
plot(lm.D9, las = 1)      # Residuals, Fitted, ...
par(opar)





# Writing your own functions
#~~~~~~~~~~~~~~~~~~~~~~~~~~~


new.func<-function(m, n)  # my arguments are x and y
{
  result <- rank(m) - rank(n) #this is what happens to x and y when they go through the function
  return( result )
}

# Notice how x and y don not appear in the environment?? 

new.func(iris$Sepal.Length, iris$Petal.Length) # works just like a regular function
rank.diff<-new.func(iris$Sepal.Length, iris$Petal.Length) # I can store the result somewhere
barplot(rank.diff) # plot it... etc



# Now, what if I transform the iris 'for' loop that creates 'small' and 'large' categories into 
# a function?
size.factor <- function (x)
{
  Mean.Sepal.Length <- mean(x)
  Mean.Sepal.Length
  # I create a storage vector:
  Sepal.Size <- c(1:length(x))
  Sepal.Size
  # Tip: if you have a ard time following what's going on, take the elements
  # of code one by one and run them in the console. 
  
  for ( i in 1:length(x)) # What does 1:length(x) correspond to?
  {
    if (x[i] <= Mean.Sepal.Length)
    {
      Sepal.Size[i] <- "small"
    } else 
    {
      Sepal.Size[i] <- "large"
    }
  }
  return(Sepal.Size)
  
  
}

# The *only* thing I did was to replace 'iris$Sepal.Length' by 'x', and add a return() 
# x can be any of the other variables, since the mean is relative to x
# The other names don't really matter because they are in the function's environment and don't appear
# in the global one
Sepal.size <- size.factor(iris$Sepal.Length)
Petal.size <-size.factor(iris$Petal.Length)
Petal.w.size <-size.factor(iris$Petal.Width)



# Let's try for the nex one:


three.sizes <- function(x)
{
  Petal.Size <- c(1:length(x))
  Petal.Size
  
  
  for ( i in 1:length(x)) 
  {
    if (x[i] <= 2)
    {
      Petal.Size[i] <- "Small"
    } 
    if (x[i] > 2 & x[i] <=6)
    {
      Petal.Size[i] <- "Large"
    }
    if (x[i] >6)
    {
      Petal.Size[i] <- "Extra Large"
    }
  }
  return(Petal.Size)  
}

three.sizes(iris$Petal.Length)
three.sizes(iris$Sepal.Length)
three.sizes(iris$Petal.Width) # it'll work but there is no "extra large" category. That's because
# we set fixed numbers as the category bounderies. If you want the functions to be generalisable -
# and thus be able to recycle them as often as possible - you must avoid those. That's why we keep
# the 1:length(iris$Peatl.Length), instead of replacing it by the actual length of the dataframe (150).
# In this case it would not have changed anything, but imagine if you decide later on to remove 
# some rows from iris? None of the scripts would work!

## Another application, using the apply family again:
apply(iris[,1:4], 2, three.sizes)
iris.new<-cbind(iris, apply(iris[,1:4], 2, three.sizes))

