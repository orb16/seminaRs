###############################
#Final example for emulation

m <- matrix(c(1:4), ncol = 2, byrow = TRUE)

layout(m)

plot(Sepal.Width ~ Petal.Length, data = iris, pch = 21+as.numeric(Species), bg = as.numeric(Species)*3, xlab = "Petal Length (cm)", ylab = "Sepal Width (cm)", bty = "l", las = 2) 
abline(lm(Sepal.Width ~ Petal.Length, data = iris), lty = 5, lwd = 2, col = "grey")

legend(6.2, 2.5, legend = unique(iris$Species), pch = 21 + as.numeric(unique(iris$Species)), pt.bg = as.numeric(unique(iris$Species))*3)


boxplot(iris$Petal.Width ~ iris$Species, horizontal = TRUE, col = "bisque", main = "Boxplots of Iris petal widths")

hist(iris$Sepal.Length, breaks = 15, col = "light grey", main = "Iris sepal length", xlab = "Sepal Length (cm)", xaxt = "n")
axis(1, at = seq(4, 9, by = 0.5), labels = seq(4, 9, by = 0.5))


barplot(table(iris$Sepal.Width > 3, iris$Species), beside = TRUE)