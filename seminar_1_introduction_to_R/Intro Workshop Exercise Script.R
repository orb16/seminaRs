################ R Workshop Session 1: Introduction Exercises #################
## Jennifer Bufford & Sam Brown ##
## jennifer.bufford@lincoln.ac.nz ##
## Sept 9, 2014 ##


##### Getting Started #########################################################


## Set your working directory ##
#You can use code or R Studio menus, but copy the code below


## Read Data ##
#In your email and/or on the website find the file iris.xls
#Open in excel, save as a .csv, and import into R



##### Examine the Data ########################################################


## Look at the first 5 rows and last 5 rows ##
#Hint: Use the functions head() and tail()


## What is the class of each column? ##


## How many observations are in the data set? ##


## Find the mean, standard deviation, standard error and range of each numeric column ##
#Hint: standard error is standard deviation/square root (number of observations)



##### Manipulate the Data #####################################################


## Add a column with your name as a string variable ##


## Change the column with your name to a factor ##


## Add a column that is the sum of two other columns ##
#Hint: You can add columns just like you add numbers


## Rename your data object ##



##### Install a Package #######################################################


## Install ggplot2 ##
#We will use this package at the end of the workshop


## Load ggplot2 ##




##### Use Help Files ##########################################################


## Look up ggplot ##


## Run the ggplot example code ##
#You don't have to understand what this does, just practice using help files



##### Save Your Data ##########################################################


## Save your entire workspace as .RData ##


## Save only your renamed iris dataset as YourName.RData ##


## Save your modified iris dataset as a .csv ##
#Hint: to exclude row numbers add row.names=F inside the ()



##### Document ################################################################


## Comment Your Script ##
#Add comments to explain what you did
#Only include the code that works
#Add at least one heading
#Save your entire script for future reference as a .R file (e.g. Intro Workshop.R)



##### Optional: Advanced Exercises ############################################

#Next week we'll look at data processing (data manipulation)
#Here are some exercises on subsetting (selecting only part of an object) 
#   to get you started.  Here we'll focus on subsetting from a data.frame.
#Just play around with it and see what you get - we'll talk about it in much
#   more detail next week.


## Subsetting with [] ##

data(iris) #loads R's Iris data

iris[1:5,] #selects first 5 rows, all columns
iris[,1:2] #selects all rows, first 2 columns
iris[c(1,4,7), 3] #selects 1st, 4th and 7th row and the 3rd column
#Note - you must include the comma inside the [] - that separates rows and columns


## Subsetting with $ or ""##

iris$Species #selects column named 'Species'
iris$species[1:5] #selects column named 'Species', first 5 rows

iris[,'Species'] #also selects the column named 'Species'


## Subsetting with Logic ##
#Logic means using statements that can be answered TRUE or FALSE
#Only data where the statment is answered TRUE will be shown

iris[iris$Species=="setosa",] #== means exactly equal to
#selects only rows were the value in the column "Species" is exactly "setosa"

iris[iris$Species!="setosa"] #!= means not equal to
#selects only rows where the value in the column "Species" is not "setosa"

iris[iris$Sepal.Length>7,] #>, <, >=, <= take their usual meanings
#selects only rows where the value in the column "Sepal.Length" is greater than 7

iris[iris$Petal.Length<1.5,]
#selects only rows where the value in the column "Petal.Length" is less than 1.5


## Try it Yourself ##

#Think of different combinations and try to find them
#   Example: small sepal lengths from species virginica

