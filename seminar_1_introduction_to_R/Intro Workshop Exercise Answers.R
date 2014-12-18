################ R Workshop Session 1: Introduction Exercises #################
## Jennifer Bufford & Sam Brown ##
## jennifer.bufford@lincoln.ac.nz ##
## Sept 9, 2014 ##


##### Getting Started #########################################################


## Set your working directory ##
#You can use code or R Studio menus, but copy the code below

setwd() #what you set your working directory to will be different for everyone

## Read Data ##
#In your email and/or on the website find the file iris.xls
#Open in excel, save as a .csv, and import into R

iris <- read.csv('Iris Data.csv') 
#The name of your file may be slightly different depending on how you saved it


##### Examine the Data ########################################################


## Look at the first 5 rows and last 5 rows ##
#Hint: Use the functions head() and tail()

head(iris)
tail(iris)

## What is the class of each column? ##

str(iris) #shows lots of info about the data.frame
class(iris[,1]) #shows the class of the first column

#ANSWER: numeric, numeric, numeric, numeric, factor


## How many observations are in the data set? ##

nrow(iris) #ANSWER: 150 observations

## Find the mean, standard deviation, standard error and range of each numeric column ##
#Hint: standard error is standard deviation/square root (number of observations)

#To find the mean of an individual column, you can use:
mean(iris$Sepal.Length)
mean(iris[,1])

#To find the means of many columns, try:
colMeans(iris[,1:4]) 
#you can only use the first 4 columns because the 5th column isn't numeric

#Similarly, for Std Dev:
sd(iris$Sepal.Length) #for one column (repeat this for all the columns)
apply(iris[,1:4], 2, sd) #advanced code for many columns

#To find standard error:
sd(iris$Sepal.Length)/sqrt(150) #For one column with 150 observations

apply(iris[,1:4], 2, function(x){sd(x)/sqrt(150)})
#Advanced code for many columns
#Don't worry if this doesn't make sense, we'll cover it in the next few weeks

## ANSWERS ##

#Means: 5.84, 3.06, 3.75, 1.20 (rounded to 2 decimal places)
#Std dev: 0.83, 0.44, 1.77, 0.76
#Std error: 0.07, 0.04, 0.14, 0.06



##### Manipulate the Data #####################################################


## Add a column with your name as a string variable ##

iris$myname <- "Jennifer"


## Change the column with your name to a factor ##

iris$myname <- factor(iris$myname)


## Add a column that is the sum of two other columns ##
#Hint: You can add columns just like you add numbers

iris$Sum <- iris$Sepal.Length + iris$Sepal.Width


## Rename your data object ##

myiris <- iris


#Note - your column names or new data object name may be different
#   that's fine and it doesn't really matter what you name them
#   as long as you don't use spaces or strange punctuation



##### Install a Package #######################################################


## Install ggplot2 ##
#We will use this package at the end of the workshop

install.packages('ggplot2')


## Load ggplot2 ##

library(ggplot2)



##### Use Help Files ##########################################################


## Look up ggplot ##

?ggplot


## Run the ggplot example code ##
#You don't have to understand what this does, just practice using help files

#To do this, just copy and paste from the ggplot help file
#   (Unfortunately example(ggplot) doesn't work for this package)



##### Save Your Data ##########################################################


## Save your entire workspace as .RData ##

save(list=ls(), '.RData')

## Save only your renamed iris dataset as YourName.RData ##

save(myiris, 'Jennifer.RData')


## Save your modified iris dataset as a .csv ##
#Hint: to exclude row numbers add row.names=F inside the ()

write.csv(myiris, 'My Iris Data.csv', row.names=F)



##### Document ################################################################


## Comment Your Script ##
#Add comments to explain what you did
#Only include the code that works
#Add at least one heading
#Save your entire script for future reference as a .R file (e.g. Intro Workshop.R)

## ANSWER: This script is written as an example of how to document your work
#     It only includes code that works, and it uses comments and headings to make
#       the script clearer