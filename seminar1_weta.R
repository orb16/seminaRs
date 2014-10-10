<<<<<<< HEAD
# R intro: basic data import and paired ttest.
=======
# R intro: basic data import and paired ttest ####
>>>>>>> caef53a4e0ba6c51b5f0f4a402badbbacfa5d947

#install package (this one is necessary for getting data off github directly)
install.packages("RCurl")
library(RCurl)

# get data
<<<<<<< HEAD
url <- getURL("https://raw.githubusercontent.com/orb16/seminaRs/master/weta.ttest2.csv")
weta.edge <- read.csv(text= url, header = T)
=======
url <- getURL("https://raw.githubusercontent.com/orb16/seminaRs/master/weta.ttest2.csv", ssl.verifypeer = FALSE)
weta.edge <- read.csv(text= url, header = TRUE) #slightly different way of reading a csv, necessary for web data.  

#if this doesn't work, use this:
weta.edge <- data.frame(
  weta = c(9,7,7,6,4,13,0,3,1,5,2,2),
  distance = rep(c("edge", "interior"), each =  6))
>>>>>>> caef53a4e0ba6c51b5f0f4a402badbbacfa5d947

# run the ttest. See we put "paired = TRUE" as the default is unpaired
weta.ttest<- t.test(weta~distance, data = weta.edge, paired = TRUE)
weta.ttest

<<<<<<< HEAD
# a different way of doing it - manually enter the data (a different way this time - spot the difference)
=======
# a different way of doing it - equivalent to comparing two different columns
>>>>>>> caef53a4e0ba6c51b5f0f4a402badbbacfa5d947
edge<-c(9,7,7,6,4,13)
interior<-c(0,3,1,5,2,2)
t.test(edge,interior, paired = TRUE)

# plot data
install.packages("ggplot2")
library(ggplot2)

ggplot(data = weta.edge, aes(x = distance, y = weta))+ 
  geom_boxplot()+
  theme_bw()
