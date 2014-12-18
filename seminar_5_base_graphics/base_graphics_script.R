##We will first introduce de data.
data(iris)
##Now let's see which variables we have on this database
head(iris)

######################### PLOT ################################
?plot

##Notation
##x, y form (default)
plot(iris$Sepal.Length, iris$Sepal.Width)

##Model from (response ~ dependant)
plot(iris$Sepal.Length ~ iris$Sepal.Width)

##Model from with separate data parameter
plot(Sepal.Length ~ Petal.Width, data=iris)

##We can change the colors of the symbols
plot(Sepal.Length ~ Petal.Width, data=iris, col=11)
plot(Sepal.Length ~ Petal.Width, data=iris, col=21)

##The following function will show us some color options
colors()

## We can add or change the plotting symbol pch or the background of some of the symbols bg (the ones that we can change are 21, 22, 23, 24, and 25)
plot(Sepal.Length ~ Petal.Width, data=iris, pch=21, bg=11)
plot(Sepal.Length ~ Sepal.Width, data=iris, col="red", pch=24, bg="blue")
plot(Sepal.Length ~ Sepal.Width, data=iris, col="red", pch=23, bg="blue")
plot(Sepal.Length ~ Sepal.Width, data=iris, col=10, pch=21, bg=11)

##To see other customitzation options we will look for help
?plot

##We will add labels to the plot, the main title and the titles for the axis
plot(Sepal.Length ~ Sepal.Width, data=iris, col="red", pch=21, bg=11, main= "Sepal length vs width", xlab="Sepal width (cm)", ylab="Sepal length (cm)")

#######!!!!!!!!We can also look for more graphical parameters!!!!!!
?par

##We can change the size of symbols using cex

plot(Sepal.Length ~ Sepal.Width, data=iris, col="red", pch=21, bg=11, main= "Sepal length vs width", xlab="Sepal width (cm)", ylab="Sepal length (cm)", cex = 0.5)

plot(Sepal.Length ~ Sepal.Width, data=iris, col="red", pch=21, bg=11, main= "Sepal length vs width", xlab="Sepal width (cm)", ylab="Sepal length (cm)", cex = 3)

##In order to make the plot more useful, and to show more information we are going to add a 3rd dimension, making the species variable visible
plot(Sepal.Length ~ Sepal.Width, data=iris, col=Species, pch=21, bg=11, main= "Sepal length vs width", xlab="Sepal width (cm)", ylab="Sepal length (cm)")

##Although with the previous function we can have that 3rd dimension is better to change that variable to numeric. We will use it to distinguish the speces on colour and shape
plot(Sepal.Length ~ Sepal.Width, data=iris, col=as.numeric(Species), pch=as.numeric(Species) + 21, bg=11, main= "Sepal length vs width", xlab="Sepal width (cm)", ylab="Sepal length (cm)")



################### LEGEND #######################
##We want to add a legend, so we will look for information
?legend

##We have to decide where to put it. One way is getting the coordinates
locator(1)

$x
[1] 3.85448

$y
[1] 7.106233

legend(3.8, 7.1, legend = unique (iris$Species), col=as.numeric(unique(iris$Species)), pch=as.numeric(unique(iris$Species)) + 21)

##Another way is specifying it using 'bottomright' 'bottom' 'bottomleft' 'left' 'topleft' 'top' 'topright' 'right' or 'center'. And ajust the distance to the margins with 'inset' parameter
legend('topright', inset=.05, legend=unique(iris$Species), col=as.numeric(unique(iris$Species)), pch=as.numeric(unique(iris$Species)) + 21)

legend('bottomright', inset=.05, legend=unique(iris$Species), col=as.numeric(unique(iris$Species)), pch=as.numeric(unique(iris$Species)) + 21)



########################## LINE ##########################
##We can also add a regression line
?abline
abline(lm(Sepal.Length ~ Petal.Width, data = iris), lty = 5, lwd = 2, col = "grey")


########################## HISTOGRAMS #######################
##We can also plot histograms.
?hist
hist(iris$Sepal.Length)

##And using the help option we see that we can determine the breaks for the histogram
hist(iris$Sepal.Length, breaks=5)

##Another customization that we can do is to modify the axis of the plot
axis(1, at = seq(4, 8, by = 0.5), labels = seq(4, 8, by = 0.5))


#################### BARPLOT ##############################
##We can also do barplots
barplot(iris$Sepal.Width)

##Change its orientation 
barplot(iris$Sepal.Width, horiz=TRUE)

##To incorporate another variable we need to create a table, according with the function help
?barplot

##We are going to create a matrix (table) inside of the plotting function
barplot(table(iris$Sepal.Width, iris$Species))

##To make it more informative let's ask for two categories of the sepal width, bigger and smaller than 3 cm
barplot(table(iris$Sepal.Width > 3, iris$Species))

##Let's do a grouped barplot, with a different column for each width category
barplot(table(iris$Sepal.Width > 3, iris$Species), beside=TRUE)


########################## BOXPLOT ###########################
##The last plot is the boxplot
boxplot(iris$Sepal.Length)

##Let's look for information about it
?boxplot

##Split the values of the numeric vector (Sepal.Lenght) according to the species variable
boxplot(iris$Sepal.Length ~ iris$Species)
boxplot(iris$Sepal.Length, iris$Sepal.Width, iris$Petal.Width)



########################## MULTIPLE PLOTS ####################
?matrix
m <- matrix(c(1:3), ncol = 1, byrow = TRUE)
layout (m)
hist(iris$Sepal.Length, breaks=5)
axis(1, at = seq(4, 8, by = 0.5), labels = seq(4, 8, by = 0.5))
barplot(table(iris$Sepal.Width > 3, iris$Species), beside=TRUE)
boxplot(iris$Sepal.Length)


############################## EXPORT #############################
##And to finish, export the plot as pdf, png, jpeg. We will look for help and follow the example that R give us. We have to introduce the plot and all the modifications on the export function (pdf), and then close it.

pdf(file="Iris.pdf")
plot(Sepal.Length ~ Sepal.Width, data=iris, col=as.numeric(Species), pch=as.numeric(Species)*21, bg=11, main= "Sepal length vs width", xlab="Sepal width (cm)", ylab="Sepal length (cm)")
abline(lm(Sepal.Length ~ Petal.Width, data = iris), lty = 5, lwd = 2, col = "grey")
legend('topright', inset=.05, legend=unique(iris$Species), col=as.numeric(unique(iris$Species)), pch=as.numeric(unique(iris$Species))*21)
dev.off()

?png
png(filename="Iris.png")
plot(Sepal.Length ~ Sepal.Width, data=iris, col=as.numeric(Species), pch=as.numeric(Species)*21, bg=11, main= "Sepal length vs width", xlab="Sepal width (cm)", ylab="Sepal length (cm)")
abline(lm(Sepal.Length ~ Petal.Width, data = iris), lty = 5, lwd = 2, col = "grey")
legend('topright', inset=.05, legend=unique(iris$Species), col=as.numeric(unique(iris$Species)), pch=as.numeric(unique(iris$Species))*21)
dev.off()
