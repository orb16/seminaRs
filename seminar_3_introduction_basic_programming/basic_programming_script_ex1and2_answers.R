# calculate the square root of sepal length from iris dataset.
# 0. get rid of column 5
iris <- iris[,1:4]

# 1. via vectorized operator
sqrt(iris[,1])

# 2. via use of one of the *apply functions.
sapply(iris[,1], sqrt )

# for loop
for (i in 1:length(iris[,1])) print(sqrt(iris[i,1]))



# EXERCISE 2 ANSWERS
#~~~~~~~~~~~~~~~~~~~~~~
# Create another classification using petal length : if the length 
# is <=2, the class is “Small”, if the length is >2 and <=6, the class 
# is “Large” and if the length >6 the class is “Extra Large”.

# create a storage vector:
Petal.Size <- c(1:length(iris$Petal.Length))
Petal.Size


for ( i in 1:length(iris$Petal.Length)) 
{
  if (iris$Petal.Length[i] <= 2)
  {
    Petal.Size[i] <- "Small"
  } 
  if (iris$Petal.Length[i] > 2 & iris$Petal.Length[i] <=6)
  {
    Petal.Size[i] <- "Large"
  }
  if (iris$Petal.Length[i] >6)
  {
    Petal.Size[i] <- "Extra Large"
  }
}
Petal.Size
